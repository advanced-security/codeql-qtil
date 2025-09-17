// Minimal test to make sure CustomPathStateProblem works with Go code.
import go
import qtil.go.graph.CustomPathStateProblem

module CallGraphPathStateProblemConfig implements CustomPathStateProblemConfigSig {
  class Node = Ident;

  class State = int; // Track search depth

  predicate start(Node n, int depth) { n.getName() = "start" and depth = 0 }

  bindingset[depth]
  predicate end(Node n, int depth) { n.getName() = "end" }

  bindingset[depth1]
  bindingset[depth2]
  predicate edge(Node a, int depth1, Node b, int depth2) {
    depth2 = depth1 + 1 and
    depth1 < 10 and // Limit search depth to prevent infinite loops
    exists(Assignment assign |
      assign.getLhs().(Name).getTarget().getDeclaration() = a and
      assign.getRhs().(Name).getTarget().getDeclaration() = b
    )
  }
}

import CustomPathStateProblem<CallGraphPathStateProblemConfig>

from Ident start, Ident end, int startDepth, int endDepth
where problem(start, startDepth, end, endDepth)
select start, end, "Path from $@ (depth " + startDepth + ") to $@ (depth " + endDepth + ").",
  start.getName(), start, end.getName(), end
