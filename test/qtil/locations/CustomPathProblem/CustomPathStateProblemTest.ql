/**
 * @name Custom Path State Problem Example
 * @description This example demonstrates how to define a custom path problem in C++ using Qtil. It
 *   identifies paths from top-level variables to constructors that are called during their
 *   initialization. Additionally, it tracks the depth of the search as a state.
 * @id qtil-example-custom-path-problem
 * @severity info
 * @kind path-problem
 */

import cpp
import cpp as cpp
import qtil.locations.Locatable
import qtil.locations.CustomPathStateProblem
import CustomPathStateProblemCpp

/** Defines cpp location behavior; this will be moved to qtil.cpp eventually. */
module CustomPathStateProblemCpp {
  module ElementConfig implements LocatableConfig<Location> {
    class Locatable = cpp::Locatable;
  }

  import PathStateProblem<Location, ElementConfig>
}

/**
 * Defines a custom path problem configuration for identifying paths from top-level variables to
 * constructors that are called during their initialization.
 */
module CallGraphPathProblemConfig implements CustomPathStateProblemConfigSig {
  /**
   * Since we are tracking flow from variable initialization to constructor calls, that means the
   * nodes in our path problem will be variables (roots), function calls (edges), and constructors
   * (end nodes).
   */
  class Node extends Locatable {
    Node() {
      this instanceof Function or this.(Variable).isTopLevel() or this instanceof FunctionCall
    }
  }

  class State = int; // Track search depth

  /** Start searching from variable nodes */
  predicate start(Node n, int depth) { n instanceof Variable and depth = 0 }

  /** If we reach a constructor, we have identified "problematic" flow from a variable */
  bindingset[depth]
  predicate end(Node n, int depth) {
    exists(Function f, Class c |
      n = f and
      c.getAConstructor() = f
    )
  }

  bindingset[depth1]
  bindingset[depth2]
  predicate edge(Node a, int depth1, Node b, int depth2) {
    depth2 = depth1 + 1 and
    (
      // Increment depth for each edge traversed
      // Add an edge from variables to the function calls in that variable's initializer.
      exists(Variable var, Expr initializer, FunctionCall fc |
        var.getInitializer().getExpr() = initializer and
        fc.getParent*() = initializer and
        a = var and
        b = fc
      )
      or
      // Supposing we have reached a function call to some function `mid()`, then the next step in
      // the path problem will be one of the function calls in `mid()`.
      exists(FunctionCall fc, Function mid, FunctionCall next |
        mid = fc.getTarget() and
        next.getEnclosingFunction() = mid and
        a = fc and
        b = next
      )
      or
      // Add an edge from function calls to constructors, which are the end nodes.
      exists(FunctionCall fc, Function endFunc |
        fc.getTarget() = endFunc and
        end(endFunc, 0) and
        a = fc and
        b = endFunc
      )
    )
  }
}

// Import the custom path problem configuration and define the problem.
//
// This automaticall generates the `nodes` and `edges` predicates based on the configuration that
// make the path traceable for users.
import CustomPathStateProblem<CallGraphPathProblemConfig>

from Variable var, Function ctor, int depth
where problem(var, _, ctor, depth) // This finds for paths from variables to constructors
select var, var, ctor, "Initialization of variable $@ calls constructor $@ at depth " + depth, var,
  var.getName(), ctor, ctor.getName()
