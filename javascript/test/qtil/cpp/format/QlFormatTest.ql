import javascript
import qtil.javascript.format.QlFormat

predicate problem(Locatable elem, Template msg) {
  exists(VariableDeclarator var, Expr initializer |
    elem = var and
    initializer = var.getInit() and
    msg =
      tpl("Variable {varname} has initializer {initializer}.")
          .text("varname", var.getBindingPattern().getName())
          .link("initializer", initializer)
  )
}

import Problem<problem/2>::Query