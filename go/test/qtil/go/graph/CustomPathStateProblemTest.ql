// Minimal test to make sure CustomPathStateProblem works with Go code.
import go
import qtil.go.graph.CustomPathStateProblem

module CallGraphPathStateProblemConfig implements CustomPathStateProblemConfigSig {
  class Node = Ident;

  class State = int; // Track search depth

  predicate start(Node n, int depth) { n.getName() = "start" and depth = 0 }

  bindingset[depth]
  predicate end(Node n, int depth) { n.getName() = "end" and depth >= 0 }

  bindingset[depth1]
  bindingset[depth2]
  predicate edge(Ident a, int depth1, Ident b, int depth2) {
    depth2 = depth1 + 1 and
    exists(Assignment assign |
      assign.getLhs().(Name).getTarget().getDeclaration() = a and
      assign.getRhs().(Name).getTarget().getDeclaration() = b
    )
  }
}

import CustomPathStateProblem<CallGraphPathStateProblemConfig>

from Ident start, Ident end
where problem(start, end)
select start, end, "Path from $@ to $@.", start.getName(), start, end.getName(), end
