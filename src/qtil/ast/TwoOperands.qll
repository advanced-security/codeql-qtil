/**
 * A module for dealing with pairs of exclusive operands.
 *
 * For instance, to find cases where one operand is an integer and the other is a constant, you
 * will want to to perform checks on each operand separately and consistently without worrying about
 * order. This module makes this common pattern easy to implement.
 *
 * See the documentation of `TwoOperands` for more details.
 */

private import qtil.parameterization.SignatureTypes
private import qtil.parameterization.Finalize
private import qtil.inheritance.Instance

/** Private module to get a signature class for some type that has operands of some type. */
private module TwoOperandsSig<FiniteType Operand> {
  signature class HasOperands {
    Operand getAnOperand();
  }
}

/**
 * A module for dealing with pairs of exclusive operands.
 *
 * For instance, to find cases where one operand is an integer and the other is a constant, you
 * will want to to perform checks on each operand separately and consistently without worrying about
 * order. This module makes this common pattern easy to implement.
 *
 * This module takes two type parameters:
 *  - `Operand`: the type of the operands (e.g. `Expr`)
 *  - `HasOperands`: a type that has operands of type `Operand` (e.g. `BinaryExpr`)
 *
 * Typically, this module should be imported for the relevant language, such as `qtil.cpp.ast`. In
 * this case, only the `HasOperands` type parameter is required.
 *
 * ```ql
 * // Using this module:
 * predicate myBinaryTestNew(BinaryExpr e) {
 *   exists(TwoOperands<BinaryExpr>::Set set |
 *     set.getOperation() = e and
 *     set.someOperand().isInteger() and
 *     set.otherOperand().isConstant()
 *   )
 * }
 *
 * // Is roughly equivalent to:
 * predicate myBinaryTestOld(BinaryExpr e) {
 *   exists(Expr a, Expr b |
 *     e.getAnOperand() = a and
 *     e.getAnOperand() = b and
 *     a != b and
 *     a.isInteger() and
 *     b.isConstant()
 *   )
 * }
 * ```
 *
 * Some caution about using this module: for each use, two `Set` objects exst. If you do not
 * properly constrain the usage of `someOperand()` and `otherOperand()`, then these members could
 * hold for different `Set`s. Therefore, `someOperand()` and `otherOperand()` may be the same
 * operand. This will not happen if the `Set` is properly constrained across the two member
 * invocations.
 *
 * ```ql
 * predicate bug(BinaryExpr e) {
 *   // Bad: the two sets are not constrained to the same instance, therefore the operands not
 *   // guaranteed to be different.
 *   TwoOperands<BinaryExpr>::getASet(e).someOperand().isInteger() and
 *   TwoOperands<BinaryExpr>::getASet(e).otherOperand().isConstant()
 * }
 * ```
 */
module TwoOperands<FiniteStringableType Operand, TwoOperandsSig<Operand>::HasOperands HasOperands> {
  /**
   * Holds if `operandA` and `operandB` are operands of `operation`, and that they are not the same
   * operand.
   *
   * Example usage:
   * ```ql
   * predicate myBinaryTest(BinaryExpr e) {
   *   exists(Expr a, Expr b |
   *     TwoOperands<BinaryExpr>::set(e, a, b) and
   *     a.isInteger() and
   *     b.isConstant()
   *   )
   * }
   * ```
   *
   * Note: this predicate is less fluent than the class API, but it is simpler for CodeQL to
   * understand and optimize. It is also not possible to mistakenly match the same operand twice
   * using this API.
   *
   * For an alternative API, see the `Set` class.
   */
  predicate set(HasOperands operation, Operand operandA, Operand operandB) {
    operation.getAnOperand() = operandA and
    operation.getAnOperand() = operandB and
    operandA != operandB
  }

  /**
   * Holds if operand `a` and `b` are both operands of some shared operation, and that they are not
   * the same operand.
   *
   * Example usage:
   * ```ql
   * predicate myBinaryTest(Expr a, Expr b) {
   *   TwoOperands<BinaryExpr>::set(a, b) and
   *   a.isInteger() and
   *   b.isConstant()
   * }
   * ```
   */
  predicate set(Operand a, Operand b) { set(_, a, b) }

  /**
   * A class that represents a pair of operands of the same operation, where the two operands are
   * different.
   *
   * Example usage:
   * ```ql
   * predicate myBinaryTest(Expr a, Expr b) {
   *   exists(TwoOperands<BinaryExpr>::Set set |
   *     set.someOperand().isInteger() and
   *     set.otherOperand().isConstant()
   *   )
   * }
   * ```
   *
   * There are two things to be careful about when using this class:
   *  - If the `Set` is not properly constrained, then the results of `someOperand()` and
   *    `otherOperand()` may not be different operands. Always bind the `Set` to be a singular
   *    instance, e.g. `exists(TwoOperands<BinaryExpr>::Set set | ... )`, and never mix `getASet`
   *    calls, e.g. `...::getASet(e).someOperand().... and ...::getASet(e).otherOperand()....`..
   *  - The `Set` class extends the _operand_ returned by `someOperand()`. This perhaps unexpected
   *    approach is done to allow the CodeQL engine to perform optimizations by inlining which
   *    would not be possible if the `Set` class was a `newtype` of all operand pairs, while
   *    allowing that `someOperand()` and `otherOperand()` to consistent and different.
   *
   * For an alternative, more minimal API see the `set` predicate.
   */
  class Set extends Instance<Operand>::Type {
    /** The operation that uses this set of two operands. */
    HasOperands parent;
    /** Since this class extends `Operand`, the field `other` holds the other one. */
    Operand other;

    Set() { set(parent, this, other) }

    /**
     * Get some operand of the operation that is different from `otherOperand()`.
     */
    Operand someOperand() { result = this }

    /**
     * Get the other operand of the operation, which is different from `someOperand()`.
     */
    Operand otherOperand() { result = other }

    /**
     * Get the operation that uses this set of two operands.
     */
    HasOperands getOperation() { result = parent }
  }

  /**
   * Get a set of operands for the given operation, ordered (a, b) or (b, a).
   *
   * Never mix `getASet` calls without binding the result, e.g.
   * `...::getASet(e).someOperand().... and ...::getASet(e).otherOperand()....`, or else the
   * `getASet` predicate may hold for two different orders of the two operands. The consequence of
   * this is that `.someOperand()` and `otherOperand()` may refer to the same operand. Always bind
   * the result of this predicate to a singular instance, e.g.
   * `exists(TwoOperands<BinaryExpr>::Set set | ... )`.
   *
   * Example usage:
   * ```ql
   * predicate myBinaryTest(TwoOperands<BinaryExpr>::Set set) {
   *   set.someOperand().isInteger() and
   *   set.otherOperand().isConstant()
   * }
   *
   * from BinaryExpr e
   * where myBinaryTest(TwoOperands<BinaryExpr>::getASet(e))
   * select e, "found match"
   * ```
   *
   * For an alternative, more minimal API see the `set` predicate.
   */
  Set getASet(HasOperands a) { result = a.getAnOperand() }
}
