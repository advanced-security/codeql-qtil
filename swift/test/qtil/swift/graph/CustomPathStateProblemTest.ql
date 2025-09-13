// Minimal test to make sure CustomPathStateProblem works with Swift code.
import swift
import qtil.swift.graph.CustomPathStateProblem

module CallGraphPathStateProblemConfig implements CustomPathStateProblemConfigSig {
  class Node = VarDecl;

  class State = int; // Track search depth

  predicate start(Node n, int depth) { n.getName() = "start" and depth = 0 }

  bindingset[depth]
  predicate end(Node n, int depth) { n.getName() = "end" }

  bindingset[depth1]
  bindingset[depth2]
  predicate edge(VarDecl a, int depth1, VarDecl b, int depth2) {
    depth2 = depth1 + 1 and
    exists(PatternBindingDecl bindingA, PatternBindingDecl bindingB |
      bindingA.getPattern(0).(NamedPattern).getVarDecl() = a and
      bindingB.getPattern(0).(NamedPattern).getVarDecl() = b and
      bindingA.getInit(0).(DeclRefExpr).getDecl() = b
    )
  }
}

import CustomPathStateProblem<CallGraphPathStateProblemConfig>

from VarDecl start, VarDecl end
where problem(start, end)
select start, end, "Path from $@ to $@.", start.getName(), start, end.getName(), end
