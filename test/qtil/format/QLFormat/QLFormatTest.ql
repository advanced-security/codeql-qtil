/**
 * @name QlFormatTest
 * @id ql-format-test
 * @descirption QlFormatTest
 * @kind problem
 * @severity warning
 */

import cpp
import cpp as cpp
import qtil.format.QLFormat
import qtil.locations.Locatable
import QlFormatCpp

module QlFormatCpp {
  module ElementConfig implements LocatableConfig<Location> {
    class Locatable = cpp::Locatable;
  }

  import QlFormat<Location, ElementConfig>
}

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

//from VariableDeclarationEntry var, Expr initializer
//where
//initializer = var.getDeclaration().getInitializer().getExpr()
//select var, "Variable " + var.getName() + " with initializer $@.", initializer, initializer.toString()
