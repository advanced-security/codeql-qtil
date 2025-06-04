import ruby
import qtil.ruby.format.QlFormat

predicate problem(Ast::AstNode elem, Template msg) {
  exists(Ast::AssignExpr assign, Ast::Expr initializer, Ast::Variable var |
    elem = assign and
    initializer = assign.getRightOperand() and
    assign.getLeftOperand().(Ast::VariableAccess).getVariable() = var and
    msg =
      tpl("Variable {varname} has initializer {initializer}.")
          .text("varname", var.getName())
          .link("initializer", initializer)
  )
}

import Problem<problem/2>::Query
