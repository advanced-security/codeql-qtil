import go
import qtil.go.ast.TwoOperands

from BinaryExpr op, TwoOperands<BinaryExpr>::Set ops
where
  ops.someOperand().(Ident).getName() = "a" and
  ops.otherOperand().(Ident).getName() = "b" and
  ops.getOperation() = op
select op, ops.someOperand(), ops.otherOperand()
