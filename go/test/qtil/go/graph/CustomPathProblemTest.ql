// Minimal test to make sure CustomPathProblem works with C++ code.
import go
import qtil.go.graph.CustomPathProblem

module CallGraphPathProblemConfig implements CustomPathProblemConfigSig {
  class Node = Ident;

  predicate start(Node n) { n.getName() = "start" }

  predicate end(Node n) {
    n.getName() = "end"
  }

  predicate edge(Node a, Node b) {
    exists(Assignment assign |
      assign.getLhs().(Name).getTarget().getDeclaration() = a and assign.getRhs().(Name).getTarget().getDeclaration() = b
    )
  }
}

import CustomPathProblem<CallGraphPathProblemConfig>

from Ident start, Ident end
where problem(start, end)
select start, end, "Path from $@ to $@.", start.getName(), start, end.getName(), end
