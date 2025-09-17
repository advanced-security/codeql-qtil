// Minimal test to make sure CustomPathStateProblem works with Java code.
import java
import qtil.java.graph.CustomPathStateProblem

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
    depth1 < 10 and // Limit search depth to prevent infinite loops
    a.getAnAssignedValue().(VarAccess).getVariable() = b
  }
}

import CustomPathStateProblem<CallGraphPathStateProblemConfig>

from Variable start, Variable end, int startDepth, int endDepth
where problem(start, startDepth, end, endDepth)
select start, end, "Path from $@ (depth " + startDepth + ") to $@ (depth " + endDepth + ").",
  start.getName(), start, end.getName(), end
