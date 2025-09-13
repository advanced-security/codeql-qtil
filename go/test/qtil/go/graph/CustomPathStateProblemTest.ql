// Minimal test to make sure CustomPathStateProblem works with Go code.
import go
import qtil.go.graph.CustomPathStateProblem

module CallGraphPathStateProblemConfig implements CustomPathStateProblemConfigSig {
  class Node = Variable;
  
  class State = int; // Track search depth

  predicate start(Node n, int depth) { n.getName() = "start" and depth = 0 }

  bindingset[depth]
  predicate end(Node n, int depth) { n.getName() = "end" }

  bindingset[depth1]
  bindingset[depth2]  
  predicate edge(Variable a, int depth1, Variable b, int depth2) {
    depth2 = depth1 + 1 and
    exists(ValueSpec specA, ValueSpec specB |
      specA.getNameExpr(0).(Ident).getName() = a.getName() and
      specB.getNameExpr(0).(Ident).getName() = b.getName() and
      specA.getValue(0).(Ident).getName() = b.getName()
    )
  }
}

import CustomPathStateProblem<CallGraphPathStateProblemConfig>

from Variable start, Variable end
where problem(start, end)
select start, end, "Path from $@ to $@.", start.getName(), start, end.getName(), end