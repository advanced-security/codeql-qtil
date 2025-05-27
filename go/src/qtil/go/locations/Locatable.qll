private import qtil.locations.Locatable
private import go as go

/**
 * A module to declare `Locatable`s specific to Go for use in other qtil modules.
 */
module GoLocatableConfig implements LocatableConfig<go::DbLocation> {
  class Locatable = go::Locatable;
}
