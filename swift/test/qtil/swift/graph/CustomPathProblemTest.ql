// Minimal test to make sure CustomPathProblem works with swift code.
import swift
import qtil.swift.graph.CustomPathProblem

module CallGraphPathProblemConfig implements CustomPathProblemConfigSig {
  class Node = VarDecl;

  predicate start(Node n) { n.getName() = "start" }

  predicate end(Node n) {
    n.getName() = "end"
  }

  predicate edge(VarDecl a, VarDecl b) {
    exists(AssignExpr assign |
      assign.getDest() = a.getAnAccess() and
      assign.getSource() = b.getAnAccess()
    )
  }
}

import CustomPathProblem<CallGraphPathProblemConfig>

from VarDecl start, VarDecl end
where problem(start, end)
select start, end, "Path from $@ to $@.", start.getName(), start, end.getName(), end
