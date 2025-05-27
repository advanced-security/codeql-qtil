private import qtil.locations.Locatable
private import ruby as ruby

/**
 * A module to declare `Locatable`s specific to Ruby for use in other qtil modules.
 */
module RubyLocatableConfig implements LocatableConfig<ruby::Location> {
  class Locatable = ruby::Ast::AstNode;
}
