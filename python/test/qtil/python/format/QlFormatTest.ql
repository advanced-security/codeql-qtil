import python
import qtil.python.format.QlFormat

predicate problem(AstNode elem, Template msg) {
  exists(Assign assign, Expr value, Variable var |
    elem = assign and
    assign.defines(var) and
    value = assign.getValue() and
    msg =
      tpl("Variable {varname} defined with value {init}.")
          .text("varname", var.getId())
          .link("init", value)
  )
}

import Problem<problem/2>::Query