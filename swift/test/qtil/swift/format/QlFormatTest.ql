import swift
import qtil.swift.format.QlFormat

predicate problem(Locatable elem, Template msg) {
  exists(VarDecl var, Expr initializer |
    elem = var and
    initializer = var.getParentInitializer() and
    msg =
      tpl("Variable {varname} has initializer {initializer}.")
          .text("varname", var.getName())
          .link("initializer", initializer)
  )
}

import Problem<problem/2>::Query
