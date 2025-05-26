private import qtil.strings.Char
private import qtil.strings.Escape
private import qtil.parameterization.Finalize
private import qtil.parameterization.SignaturePredicates
private import qtil.parameterization.SignatureTypes
private import qtil.inheritance.UnderlyingString
private import qtil.inheritance.Instance
private import qtil.list.ListBuilder
private import qtil.tuple.Pair
private import qtil.tuple.Tuple

/**
 * A tuple that contains only string values, such as a csv row.
 *
 * This module can be useful to create infinite types with some basic structure.
 */
module StringTuple<Nullary::Ret<Char>::pred/0 separator> {
  private import SeparatedEscape<separator/0, emptyEscapeMap/2> as Escape

  bindingset[this]
  class Tuple extends Final<UnderlyingString>::Type {
    bindingset[this, idx]
    string get(int idx) { result = Escape::split(str(), idx) }

    bindingset[this, item]
    Tuple append(string item) { result = str() + separator() + Escape::escapeItem(item) }

    bindingset[this]
    int size() { result = count(int idx | exists(Escape::split(str(), idx))) }
  }

  // Import constructors `Tuple of2(...)` to `Tuple of8(...)` from SeparatedList module.
  // Currently adds ~4sec on its own to E2E, slower in problems() alone:
  import TypedListBuilderOf<separator/0, Tuple, string, Escape::escapeItem/1>
  // Include the `Typed` submodule, usable as `StringTuple<sep>::Typed<T, fromString>::List`.
  import TypedStringTuple<separator/0>
}

private module TypedStringTuple<Nullary::Ret<Char>::pred/0 separator> {
  module Typed<InfiniteType T, Unary<string>::Ret<T>::bindInputOutput/1 fromString> {
    bindingset[item]
    bindingset[result]
    private string toString(T item) { item = fromString(result) }

    bindingset[this]
    class Tuple extends InfInstance<StringTuple<separator/0>::Tuple>::Type {
      bindingset[this, item]
      Tuple append(T item) { result = inst().append(toString(item)) }

      bindingset[this]
      int size() { result = inst().size() }

      bindingset[this, idx]
      T get(int idx) { result = fromString(inst().get(idx)) }
    }

    // Import constructors `Tuple of2(...)` to `Tuple of8(...)` from ListBuilder module.
    import TypedListBuilderOf<separator/0, Tuple, T, toString/1>
  }
}
