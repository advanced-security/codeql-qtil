/**
 * A convenience class to help in writing infinite types that are represented by an underlying
 * string value.
 *
 * This is often desirable as it is one of the only ways to represent infinite types in QL, and one
 * of the most flexible and convenient. Occasionally, it may also be useful to represent a finite
 * backed by a string as well.
 *
 * Contains a few conveniences:
 *  - Uses `instanceof string` rather than `extends string` to hide string member predicates.
 *  - Provides a final `str()` method to retrieve the underlying string value.
 *  - Provides an overridable `toString()` method that defaults to the underlying string value.
 *  - Two-way bindingsets on `str()` for constraining to finite values.
 *
 * *Caution*: When designing an infinite type backed by a string, such as by using this class, the
 * QL evaluator engine will be severely limited in its ability to optimize the type, join orders,
 * etc. Proceed with caution.
 *
 * This class can be used in one of two ways:
 *
 * ```ql
 * import qtil.stringlytyped.UnderlyingString
 *
 * // Option 1 (most common): create a custom infinite type.
 * bindingset[this]
 * class MyInfiniteType extends UnderlyingString {
 *
 *   // Optional: implement an infinite constraint in the constructor:
 *   MyInfiniteType() { str().length() > 5 }
 *
 *   // Implement members (don't forget the bindingset):
 *   bindingset[this]
 *   string myMember() { result = str() + " is my method" }
 * }
 *
 * // Option 2: create a custom finite type backed by a string
 * class FiniteStringType extends UnderlyingString {
 * 
 *   // Properly bind str() in the constructor:
 *   FiniteStringType() { str() = ["a", "b", "c"] }
 *
 *   // Implement members normally (no bindingset required):
 *   string myMember() { result = str() + " is my method" }
 * }
 * ```
 * 
 * At this point, the members can be used to produce almost any API through string operations. For
 * instance, a set of names could be represented as a comma-separated alphabetical list. See the
 * caution above about performance.
 */
bindingset[this]
class UnderlyingString instanceof string {
  /**
   * Get the underlying string value backing this type.
   * 
   * Specifies bindingsets to allow for two-way bindings, so that the underlying string value can be
   * constrained to a finite set of values and vice versa. Specified as `final` for performance and
   * maintainability reasons.
   */
  bindingset[this] bindingset[result]
  final string str() { result = this }

  /** Default `toString()` implementation, to simply return the underlying string. */
  bindingset[this]
  string toString() { result = this }
}