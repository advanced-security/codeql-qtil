private import qtil.parameterization.SignatureTypes
private import qtil.inheritance.UnderlyingString
private import qtil.parameterization.Finalize

/**
 * A module for creating strings with an enum-like tag value.
 *
 * To use this module, create a type which is uniquely identified by its `toString()` member
 * predicate. Then you may refer to a tagged string by type `Tagged<YourTag>::String`.
 *
 * See `Tagged::String` for more details.
 */
module Tagged<FiniteStringableType Tag> {
  /**
   * A class for representing strings with an enum-like tag value.
   *
   * To use this class, define a type which is uniquely identified by its `toString()` member
   * predicate. Then refer to this class as `Tagged<YourTag>::String`.
   *
   * REQUIREMENTS: The toString() method of a tag must return non-overlapping results; no toString()
   * may begin with or equal the toString() result from another instance (for instance, `"foo"` and
   * `"foobar"` would be considered overlapping). The Tag type must be finite (not have
   * `bindingset[this]`) and the toString() member predicate must be reversable (not have
   * `bindingset[this]`).
   *
   * Tagged strings may be "constructed" by calling `s.make(tag, str)`, or with
   * `s.make(str).getTag() = ...`.
   *
   * Example usage:
   * ```ql
   * newtype TMyEnum = TOptionA() or TOptionB();
   * class MyEnum extends TMyEnum {
   *   string toString() {
   *     this = TOptionA() and result = "option_a"
   *     or
   *     this = TOptionB() and result = "option_b"
   *   }
   * }
   *
   * Tagged<MyEnum>::String getTaggedString() {
   *   result.make(TOptionA(), "string value")
   * }
   * ```
   */
  bindingset[this]
  class String extends Final<UnderlyingString>::Type {
    Tag tag;
    string strVal;

    String() { this = tag.toString() + strVal }

    /**
     * Holds if this tagged string has the given tag and string, which uniquely identifies and
     * therefore may "make" this instance.
     */
    bindingset[mstrVal]
    bindingset[this]
    predicate make(Tag mtag, string mstrVal) { this = mtag.toString() + mstrVal }

    /**
     * Holds if the tagged string has the given string contents, and any tag.
     *
     * To also set the tag of this string, either use `make(tag, str)`, or constrain the tag of
     * the result of this predicate with `make(str).getTag() = ...`.
     */
    bindingset[mstrVal]
    bindingset[result]
    String make(string mstrVal) {
      make(_, mstrVal) and
      result = this
    }

    /**
     * Get the tag of this tagged string.
     */
    bindingset[this]
    Tag getTag() { result = tag }

    /**
     * Holds if this tagged string has the given tag.
     */
    bindingset[this]
    predicate isTagged(Tag mtag) { tag = mtag }

    /**
     * Get the string contents of this tagged string.
     */
    bindingset[this]
    string getStr() { result = strVal }
  }
}
