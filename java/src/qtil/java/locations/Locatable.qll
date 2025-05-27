private import qtil.locations.Locatable
private import java

/**
 * A module to declare `Locatable`s specific to Java for use in other qtil modules.
 */
module JavaLocatableConfig implements LocatableConfig<Location> {
  class Locatable = Element;
}
