/**
 * @name Custom Path Problem Example
 * @description This example demonstrates how to define a custom path problem in C++ using Qtil. It
 *   identifies paths from top-level variables to constructors that are called during their
 *   initialization.
 * @id qtil-example-custom-path-problem
 * @severity info
 * @kind path-problem
 */

import cpp
import cpp as cpp
import qtil.locations.Locatable
import qtil.locations.CustomPathProblem
import CustomPathProblemCpp

/** Defines cpp location behavior; this will be moved to qtil.cpp eventually. */
module CustomPathProblemCpp {
  module ElementConfig implements LocatableConfig<Location> {
    class Locatable = cpp::Locatable;
  }

  import PathProblem<Location, ElementConfig>
}

/**
 * Defines a custom path problem configuration for identifying paths from top-level variables to
 * constructors that are called during their initialization.
 */
module CallGraphPathProblemConfig implements CustomPathProblemConfigSig {
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

  /** Start searching from variable nodes */
  predicate start(Node n) { n instanceof Variable }

  /** If we reach a constructor, we have identified "problematic" flow from a variable */
  predicate end(Node n) {
    exists(Function f, Class c |
      n = f and
      c.getAConstructor() = f
    )
  }

  predicate edge(Node a, Node b) {
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
      end(endFunc) and
      a = fc and
      b = endFunc
    )
  }
}

// Import the custom path problem configuration and define the problem.
//
// This automaticall generates the `nodes` and `edges` predicates based on the configuration that
// make the path traceable for users.
import CustomPathProblem<CallGraphPathProblemConfig>

from Variable var, Function ctor
where problem(var, ctor) // This finds for paths from variables to constructors
select var, var, ctor, "Initialization of variable $@ calls constructor $@", var, var.getName(),
  ctor, ctor.getName()
