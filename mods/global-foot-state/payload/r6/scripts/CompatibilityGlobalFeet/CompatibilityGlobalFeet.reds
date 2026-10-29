module CompatibilityGlobalFeet

// Only ordinary update code writes these caches. Suffix evaluation performs no
// transaction-system calls and never enters the CET/Lua VM.
public class FeetStateCache extends ScriptableSystem {
  private let m_player: wref<GameObject>;
  private let m_photo: wref<GameObject>;
  private let m_inventory: wref<GameObject>;
  private let m_playerState: String;
  private let m_photoState: String;
  private let m_inventoryState: String;

  public func SetState(owner: wref<GameObject>, state: String, context: CName) {
    if !IsDefined(owner) { return; }
    if NotEquals(state, "Flat") && NotEquals(state, "FlatShoes") &&
       NotEquals(state, "Lifted") && NotEquals(state, "HighHeels") { return; }
    if Equals(context, n"player") {
      this.m_playerState = state;
      this.m_player = owner;
    } else {
      if Equals(context, n"photo") {
        this.m_photoState = state;
        this.m_photo = owner;
      } else {
        if Equals(context, n"inventory") {
          this.m_inventoryState = state;
          this.m_inventory = owner;
        }
      }
    }
  }

  public func GetFeetStateSuffix(item: ItemID, owner: wref<GameObject>, suffix: ref<ItemsFactoryAppearanceSuffixBase_Record>) -> String {
    let player: wref<PlayerPuppet>;
    if !IsDefined(owner) { return ""; }
    if IsDefined(this.m_player) && Equals(owner, this.m_player) { return this.m_playerState; }
    if IsDefined(this.m_photo) && Equals(owner, this.m_photo) { return this.m_photoState; }
    if IsDefined(this.m_inventory) && Equals(owner, this.m_inventory) { return this.m_inventoryState; }
    // Player previews inherit PlayerPuppet. Before the first main-thread update,
    // use the same unshod female default as ArchiveXL, without calling its loader.
    player = owner as PlayerPuppet;
    if IsDefined(player) && Equals(player.GetResolvedGenderName(), n"Female") { return "Flat"; }
    return "";
  }
}
