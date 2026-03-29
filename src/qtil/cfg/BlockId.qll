/**
 * A module that orders and assigns a unique ID to each block in a control flow graph, without
 * requiring location information, and ignoring cycles.
 *
 * In CodeQL we cannot impose an arbitrary order on objects, but only order them by integer or
 * string properties. We cannot order blocks by location information, because blocks inside macros
 * do not have unique locations. We also cannot perform a typical recursive algorithm with a set of
 * visited nodes in the graph, both because CodeQL does not have a `Set<T>` type, and also because
 * checking `not f(x)` in predicate `f(Block b)` introduces non-monotonic recursion.
 *
 * Instead we perform a multi step process to build a cycle-free binary tree over
 * `getTrueSuccessor()`/`getFalseSuccessor()`, via a new edge type `BlockEdge`, such that every node
 * in the tree has exactly one parent, which we can use to trivially assign a unique ID to each
 * block via a depth-first traversal of the control flow graph edges.
 *
 * The overall process to assign a unique ID to each block is as follows:
 * - First, we count the number of children from each root block, giving us an upper limit of
 *   recursive steps that may be needed in later steps, avoiding infinite recursion.
 * - Second, we compute the depth from which each block can be reached from its root, up to the
 *   maximum possible depth of the graph, the node count. This step may produce more than one result
 *   for each block involved in a cycle. However, it is monotonic, because adding a new depth for a
 *   block does not invalidate any previous depths.
 * - Third, we take the minimum of the depths computed at step two for each block.
 * - Fourth, for each node we find the "primary" and "secondary" deeper successors, which are the
 *   true and false successors that have a higher minimum depth than the current block, if they
 *   exist. The true successor is considered the primary and the false successor is considered the
 *   secondary, assuming both exist.
 * - Fourth, we define a new edge type `BlockEdge` that represents the edges in the tree formed by
 *   the primary and secondary deeper successors. Each edge points from a parent edge to a child
 *   block. This way, the data structure encodes the full path of how a block was reached, which is
 *   unique, and means each edge has exactly one parent, making our binary tree more or less a well
 *   formed and well behaved tree.
 * - Fifth, we can perform a simple depth-first traversal of the tree formed by `BlockEdge` to
 *   assign a unique ID to each edge. Our goal is that primary successors are assigned their parent
 *   ID + 1, and secondary successors are assigned the highest ID from the primary edge's subtree,
 *   plus one. We do not do this as a recursive algorithm with n steps, because in CodeQL that will
 *   introduce a join for each of the n steps, leading to O(n^2) performance. Instead, we separately
 *   count the number of edges in a subtree in log(n) steps, and then use that to infer what the
 *   maximum child Id of a primary edge will be. With this we can assign an ID to each node in log n
 *   steps since we recurse without backtracking.
 * - Finally, we can use `[rank](x)` to assign a unique ID to each block without gaps, in a
 *   breadth-first ordering, by ordering the blocks by their minimum temporary ID and their minimum
 *   depth. Their rank in that ordering is their final unique ID.
 *
 * If this process seems unnecessarily complex, consider an alternative approach that gets stuck in
 * infinite recursion, to perhaps justify this design.
 *
 * Assume we follow the fifth step above, but instead of using a `BlockEdge` type to represent the
 * edges in the tree, we simply use the predicates `getPrimarySuccessor()` and
 * `getSecondarySuccessor()` to recursively traverse the tree. Step five states that the id of the
 * primary successor is the parent ID + 1, and the id of the secondary successor is the highest ID
 * under the primary successor + 1. However, a block can have multiple parents. Therefore, there may
 * be a block reached via (primary, primary) and also via (secondary, primary). Under this process,
 * the block reached via (primary, secondary) should have an ID that is greater than the IDs of all
 * of the blocks reachable from (primary, ...). This is impossible, as the block's ID therefore
 * would need to be greater than itself. In CodeQL this manifests as giving this block an infinite
 * number of possible IDs, and therefore the query does not terminate.
 *
 * To avoid this, we fundamentally need to know how we got to assign the ID to a block, which is
 * what the `BlockEdge` type provides.
 */

import qtil.parameterization.Finalize

/**
 * Signature to add support for the `BlockId` module for a new language.
 *
 * This module is not necessarily intended to be used directly, check for a language-specific
 * instantiation of this module in the language-specific qtil pack.
 */
signature module BlockIdConfigSig {
  /**
   * A block specific to the given language's CFG.
   */
  class BasicBlock {
    /**
     * A block that is reached immediately after this block when a given conditional value returns
     * a true value.
     *
     * This predicate should only ever return a single result.
     */
    BasicBlock getTrueSuccessor();

    /**
     * A block that is reached immediately after this block when a given conditional value returns
     * a false value.
     *
     * This predicate should only ever return a single result.
     */
    BasicBlock getFalseSuccessor();

    /**
     * Get a block that conditionally follows this block -- perhaps unconditionally.
     *
     * This predicate is allowed to return:
     *  - The true successor and/or the false successor. These are not treated as unconditional.
     *  - An unconditional successor IF no true or false successor exists.
     *  - Multiple conditional non-true, non-false successors (for example, switch/case) is not
     *    fully supported, and will result in duplicated block IDs.
     */
    BasicBlock getASuccessor();

    /**
     * Get the nth control flow node in this block.
     */
    ControlFlowNode getNode(int index);

    string toString();
  }

  /**
   * A basic block representing an entry point into a control flow graph.
   */
  class EntryBasicBlock extends BasicBlock;

  /**
   * A control flow node, which is a part of a basic block.
   */
  class ControlFlowNode {
    string toString();

    /**
     * Get the basic block that controls this node.
     */
    BasicBlock getBasicBlock();
  }
}

/**
 * A module that orders and assigns a unique ID to each block in a control flow graph, without
 * requiring location information, and ignoring cycles via predicates `blockId(b)`, and
 * `controlFlowNodeId(n)`.
 *
 * This module is not necessarily intended to be used directly, check for a language-specific
 * instantiation of this module in the language-specific qtil pack.
 *
 * Supporting assignment of a blockID without location information is important for certain
 * languages and use cases -- for instance, C++ macro expansions do not have location info.
 */
module BlockId<BlockIdConfigSig Config> {
  import Config

  /**
   * A contiguous unique ID for each basic block in the control flow graph, assigned in a
   * breadth-first manner.
   */
  cached
  int blockId(BasicBlock b) {
    exists(RootBlock root |
      b = root.getAChild() and
      b =
        rank[result](BasicBlock test |
          test = root.getAChild()
        |
          test order by getMinBlockDepth(root, test), depthFirstBlockId(test)
        )
    )
  }

  /**
   * A contiguous unique ID for each control flow node in the control flow graph, assigned in a
   * breadth-first manner.
   */
  cached
  int controlFlowNodeId(ControlFlowNode n) {
    exists(RootBlock root |
      n.getBasicBlock() = root.getAChild() and
      n =
        rank[result](ControlFlowNode test, BasicBlock bb, int idx |
          bb = root.getAChild() and
          bb = test.getBasicBlock() and
          test = bb.getNode(idx)
        |
          test order by blockId(bb), idx
        )
    )
  }

  /**
   * An extension of `EntryBasicBlock` that we use to find all reachable children.
   */
  private class RootBlock extends Final<EntryBasicBlock>::Type {
    BasicBlock getAChild() {
      result = this
      or
      exists(BasicBlock pred | pred = getAChild() and result = pred.getASuccessor())
    }

    int getChildCount() { result = count(BasicBlock b | b = getAChild()) }
  }

  /**
   * Recursively assigns parent depth + 1 to each child block, starting from the root block at depth
   * zero.
   *
   * In the presence of cycles, this will assign multiple depths to cyclic blocks, and would not
   * terminate without an upper limit on the depth, for which we can use `getChildCount()` from the
   * root block.
   */
  private predicate getABlockDepth(RootBlock root, BasicBlock b, int depth) {
    depth = 0 and b = root
    or
    // We must carefully consider loops in the CFG. This process would never complete without an
    // upper limit in the presence of cycles. This predicate still can hold for multiple depths for
    // a given block, but we can aggregate those in a second stage.
    depth <= root.getChildCount() and
    exists(BasicBlock parent |
      getABlockDepth(root, parent, depth - 1) and
      parent.getASuccessor() = b
    )
  }

  /**
   * Finds the minimum number of steps from the root block to the given basic block, properly handling
   * cycles in the control flow graph.
   *
   * Note that this pairing of `getABlockDepth()` and `getMinBlockDepth()` is a CodeQL friendly way of
   * getting this data without introducing non-monotonic recursion.
   */
  private int getMinBlockDepth(RootBlock root, BasicBlock b) {
    result = min(int depth | getABlockDepth(root, b, depth))
  }

  /**
   * Returns the true successor of the given basic block if it has a higher minimum depth.
   */
  private BasicBlock getDeeperTrueSuccessor(BasicBlock b) {
    result = b.getTrueSuccessor() and
    exists(RootBlock root | getMinBlockDepth(root, result) = getMinBlockDepth(root, b) + 1)
  }

  /**
   * Returns the false successor of the given basic block if it has a higher minimum depth.
   */
  private BasicBlock getDeeperFalseSuccessor(BasicBlock b) {
    result = b.getFalseSuccessor() and
    exists(RootBlock root | getMinBlockDepth(root, result) = getMinBlockDepth(root, b) + 1)
  }

  /**
   * Some blocks do not have a true or false successor, but an unconditional successor. This function
   * returns that successor if it has a higher minimum depth.
   */
  private BasicBlock getDeeperUnconditionalSuccessor(BasicBlock b) {
    // TODO: Add support for multiple ordered successors, to support, for instance, switch/case.
    result = b.getASuccessor() and
    not result = b.getTrueSuccessor() and
    not result = b.getFalseSuccessor() and
    //exists(RootBlock root | getMinBlockDepth(root, result) > getMinBlockDepth(root, b))
    exists(RootBlock root | getMinBlockDepth(root, result) = getMinBlockDepth(root, b) + 1)
  }

  /**
   * Returns the "first" deeper successor of the given basic block: this is the deeper true successor
   * or deeper unconditional successor if either exists, or the deeper false successor, if it exists.
   * A block may not have a deeper successor at all, in which case this function returns nothing.
   */
  private BasicBlock getPrimarySuccessor(BasicBlock b) {
    if exists(getDeeperUnconditionalSuccessor(b))
    then result = getDeeperUnconditionalSuccessor(b)
    else
      if exists(getDeeperTrueSuccessor(b))
      then result = getDeeperTrueSuccessor(b)
      else result = getDeeperFalseSuccessor(b)
  }

  /**
   * Returns the "second" deeper successor of the given basic block. This can only be the deeper
   * false successor, if it exists and is not the primary successor; otherwise returns nothing.
   */
  private BasicBlock getSecondarySuccessor(BasicBlock b) {
    exists(getDeeperTrueSuccessor(b)) and
    result = getDeeperFalseSuccessor(b)
  }

  /**
   * A new type that represents edges in the tree formed by primary and secondary deeper successors.
   *
   * This type will produce a mostly well-formed binary tree, where each node has exactly one parent.
   * To accomplish this, we say that the parent is a prior edge rather than a block. Blocks that have
   * multiple incoming edges will therefore produce multiple `BlockEdge` instances, each uniquely
   * identifiable with a single, different parent edge.
   *
   * Constructing this without infinite recursion requires that we use the `getPrimarySuccessor()` and
   * `getSecondarySuccessor()` functions to find the child blocks, which is a cycle-free graph.
   */
  private newtype TBlockEdge =
    TStartEdge(RootBlock root) or
    TPrimaryEdge(BlockEdge parentEdge, BasicBlock child) {
      child = getPrimarySuccessor(parentEdge.getEnd())
    } or
    TSecondaryEdge(BlockEdge parentEdge, BasicBlock child) {
      child = getSecondarySuccessor(parentEdge.getEnd())
    }

  private class BlockEdge extends TBlockEdge {
    /**
     * Get the block this edge points to.
     */
    BasicBlock getEnd() {
      this = TStartEdge(result)
      or
      this = TPrimaryEdge(_, result)
      or
      this = TSecondaryEdge(_, result)
    }

    /**
     * Get the parent edge.
     *
     * Edges don't point from a block to a block, but rather from an edge to a block, to create a more
     * well-formed tree structure.
     */
    BlockEdge getStart() {
      this = TPrimaryEdge(result, _) or
      this = TSecondaryEdge(result, _)
    }

    /**
     * Whether the edge represents a primary or secondary successor.
     */
    predicate isPrimaryEdge() { this = TPrimaryEdge(_, _) }

    /**
     * Whether the edge represents a primary or secondary successor.
     */
    predicate isSecondaryEdge() { this = TSecondaryEdge(_, _) }

    /**
     * Gets the child edge in the graph which is a primary edge.
     */
    BlockEdge getPrimaryEdge() { result = TPrimaryEdge(this, _) }

    /**
     * Gets the child edge in the graph which is a secondary edge.
     */
    BlockEdge getSecondaryEdge() { result = TSecondaryEdge(this, _) }

    /**
     * Counts the number of edges in this graph rooted at this edge, including this edge.
     */
    int countEdges() {
      result = getPrimaryEdge().countEdges() + getSecondaryEdge().countEdges() + 1
      or
      not exists(getSecondaryEdge()) and result = getPrimaryEdge().countEdges() + 1
      or
      not exists(getPrimaryEdge()) and result = 1
    }

    /**
     * Computes the ID of this edge in a depth-first traversal of the tree formed by `BlockEdge`
     * instances.
     *
     * The ID is of a primary edge is equal to its parent's ID + 1. The ID of a secondary edge should
     * equal the highest ID of any edge in the primary edge's subtree + 1.
     *
     * The ID assignment process could recurse down the primary nodes, and backtrack to recurse on the
     * secondary nodes, continually incrementing a counter as it goes. However, this performs poorly
     * in CodeQL, as it takes `n` steps, and for each `n` we join the previous delta against the `n`
     * nodes that may require an update, leading to O(n^2) performance.
     *
     * Instead, we first count the number of edges in each subtree, which takes log(n) steps. Then, we
     * can compute what the maximum ID in the primary subtree is, without recursion, as the parent ID
     * + the number of edges in the primary subtree. Then we can recurse down the tree as before, but
     * without needing to backtrack, completing in O(n log n) steps.
     */
    int getEdgeId() {
      this = TStartEdge(_) and result = 0
      or
      (
        isPrimaryEdge() and result = getStart().getEdgeId() + 1
        or
        isSecondaryEdge() and
        result = getStart().getEdgeId() + getStart().getPrimaryEdge().countEdges() + 1
      )
    }

    string toString() { result = "Edge" }
  }

  /**
   * Gets the depth-first ID of the given basic block, based on the depth-first traversal of the tree
   * formed by `BlockEdge` instances.
   *
   * Note that this ID is sparse, as multiple edges can point to the same block. We only take the
   * minimum of these IDs, which leaves gaps in the numbering.
   */
  private int depthFirstBlockId(BasicBlock b) {
    result = min(BlockEdge edge | edge.getEnd() = b | edge.getEdgeId())
  }
}
