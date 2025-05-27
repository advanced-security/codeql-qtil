// Minimal test to make sure CustomPathProblem works with Java code.
import java
import qtil.java.graph.CustomPathProblem

module CallGraphPathProblemConfig implements CustomPathProblemConfigSig {
  class Node = Variable;

  predicate start(Node n) { n.getName() = "start" }

  predicate end(Node n) { n.getName() = "end" }

  predicate edge(Variable a, Variable b) { a.getAnAssignedValue().(VarAccess).getVariable() = b }
}

import CustomPathProblem<CallGraphPathProblemConfig>

from Variable start, Variable end
where problem(start, end)
select start, end, "Path from $@ to $@.", start.getName(), start, end.getName(), end
