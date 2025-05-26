import cpp
import qtil.cpp.ast.TwoOperands

from BinaryOperation op, TwoOperands<BinaryOperation>::Set ops
where
  ops.someOperand().(VariableAccess).getTarget().getName() = "a" and
  ops.otherOperand().(VariableAccess).getTarget().getName() = "b" and
  ops.getOperation() = op
select op, ops.someOperand(), ops.otherOperand()
