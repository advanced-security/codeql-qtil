// Minimal test to make sure CustomPathStateProblem works with Javascript code.
import javascript
import qtil.javascript.graph.CustomPathStateProblem

module CallGraphPathStateProblemConfig implements CustomPathStateProblemConfigSig {
  class Node = VarDecl;

  class State = int; // Track search depth

  predicate start(Node n, int depth) { n.getAVariable().getName() = "start" and depth = 0 }

  bindingset[depth]
  predicate end(Node n, int depth) { n.getAVariable().getName() = "end" }

  bindingset[depth1]
  bindingset[depth2]
  predicate edge(VarDecl a, int depth1, VarDecl b, int depth2) {
    depth2 = depth1 + 1 and
    depth1 < 10 and // Limit search depth to prevent infinite loops
    a.getAVariable().getAnAssignedExpr() = b.getAVariable().getAnAccess()
  }
}

import CustomPathStateProblem<CallGraphPathStateProblemConfig>

from VarDecl start, VarDecl end, int startDepth, int endDepth
where problem(start, startDepth, end, endDepth)
select start, end, "Path from $@ (depth " + startDepth + ") to $@ (depth " + endDepth + ").",
  start.getAVariable().getName(), start, end.getAVariable().getName(), end
