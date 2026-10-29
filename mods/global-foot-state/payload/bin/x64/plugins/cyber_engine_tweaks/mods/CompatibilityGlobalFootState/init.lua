-- Main-thread shoe-state feeder. No CET Override/Observe or loader callback.
local elapsed, warmup, slots, lastError = 0, 0, nil, nil
local rows, queue = {}, {}
local valid = { Flat=true, FlatShoes=true, Lifted=true, HighHeels=true }
local function safe(fn) local ok,v=pcall(fn); if ok then return v end end
local function name(v) return safe(function() return NameToString(v) end) or '' end
local function visible(it)
  if not it then return false end
  local a=name(it:GetCurrentAppearanceName())
  return a~='' and a~='None' and a~='empty_appearance_default'
end
local function resolve(ts,owner)
  for _,slot in ipairs({'OutfitSlots.Feet','AttachmentSlots.Feet'}) do
    local it=ts:GetItemInSlot(owner,TweakDBID.new(slot))
    if visible(it) then
      if ts:MatchVisualTag(it,CName.new('HighHeels'),false) then return 'HighHeels' end
      if ts:MatchVisualTag(it,CName.new('FlatShoes'),false) or ts:MatchVisualTag(it,CName.new('force_FlatFeet'),false) then return 'FlatShoes' end
      return 'Lifted'
    end
  end
  return 'Flat'
end
local function dependencies()
  local out,seen={},{}
  local function add(n) if n and n~='' and not seen[n] then seen[n]=true;out[#out+1]=TweakDBID.new(n) end end
  add('AttachmentSlots.Legs')
  for _,record in ipairs(TweakDB:GetRecords('gamedataAttachmentSlot_Record')) do
    local n=safe(function() return record:GetID().value end)
    if type(n)=='string' then
      for _,dep in ipairs(TweakDB:GetFlat(n..'.dependencySlots') or {}) do
        if safe(function() return dep.value end)=='AttachmentSlots.Feet' then add(n);break end
      end
    end
  end
  return out
end
local function check(owner,label,ts,cache,native)
  if not owner then rows[label]=nil;return end
  -- Keep ArchiveXL's empty suffix for male/unsupported puppets unchanged.
  local original=tostring(native:GetFeetStateSuffix(ItemID.new(),owner,nil))
  if not valid[original] then return end
  local state=resolve(ts,owner)
  local row=rows[label]
  local key=tostring(owner:GetEntityID().hash)
  if not row or row.key~=key then row={key=key,pending=state,count=0};rows[label]=row end
  if row.pending~=state then row.pending=state;row.count=0 end
  row.count=row.count+1
  if row.applied~=state and row.count>=3 then
    cache:SetState(owner,state,CName.new(label))
    row.applied=state
    for _,slot in ipairs(slots) do
      local it=ts:GetItemInSlot(owner,slot)
      if visible(it) then queue[#queue+1]={owner=owner,item=it:GetItemID(),row=row,state=state} end
    end
    spdlog.info('[FootCache] '..json.encode({context=label,native=original,state=state,queued=#queue}))
  end
end
registerForEvent('onInit',function()
  spdlog.info('CompatibilityGlobalFootState 2026.10.27.4 cache feeder initialized; no native interception')
end)
registerForEvent('onUpdate',function(delta)
  elapsed=elapsed+delta
  if elapsed<0.5 then return end
  elapsed=0
  local ok,err=pcall(function()
    local player=Game.GetPlayer()
    if not player or Game.GetSystemRequestsHandler():IsPreGame() then
      warmup=0;rows={};queue={};return
    end
    warmup=warmup+0.5
    if warmup<5 then return end
    local container=Game.GetScriptableSystemsContainer()
    local cache=container:Get('CompatibilityGlobalFeet.FeetStateCache')
    local native=container:Get('PuppetStateSystem')
    if not cache or not native then return end
    local provider=name(TweakDB:GetFlat('itemsFactoryAppearanceSuffix.FeetState.scriptedSystem'))
    local legsProvider=name(TweakDB:GetFlat('itemsFactoryAppearanceSuffix.LegsState.scriptedSystem'))
    if provider~='CompatibilityGlobalFeet.FeetStateCache' or legsProvider~=provider then
      -- ArchiveXL creates these records after TweakXL reads YAML. Route only
      -- existing records, here on the ordinary update thread after load.
      for _,suffix in ipairs({'FeetState','LegsState'}) do
        local record='itemsFactoryAppearanceSuffix.'..suffix
        if not TweakDB:GetRecord(record) then return end
        assert(TweakDB:SetFlat(record..'.scriptedSystem',CName.new('CompatibilityGlobalFeet.FeetStateCache')),'Cannot route '..suffix)
        assert(TweakDB:SetFlat(record..'.scriptedFunction',CName.new('GetFeetStateSuffix')),'Cannot route function '..suffix)
      end
      spdlog.info('[FootCache] FeetState/LegsState routing initialized after ArchiveXL records exist')
    end
    if not slots then slots=dependencies() end
    local ts=Game.GetTransactionSystem()
    check(player,'player',ts,cache,native)
    local helper=container:Get('EquipmentEx.PaperdollHelper')
    if helper then
      check(safe(function() return helper:GetPuppet() end),'photo',ts,cache,native)
      check(safe(function() return helper:GetPreview():GetGamePuppet() end),'inventory',ts,cache,native)
    end
    -- At most one ordinary appearance reset per tick, after cache publication.
    local job=table.remove(queue,1)
    if job and job.row.applied==job.state then ts:ResetItemAppearance(job.owner,job.item) end
  end)
  if not ok and tostring(err)~=lastError then lastError=tostring(err);spdlog.info('[FootCache ERROR] '..lastError) end
end)
return {}
