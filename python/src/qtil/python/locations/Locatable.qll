private import qtil.locations.Locatable
private import python as python

/**
 * A module to declare `Locatable`s specific to python for use in other qtil modules.
 */
module PythonLocatableConfig implements LocatableConfig<python::Location> {
  class Locatable = python::AstNode;
}
