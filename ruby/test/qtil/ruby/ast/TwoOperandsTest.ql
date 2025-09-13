import ruby
import qtil.ruby.ast.TwoOperands

from Ast::BinaryOperation op, TwoOperands<Ast::BinaryOperation>::Set ops
where
  ops.someOperand().(Ast::VariableAccess).getVariable().getName() = "a" and
  ops.otherOperand().(Ast::VariableAccess).getVariable().getName() = "b" and
  ops.getOperation() = op
select op, ops.someOperand(), ops.otherOperand()
