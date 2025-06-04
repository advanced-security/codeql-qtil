// Minimal test to make sure CustomPathProblem works with C++ code.
import csharp
import qtil.csharp.graph.CustomPathProblem

module CallGraphPathProblemConfig implements CustomPathProblemConfigSig {
  class Node = Variable;

  predicate start(Node n) { n.getName() = "start" }

  predicate end(Node n) { n.getName() = "end" }

  predicate edge(Variable a, Variable b) { a.getAnAssignedValue().(VariableAccess).getTarget() = b }
}

import CustomPathProblem<CallGraphPathProblemConfig>

from Variable start, Variable end
where problem(start, end)
select start, end, "Path from $@ to $@.", start.getName(), start, end.getName(), end
