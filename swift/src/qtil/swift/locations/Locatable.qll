private import qtil.locations.Locatable
private import swift as swift

/**
 * A module to declare `Locatable`s specific to swift for use in other qtil modules.
 */
module SwiftLocatableConfig implements LocatableConfig<swift::Location> {
  class Locatable = swift::Locatable;
}
