import go as go
import qtil.parameterization.SignatureTypes

/**
 * A module for dealing with pairs of exclusive operands in C++ ASTs.
 *
 * For instance, to find cases where one operand is an integer and the other is a constant, you
 * will want to to perform checks on each operand separately and consistently without worrying about
 * order. This module makes this common pattern easy to implement.
 *
 * This module takes two type parameters:
 *  - `Operand`: the type of the operands (e.g. `Expr`)
 *  - `HasOperands`: a type that has operands of type `Operand` (e.g. `BinaryExpr`)
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
module TwoOperands<Signature<go::BinaryExpr>::Type BinOp> {
  private import qtil.ast.TwoOperands as Make
  import Make::TwoOperands<go::Expr, BinOp>
}