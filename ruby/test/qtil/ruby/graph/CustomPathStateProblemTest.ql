// Minimal test to make sure CustomPathStateProblem works with Ruby code.
import ruby
import qtil.ruby.graph.CustomPathStateProblem

module CallGraphPathStateProblemConfig implements CustomPathStateProblemConfigSig {
  class Node = Ast::VariableWriteAccess;

  class State = int; // Track search depth

  predicate start(Node n, int depth) { n.getVariable().getName() = "v_start" and depth = 0 }

  bindingset[depth]
  predicate end(Node n, int depth) { n.getVariable().getName() = "v_end" }

  bindingset[depth1]
  bindingset[depth2]
  predicate edge(Ast::VariableWriteAccess a, int depth1, Ast::VariableWriteAccess b, int depth2) {
    depth2 = depth1 + 1 and
    depth1 < 10 and // Limit search depth to prevent infinite loops
    exists(Ast::VariableReadAccess mid, Ast::AssignExpr assign |
      a = assign.getLeftOperand() and
      assign.getRightOperand() = mid and
      mid.getVariable() = b.getVariable()
    )
  }
}

import CustomPathStateProblem<CallGraphPathStateProblemConfig>

from Ast::VariableWriteAccess start, Ast::VariableWriteAccess end, int startDepth, int endDepth
where problem(start, startDepth, end, endDepth)
select start, end, "Path from $@ (depth " + startDepth + ") to $@ (depth " + endDepth + ").",
  start.getVariable().getName(), start, end.getVariable().getName(), end
