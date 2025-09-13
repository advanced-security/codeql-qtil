// Minimal test to make sure CustomPathStateProblem works with Ruby code.
import ruby
import qtil.ruby.graph.CustomPathStateProblem

module CallGraphPathStateProblemConfig implements CustomPathStateProblemConfigSig {
  class Node = Ast::VariableWriteAccess;

  class State = int; // Track search depth

  predicate start(Node n, int depth) { n.getVariable().getName() = "start" and depth = 0 }

  bindingset[depth]
  predicate end(Node n, int depth) { n.getVariable().getName() = "end" and depth >= 0 }

  bindingset[depth1]
  bindingset[depth2]
  predicate edge(Ast::VariableWriteAccess a, int depth1, Ast::VariableWriteAccess b, int depth2) {
    depth2 = depth1 + 1 and
    exists(Ast::VariableReadAccess accessA, Ast::VariableReadAccess accessB |
      a.getVariable() = accessA.getVariable() and
      b.getVariable() = accessB.getVariable() and
      accessA.getParent().(Ast::AssignExpr).getRightOperand() = accessB
    )
  }
}

import CustomPathStateProblem<CallGraphPathStateProblemConfig>

from Ast::VariableWriteAccess start, Ast::VariableWriteAccess end
where problem(start, end)
select start, end, "Path from $@ to $@.", start.getVariable().getName(), start,
  end.getVariable().getName(), end
