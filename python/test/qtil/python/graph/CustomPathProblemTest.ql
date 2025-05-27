// Minimal test to make sure CustomPathProblem works with python code.
import python
import qtil.python.graph.CustomPathProblem

module CallGraphPathProblemConfig implements CustomPathProblemConfigSig {
  class Node = Name;

  predicate start(Node n) { n.getId() = "start" }

  predicate end(Node n) { n.getId() = "end" }

  predicate edge(Name a, Name b) {
    exists(Assign assign, Variable varA, Variable varB |
      assign.defines(varA) and
      assign.getValue().(Name).uses(varB) and
      a.defines(varA) and
      b.defines(varB)
    )
  }
}

import CustomPathProblem<CallGraphPathProblemConfig>

from Name start, Name end
where problem(start, end)
select start, end, "Path from $@ to $@.", start.getId(), start, end.getId(), end
