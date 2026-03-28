// Minimal test to make sure CustomPathStateProblem works with python code.
import python
import qtil.python.graph.CustomPathStateProblem

module CallGraphPathStateProblemConfig implements CustomPathStateProblemConfigSig {
  class Node = Name;

  class State = int; // Track search depth

  predicate start(Node n, int depth) { n.getId() = "start" and depth = 0 }

  bindingset[depth]
  predicate end(Node n, int depth) { n.getId() = "end" }

  bindingset[depth1]
  bindingset[depth2]
  predicate edge(Name a, int depth1, Name b, int depth2) {
    depth2 = depth1 + 1 and
    depth1 < 10 and // Limit search depth to prevent infinite loops
    exists(Assign assign, Variable varA, Variable varB |
      assign.defines(varA) and
      assign.getValue().(Name).uses(varB) and
      a.defines(varA) and
      b.defines(varB)
    )
  }
}

import CustomPathStateProblem<CallGraphPathStateProblemConfig>

from Name start, Name end, int startDepth, int endDepth
where problem(start, startDepth, end, endDepth)
select start, end, "Path from $@ (depth " + startDepth + ") to $@ (depth " + endDepth + ").",
  start.getId(), start, end.getId(), end
