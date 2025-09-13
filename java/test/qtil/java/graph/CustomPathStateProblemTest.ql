// Minimal test to make sure CustomPathStateProblem works with Java code.
import java
import qtil.java.graph.CustomPathStateProblem

module CallGraphPathStateProblemConfig implements CustomPathStateProblemConfigSig {
  class Node = LocalVariableDecl;

  class State = int; // Track search depth

  predicate start(Node n, int depth) { n.getName() = "start" and depth = 0 }

  bindingset[depth]
  predicate end(Node n, int depth) { n.getName() = "end" and depth >= 0 }

  bindingset[depth1]
  bindingset[depth2]
  predicate edge(LocalVariableDecl a, int depth1, LocalVariableDecl b, int depth2) {
    depth2 = depth1 + 1 and
    exists(LocalVariableDeclExpr declA, LocalVariableDeclExpr declB |
      declA.getVariable() = a and
      declB.getVariable() = b and
      declA.getInit().(VarAccess).getVariable() = b
    )
  }
}

import CustomPathStateProblem<CallGraphPathStateProblemConfig>

from LocalVariableDecl start, LocalVariableDecl end
where problem(start, end)
select start, end, "Path from $@ to $@.", start.getName(), start, end.getName(), end
