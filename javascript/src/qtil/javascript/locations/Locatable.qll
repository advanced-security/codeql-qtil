private import qtil.locations.Locatable
private import javascript as javascript

/**
 * A module to declare `Locatable`s specific to javascript for use in other qtil modules.
 */
module JavascriptLocatableConfig implements LocatableConfig<javascript::DbLocation> {
  class Locatable = javascript::Locatable;
}
