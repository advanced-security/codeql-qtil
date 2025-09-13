// Minimal test to make sure CustomPathProblem works with Javascript code.
import javascript
import qtil.javascript.graph.CustomPathProblem

module CallGraphPathProblemConfig implements CustomPathProblemConfigSig {
  class Node = VarDecl;

  predicate start(Node n) { n.getAVariable().getName() = "start" }

  predicate end(Node n) { n.getAVariable().getName() = "end" }

  predicate edge(VarDecl a, VarDecl b) {
    a.getAVariable().getAnAssignedExpr() = b.getAVariable().getAnAccess()
  }
}

import CustomPathProblem<CallGraphPathProblemConfig>

from VarDecl start, VarDecl end
where problem(start, end)
select start, end, "Path from $@ to $@.", start.getAVariable().getName(), start,
  end.getAVariable().getName(), end
