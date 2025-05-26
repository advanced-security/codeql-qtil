private import qtil.locations.Locatable
private import cpp as cpp

/**
 * A module to declare `Locatable`s specific to C++ for use in other qtil modules.
 */
module CppLocatableConfig implements LocatableConfig<cpp::Location> {
  class Locatable = cpp::Locatable;
}
