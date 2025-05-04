private import qtil.parameterization.Finalize
private import qtil.parameterization.SignaturePredicates
private import qtil.parameterization.SignatureTypes
private import qtil.inheritance.UnderlyingString
private import qtil.inheritance.Instance
private import qtil.list.ListBuilder

/**
 * A tuple that contains only string values, such as a csv row.
 *
 * This module can be useful to create infinite types with some basic structure.
 */
module StringTuple<Nullary::Ret<string>::pred/0 separator> {
  bindingset[this]
  class Tuple extends Final<UnderlyingString>::Type {
    bindingset[this, idx]
    string get(int idx) { result = str().splitAt(separator(), idx) }

    bindingset[this, item]
    Tuple append(string item) { result = str() + separator() + item }

    bindingset[this]
    int size() { result = count(int idx | idx = str().indexOf(separator(), idx, 0)) }
  }

  // Import constructors `Tuple of2(...)` to `Tuple of8(...)` from SeparatedList module.
  import TypedListBuilder<separator/0, Tuple>

  // Include the `Typed` submodule, usable as `StringTuple<sep>::Typed<T, fromString>::List`.
  import TypedStringTuple<separator/0>
}

private module TypedStringTuple<Nullary::Ret<string>::pred/0 separator> {
  module Typed<InfiniteType T, Unary<string>::Ret<T>::bindInputOutput/1 fromString> {
    bindingset[result] bindingset[item]
    private string toString(T item) { item = fromString(result) }

    bindingset[this]
    class Tuple extends InfInstance<StringTuple<separator/0>::Tuple>::Type {
      bindingset[this, item]
      Tuple append(T item) { result = inst() + separator() + toString(item) }

      bindingset[this]
      int size() { result = inst().size() }

      bindingset[this, idx]
      T get(int idx) { result = fromString(inst().get(idx)) }
    }

    // Import constructors `Tuple of2(...)` to `Tuple of8(...)` from ListBuilder module.
    import TypedListBuilderOf<separator/0, Tuple, T, toString/1>
  }
}
