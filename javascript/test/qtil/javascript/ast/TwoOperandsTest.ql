import javascript
import qtil.javascript.ast.TwoOperands

from BinaryExpr op, TwoOperands<BinaryExpr>::Set ops
where
  ops.someOperand().(VariableAccess).getVariable().getName() = "a" and
  ops.otherOperand().(VariableAccess).getVariable().getName() = "b" and
  ops.getOperation() = op
select op, ops.someOperand(), ops.otherOperand()
