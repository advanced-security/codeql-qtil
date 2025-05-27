import java
import qtil.java.ast.TwoOperands

from BinaryExpr op, TwoOperands<BinaryExpr>::Set ops
where
  ops.someOperand().(VarAccess).getVariable().getName() = "a" and
  ops.otherOperand().(VarAccess).getVariable().getName() = "b" and
  ops.getOperation() = op
select op, ops.someOperand(), ops.otherOperand()
