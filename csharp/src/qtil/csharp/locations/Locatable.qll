private import qtil.locations.Locatable
private import csharp as csharp

/**
 * A module to declare `Locatable`s specific to C# for use in other qtil modules.
 */
module CsharpLocatableConfig implements LocatableConfig<csharp::Location> {
  class Locatable = csharp::Element;
}
