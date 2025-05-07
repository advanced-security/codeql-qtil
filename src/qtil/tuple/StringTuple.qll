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

  /**
   * A module to finalize the string tuple, typically for performance reasons.
   * 
   * Repeatedly calling `.get(n)` on a tuple will be slow. But if the query has reached a stage
   * where the set of possible tuples is finite, you can use this module to finalize the tuple to
   * the finite result set, and extract `get(n)` in a performant way.
   * 
   * Example:
   * 
   * ```ql
   * StringTuple<...> getTuples() {
   *   // Predicate where infinite tuples are much more convenient than finite tuples.
   *   // Suppose this selects "a,b,c" and "d,e,f".
   * }
   * 
   * // Selects ["a,b,c", "a", "b", "c"], ["d,e,f", "d", "e", "f"]
   * from StringTuple<...>::Concretize<getTuples()>::Tuple3 tuple
   * select tuple.toString(), tuple.getFirst(), tuple.getSecond(), tuple.getThird()
   * ```
   */
  module Concretize<Nullary::Ret<string>::pred/0 constraint> {
    // Import class `Tuple5`, usable as `StringTuple<sep>::Concretize<constraint>::Tuple5`.
    class Tuple5 extends Instance<Tuple6<string, string, string, string, string, string, toTuple5/6>::Tuple>::Type
    {
      string toString() { result = inst().getFirst() }

      string getFirst() { result = inst().getSecond() }

      string getSecond() { result = inst().getThird() }

      string getThird() { result = inst().getFourth() }

      string getFourth() { result = inst().getFifth() }

      string getFifth() { result = inst().getSixth() }
    }

    // TODO: add the rest of classes, Pair through Tuple8
    private class RelevantString extends Final<UnderlyingString>::Type {
      RelevantString() { this = constraint() }
      // Not sure if this is will improve performance:
      // string toString() { result = this }
    }

    private predicate toPair(string str, string v1, string v2) {
      str instanceof RelevantString and
      exists(Tuple tuple |
        str = tuple and
        v1 = tuple.get(0) and
        v2 = tuple.get(1)
      )
    }

    private predicate tuple3(string v1, string v2, string v3) {
      exists(RelevantString str, Tuple tuple |
        str = tuple and
        v1 = tuple.get(0) and
        v2 = tuple.get(1) and
        v3 = tuple.get(2)
      )
    }

    private predicate tuple4(string v1, string v2, string v3, string v4) {
      exists(RelevantString str, Tuple tuple |
        str = tuple and
        v1 = tuple.get(0) and
        v2 = tuple.get(1) and
        v3 = tuple.get(2) and
        v4 = tuple.get(3)
      )
    }

    private predicate toTuple5(string str, string v1, string v2, string v3, string v4, string v5) {
      str instanceof RelevantString and
      exists(Tuple tuple |
        str = tuple and
        v1 = tuple.get(0) and
        v2 = tuple.get(1) and
        v3 = tuple.get(2) and
        v4 = tuple.get(3) and
        v5 = tuple.get(4)
      )
    }
  }
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
