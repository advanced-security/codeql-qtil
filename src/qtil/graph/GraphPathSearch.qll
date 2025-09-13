/**
 * A module for efficiently finding paths in a directional graph using a performant pattern called
 * forward-reverse pruning.
 *
 * This pattern is useful for efficiently finding connections between nodes in a directional graph.
 * In a first pass, it finds nodes reachable from the starting point. In the second pass, it finds
 * the subset of those nodes that can be reached from the end point. Together, these create a path
 * from start points to end points.
 *
 * As with the other performance patterns in qtil, this module may be useful as is, or it may not
 * fit your needs exactly. CodeQL evaluation and performance is very complex. In that case, consider
 * this pattern as an example to create your own solution that fits your needs.
 */

private import qtil.parameterization.SignatureTypes
private import qtil.parameterization.Finalize

/**
 * Implement this signature to define a graph, and a search for paths within that graph, using the
 * `GraphPathSearch` module.
 *
 * ```ql
 * module MyConfig implements GraphPathSearchSig<Node> {
 *   predicate start(Node n1) { ... }
 *   predicate edge(Node n1, Node n2) { ... }
 *   predicate end(Node n1) { ... }
 * }
 * ```
 *
 * To track state as well as flow, use `GraphPathStateSearchSig` instead.
 */
signature module GraphPathSearchSig<FiniteType Node> {
  /**
   * The nodes that begin the search of the graph.
   *
   * Ultimately, only paths from a start node to an end node will be found by this module.
   *
   * In most cases, this will ideally be a smaller set of nodes than the end nodes. However, if the
   * graph branches in one direction more than the other, a larger set which branches less may be
   * preferable.
   *
   * The design of this predicate has a great effect in how well this performance pattern will
   * ultimately perform.
   */
  predicate start(Node n1);

  /**
   * A directional edge from `n1` to `n2`.
   *
   * This module will search for paths from `start` to `end` by looking following the direction of
   * these edges.
   *
   * The design of this predicate has a great effect in how well this performance pattern will
   * ultimately perform.
   */
  predicate edge(Node n1, Node n2);

  /**
   * The end nodes of the search.
   *
   * Ultimately, only paths from a start node to an end node will be found by this module.
   *
   * The design of this predicate has a great effect in how well this performance pattern will
   * ultimately perform.
   */
  predicate end(Node n1);
}

/**
 * A module that implements an efficient search for a path within a custom directional graph from a
 * set of start nodes to a set of end nodes.
 *
 * To show discovered paths to users, see the module `CustomPathProblem` which uses this module as
 * its underlying search implementation.
 *
 * This module uses a pattern called "forward reverse pruning" for efficiency. This pattern is
 * useful for reducing the search space when looking for paths in a directional graph. In a first
 * pass, it finds nodes reachable from the starting point. In the second pass, it finds the subset
 * of those nodes that can be reached from the end point. Together, these create a path from start
 * points to end points.
 *
 * To use this module, provide an implementation of the `GraphPathSearchSig` signature as follows:
 *
 * ```ql
 * module Config implements GraphPathSearchSig<Person> {
 *   predicate start(Person p) { p.checkSomething() }
 *   predicate edge(Person p1, Person p2) { p2 = p1.getAParent() }
 *   predicate end(Person p) { p.checkSomethingElse() }
 * }
 * ```
 *
 * The design of these predicate has a great effect in how well this performance pattern will
 * ultimately perform.
 *
 * The resulting predicate `hasPath` should be a much more efficient search of connected start nodes
 * to end nodes than a naive search (which in CodeQL could easily be evaluated as either a full
 * graph search, or a search over the cross product of all nodes).
 *
 * ```ql
 * from Person p1, Person p2
 * // Fast graph path detection thanks to forward-reverse pruning.
 * where GraphPathSearch<Person, Config>::hasPath(p1, p2)
 * select p1, p2
 * ```
 *
 * The resulting module also exposes two classes:
 * - `ForwardNode`: All nodes reachable from the start nodes.
 * - `ReverseNode`: All forward nodes that reach end nodes.
 *
 * These classes may be useful in addition to the `hasPath` predicate.
 *
 * To track state as well as flow, use `GraphPathStateSearch` instead.
 */
module GraphPathSearch<FiniteType Node, GraphPathSearchSig<Node> Config> {
  /**
   * The set of all nodes reachable from the start nodes (inclusive).
   *
   * Note: this is fast to compute because it is essentially a unary predicate.
   */
  class ForwardNode extends Final<Node>::Type {
    ForwardNode() {
      Config::start(this) or
      exists(ForwardNode n | Config::edge(n, this))
    }

    string toString() { result = "ForwardNode" }
  }

  /**
   * The set of all forward nodes that reach end nodes (inclusive).
   *
   * These nodes are the nodes that exist along the path from start nodes to end nodes.
   *
   * Note: this is fast to compute because it is essentially a unary predicate.
   */
  class ReverseNode extends ForwardNode {
    ReverseNode() {
      Config::end(this) or
      exists(ReverseNode n | Config::edge(this, n))
    }

    override string toString() { result = "ReverseNode" }
  }

  /**
   * A start node, end node pair that are connected in the graph.
   */
  predicate hasConnection(ReverseNode n1, ReverseNode n2) {
    Config::start(n1) and
    Config::end(n2) and
    (hasPath(n1, n2) or n1 = n2)
  }

  /**
   * All relevant edges in the graph which participate in a connection from a start to an end node.
   */
  predicate pathEdge(ReverseNode n1, ReverseNode n2) { Config::edge(n1, n2) }

  /**
   * A performant path search within a custom directed graph from a set of start nodes to a set of
   * end nodes.
   *
   * This predicate is the main entry point for the forward-reverse pruning pattern. The design of
   * the config predicates has a great effect in how well this performance pattern will ultimately
   * perform.
   *
   * Example:
   * ```ql
   * from Person p1, Person p2
   * where GraphPathSearch<Person, Config>::hasPath(p1, p2)
   * select p1, p2
   * ```
   *
   * Note: this is fast to compute because limits the search space to nodes found by the fast unary
   * searches done to find `ForwardNode` and `ReverseNode`.
   */
  predicate hasPath(ReverseNode n1, ReverseNode n2) {
    Config::start(n1) and
    Config::edge(n1, n2)
    or
    exists(ReverseNode nMid |
      hasPath(n1, nMid) and
      Config::edge(nMid, n2)
    )
  }
}
