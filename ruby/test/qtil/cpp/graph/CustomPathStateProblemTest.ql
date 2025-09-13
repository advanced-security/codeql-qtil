// Minimal test to make sure CustomPathStateProblem works with Ruby code.
import ruby
import qtil.ruby.graph.CustomPathStateProblem

module CallGraphPathStateProblemConfig implements CustomPathStateProblemConfigSig {
  class Node = LocalVariable;
  
  class State = int; // Track search depth

  predicate start(Node n, int depth) { n.getName() = "start" and depth = 0 }

  bindingset[depth]
  predicate end(Node n, int depth) { n.getName() = "end" }

  bindingset[depth1]
  bindingset[depth2]  
  predicate edge(LocalVariable a, int depth1, LocalVariable b, int depth2) {
    depth2 = depth1 + 1 and
    exists(LocalVariableAccess accessA, LocalVariableAccess accessB |
      accessA.getVariable() = a and
      accessB.getVariable() = b and
      accessA.getParent().(AssignExpr).getRightOperand() = accessB
    )
  }
}

import CustomPathStateProblem<CallGraphPathStateProblemConfig>

from LocalVariable start, LocalVariable end
where problem(start, end)
select start, end, "Path from $@ to $@.", start.getName(), start, end.getName(), end