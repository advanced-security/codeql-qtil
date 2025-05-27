import java
import qtil.java.format.QlFormat

predicate problem(Element elem, Template msg) {
  exists(Variable var, Expr initializer |
    elem = var and
    initializer = var.getInitializer() and
    msg =
      tpl("Variable {varname} has initializer {initializer}.")
          .text("varname", var.getName())
          .link("initializer", initializer)
  )
}

import Problem<problem/2>::Query