import python
import qtil.python.ast.TwoOperands

from BinaryExpr op, TwoOperands<BinaryExpr>::Set ops
where
  ops.someOperand().(Name).getId() = "a" and
  ops.otherOperand().(Name).getId() = "b" and
  ops.getOperation() = op
select op, ops.someOperand(), ops.otherOperand()
