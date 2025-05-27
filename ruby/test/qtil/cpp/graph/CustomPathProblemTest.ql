// Minimal test to make sure CustomPathProblem works with C++ code.
import ruby
import qtil.ruby.graph.CustomPathProblem

module CallGraphPathProblemConfig implements CustomPathProblemConfigSig {
  class Node = Ast::VariableWriteAccess;

  predicate start(Node n) { n.getVariable().getName() = "v_start" }

  predicate end(Node n) {
    n.getVariable().getName() = "v_end"
  }

  predicate edge(Ast::VariableWriteAccess a, Ast::VariableWriteAccess b) {
    exists(Ast::VariableReadAccess mid, Ast::AssignExpr assign |
      a = assign.getLeftOperand() and assign.getRightOperand() = mid and
      mid.getVariable() = b.getVariable()
    )
  }
}

import CustomPathProblem<CallGraphPathProblemConfig>

from Ast::VariableWriteAccess start, Ast::VariableWriteAccess end
where problem(start, end)
select start, end, "Path from $@ to $@.", start.getVariable().getName(), start, end.getVariable().getName(), end
