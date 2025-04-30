import cpp
import qtil.format.QLFormat
import QlFormatCpp

module QlFormatCpp {
  module ElementConfig implements LocatableConfig<Location> {
    class Locatable = Element;
  }

  import QlFormat<Location, ElementConfig>
}

predicate problem(Element elem, Template msg) {
  exists(VariableDeclarationEntry var, Expr initializer |
    elem = var and
    initializer = var.getDeclaration().getInitializer().getExpr() and
    msg =
      tpl("Variable {varname} has initializer {initializer}.")
          .withParam("varname", var.getName())
          .withParam("initializer", initializer.toString(), initializer)
  )
}

import Problem<problem/2>::Query

//from VariableDeclarationEntry var, Expr initializer
//select "Variable " + var.getName() + " with initializer $@.", initializer, initializer.toString()
