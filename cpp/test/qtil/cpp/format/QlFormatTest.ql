import cpp
import qtil.cpp.format.QlFormat

predicate problem(Locatable elem, Template msg) {
  exists(VariableDeclarationEntry var, Expr initializer |
    elem = var and
    initializer = var.getDeclaration().getInitializer().getExpr() and
    msg =
      tpl("Variable {varname} has initializer {initializer}.")
          .text("varname", var.getName())
          .link("initializer", initializer)
  )
}

import Problem<problem/2>::Query
