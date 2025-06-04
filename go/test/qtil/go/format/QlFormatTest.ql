import go
import qtil.go.format.QlFormat

predicate problem(Locatable elem, Template msg) {
  exists(ValueSpec decl, Expr initializer, int i |
    elem = decl and
    initializer = decl.getInit(i) and
    msg =
      tpl("Variable {varname} has initializer {initializer}.")
          .text("varname", decl.getName(i))
          .link("initializer", initializer)
  )
}

import Problem<problem/2>::Query
