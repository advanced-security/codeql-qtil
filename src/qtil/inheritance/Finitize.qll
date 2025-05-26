import qtil.parameterization.SignatureTypes
import qtil.parameterization.SignaturePredicates
import qtil.parameterization.Finalize

/**
 * A module to convert an infinite type to a finite type by constraining it to a finite set of
 * values.
 *
 * Example usage:
 * ```ql
 * // Given a predicate to constrain an infinite type, such as `string`:
 * predicate functionName(string s) { exists(Function f | f.getName() = s) }
 *
 * // Use that infinite type without a `bindingset` by applying the constraint:
 * predicate upperCaseFunctionName(Finitize<string, functionName/1>::Type str) {
 *   result = str.toUpperCase()
 * }
 * ```
 */
module Finitize<InfiniteStringableType T, Unary<T>::pred/1 constraint> {
  /**
   * Finitize an infinite type by constraining it to a finite set of values.
   *
   * This module provides a way to create a finite version of an infinite type by applying a
   * constraint that limits the possible values of the type.
   */
  class Type extends Final<T>::Type {
    /**
     * Constructor that applies the constraint to the underlying infinite type.
     */
    Type() { constraint(this) }

    /**
     * Redefine `toString()` so that the `bindingset[this]` is removed.
     *
     * This is required, for instance, to declare `Instance<Finitize<string, test/1>::Type>`.
     */
    string toString() { result = super.toString() }
  }
}