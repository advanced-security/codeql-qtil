// Minimal test to make sure CustomPathStateProblem works with C# code.
import csharp
import qtil.csharp.graph.CustomPathStateProblem

module CallGraphPathStateProblemConfig implements CustomPathStateProblemConfigSig {
  class Node = LocalVariable;

  class State = int; // Track search depth

  predicate start(Node n, int depth) { n.getName() = "start" and depth = 0 }

  bindingset[depth]
  predicate end(Node n, int depth) { n.getName() = "end" and depth >= 0 }

  bindingset[depth1]
  bindingset[depth2]
  predicate edge(LocalVariable a, int depth1, LocalVariable b, int depth2) {
    depth2 = depth1 + 1 and
    exists(LocalVariableDeclExpr declA, LocalVariableDeclExpr declB |
      declA.getVariable() = a and
      declB.getVariable() = b and
      declA.getInitializer().(VariableAccess).getTarget() = b
    )
  }
}

import CustomPathStateProblem<CallGraphPathStateProblemConfig>

from LocalVariable start, LocalVariable end
where problem(start, end)
select start, end, "Path from $@ to $@.", start.getName(), start, end.getName(), end
