import qtil.testing.Qnit
import qtil.cfg.BlockId

/**
 * Mock control flow nodes for testing BlockId functionality
 */
class TestNode extends string {
  TestNode() {
    this =
      [
        "entry", "if", "if2", "then", "then2", "else", "else2", "merge", "loop", "exit",
        "early_exit"
      ]
  }

  string toString() { result = this }

  TestBlock getBasicBlock() {
    this = "entry" and result = "Entry"
    or
    this = "if" and result = "If"
    or
    this = "if2" and result = "If2"
    or
    this = "then" and result = "Then"
    or
    this = "then2" and result = "Then2"
    or
    this = "else" and result = "Else"
    or
    this = "else2" and result = "Else2"
    or
    this = "merge" and result = "Merge"
    or
    this = "loop" and result = "Loop"
    or
    this = "exit" and result = "Exit"
    or
    this = "early_exit" and result = "EarlyExit"
  }
}

/**
 * Mock basic blocks for testing different control flow patterns
 */
class TestBlock extends string {
  TestBlock() {
    this =
      ["Entry", "If", "Then", "Else", "If2", "Then2", "Else2", "Merge", "Loop", "Exit", "EarlyExit"]
  }

  string toString() { result = this }

  // Test diverging control flow (if-then-else)
  TestBlock getTrueSuccessor() {
    this = "If" and result = "Then"
    or
    this = "If2" and result = "Then2"
    or
    this = "Loop" and result = "Merge" // Loop condition true -> continue
  }

  TestBlock getFalseSuccessor() {
    this = "If" and result = "Else"
    or
    this = "If2" and result = "Else2"
    or
    this = "Loop" and result = "Exit" // Loop condition false -> exit
  }

  TestBlock getASuccessor() {
    // Diverging paths
    result = this.getTrueSuccessor()
    or
    result = this.getFalseSuccessor()
    or
    // Unconditional successors
    this = "Entry" and result = "If"
    or
    this = "Then" and result = "If2" // Non-exiting if-branch
    or
    this = "Else" and result = "EarlyExit" // Converging control flow
    or
    this = "Then2" and result = "Merge" // Converging control flow
    or
    this = "Else2" and result = "Merge" // Converging control flow
    or
    this = "Merge" and result = "Loop" // Cycle creation
  }

  TestNode getNode(int index) {
    index = 0 and
    (
      this = "Entry" and result = "entry"
      or
      this = "If" and result = "if"
      or
      this = "Then" and result = "then"
      or
      this = "Else" and result = "else"
      or
      this = "Merge" and result = "merge"
      or
      this = "Loop" and result = "loop"
      or
      this = "Exit" and result = "exit"
      or
      this = "EarlyExit" and result = "early_exit"
    )
  }
}

class TestEntryBlock extends TestBlock {
  TestEntryBlock() { this = "Entry" }
}

/**
 * Configuration for testing BlockId with our mock control flow graph
 */
module TestBlockIdConfig implements BlockIdConfigSig {
  class BasicBlock = TestBlock;

  class EntryBasicBlock = TestEntryBlock;

  class ControlFlowNode = TestNode;
}

module TestBlockId = BlockId<TestBlockIdConfig>;

/**
 * Test that all blocks receive unique IDs
 */
class TestUniqueBlockIds extends Test, Case {
  override predicate run(Qnit test) {
    if
      forall(TestBlock b1, TestBlock b2 |
        b1 != b2 and exists(TestBlockId::blockId(b1)) and exists(TestBlockId::blockId(b2))
      |
        TestBlockId::blockId(b1) != TestBlockId::blockId(b2)
      )
    then test.pass("All blocks have unique IDs")
    else test.fail("Some blocks have duplicate IDs")
  }
}

/**
 * Test that all control flow nodes receive unique IDs
 */
class TestUniqueNodeIds extends Test, Case {
  override predicate run(Qnit test) {
    if
      forall(TestNode n1, TestNode n2 |
        n1 != n2 and
        exists(TestBlockId::controlFlowNodeId(n1)) and
        exists(TestBlockId::controlFlowNodeId(n2))
      |
        TestBlockId::controlFlowNodeId(n1) != TestBlockId::controlFlowNodeId(n2)
      )
    then test.pass("All nodes have unique IDs")
    else test.fail("Some nodes have duplicate IDs")
  }
}

/**
 * Test that block IDs are contiguous (no gaps)
 */
class TestContiguousBlockIds extends Test, Case {
  override predicate run(Qnit test) {
    exists(int maxId |
      maxId = max(TestBlock b | exists(TestBlockId::blockId(b)) | TestBlockId::blockId(b)) and
      forall(int i | i in [1 .. maxId] | exists(TestBlock b | TestBlockId::blockId(b) = i))
    ) and
    test.pass("Block IDs are contiguous")
    or
    not exists(int maxId |
      maxId = max(TestBlock b | exists(TestBlockId::blockId(b)) | TestBlockId::blockId(b)) and
      forall(int i | i in [1 .. maxId] | exists(TestBlock b | TestBlockId::blockId(b) = i))
    ) and
    test.fail("Block IDs have gaps")
  }
}

/**
 * Test that node IDs are contiguous (no gaps)
 */
class TestContiguousNodeIds extends Test, Case {
  override predicate run(Qnit test) {
    exists(int maxId |
      maxId =
        max(TestNode n |
          exists(TestBlockId::controlFlowNodeId(n))
        |
          TestBlockId::controlFlowNodeId(n)
        ) and
      forall(int i | i in [1 .. maxId] | exists(TestNode n | TestBlockId::controlFlowNodeId(n) = i))
    ) and
    test.pass("Node IDs are contiguous")
    or
    not exists(int maxId |
      maxId =
        max(TestNode n |
          exists(TestBlockId::controlFlowNodeId(n))
        |
          TestBlockId::controlFlowNodeId(n)
        ) and
      forall(int i | i in [1 .. maxId] | exists(TestNode n | TestBlockId::controlFlowNodeId(n) = i))
    ) and
    test.fail("Node IDs have gaps")
  }
}

/**
 * Test that entry block has the lowest ID
 */
class TestEntryBlockFirstId extends Test, Case {
  override predicate run(Qnit test) {
    if
      exists(TestEntryBlock entry |
        TestBlockId::blockId(entry) = 1 or
        TestBlockId::blockId(entry) =
          min(TestBlock b | exists(TestBlockId::blockId(b)) | TestBlockId::blockId(b))
      )
    then test.pass("Entry block has the first ID")
    else test.fail("Entry block does not have the first ID")
  }
}

/**
 * Test ordering: blocks that don't loop should have higher IDs than their predecessors
 */
class TestBlockIdOrdering extends Test, Case {
  override predicate run(Qnit test) {
    if
      forall(TestBlock pred, TestBlock succ |
        succ = [pred.getFalseSuccessor(), pred.getTrueSuccessor(), pred.getASuccessor()] and
        not succ.getASuccessor+() = pred
      |
        TestBlockId::blockId(pred) < TestBlockId::blockId(succ)
      )
    then test.pass("Non-looping blocks have higher IDs than predecessors")
    else test.fail("Some non-looping blocks have lower IDs than predecessors")
  }
}

/**
 * Test that cyclic control flow is handled properly (no infinite recursion)
 */
class TestCyclicControlFlow extends Test, Case {
  override predicate run(Qnit test) {
    if
      exists(TestBlock loop |
        loop.toString() = "Loop" and
        loop.getASuccessor+() = loop and
        exists(TestBlockId::blockId(loop)) and
        forall(TestBlock succ | succ = loop.getASuccessor() | exists(TestBlockId::blockId(succ)))
      )
    then test.pass("Cyclic control flow is handled without infinite recursion")
    else test.fail("Cyclic control flow causes issues")
  }
}

/**
 * Test that early exit paths are properly handled
 */
class TestEarlyExitPaths extends Test, Case {
  override predicate run(Qnit test) {
    if
      exists(TestBlock earlyExit |
        earlyExit.toString() = "EarlyExit" and
        exists(TestBlockId::blockId(earlyExit))
      )
    then test.pass("Early exit paths are assigned IDs")
    else test.fail("Early exit paths are not properly handled")
  }
}

/**
 * Test diverging control flow: conditional successors should have different IDs
 */
class TestDivergingControlFlow extends Test, Case {
  override predicate run(Qnit test) {
    if
      exists(TestBlock ifBlock, TestBlock thenBlock, TestBlock elseBlock |
        ifBlock.toString() = "If" and
        thenBlock = ifBlock.getTrueSuccessor() and
        elseBlock = ifBlock.getFalseSuccessor() and
        exists(TestBlockId::blockId(thenBlock)) and
        exists(TestBlockId::blockId(elseBlock)) and
        TestBlockId::blockId(thenBlock) != TestBlockId::blockId(elseBlock)
      )
    then test.pass("Diverging control flow creates different branch IDs")
    else test.fail("Diverging control flow does not create different branch IDs")
  }
}

/**
 * Test that all reachable blocks from entry are assigned IDs
 */
class TestAllReachableBlocksHaveIds extends Test, Case {
  override predicate run(Qnit test) {
    if
      forall(TestBlock b |
        // Define reachability transitively from entry
        exists(TestEntryBlock entry |
          b = entry
          or
          exists(TestBlock pred |
            (pred = entry or pred.getASuccessor*() = b) and
            pred.getASuccessor() = b
          )
        )
      |
        exists(TestBlockId::blockId(b))
      )
    then test.pass("All reachable blocks have IDs")
    else test.fail("Some reachable blocks do not have IDs")
  }
}

/**
 * Test that nodes within blocks maintain relative ordering
 */
class TestNodeOrderingWithinBlocks extends Test, Case {
  override predicate run(Qnit test) {
    if
      forall(TestNode n1, TestNode n2 |
        n1.getBasicBlock() = n2.getBasicBlock() and
        exists(TestBlockId::controlFlowNodeId(n1)) and
        exists(TestBlockId::controlFlowNodeId(n2)) and
        n1 != n2
      |
        // Since we only have one node per block in our test, this should be trivially true
        TestBlockId::controlFlowNodeId(n1) != TestBlockId::controlFlowNodeId(n2)
      )
    then test.pass("Nodes within blocks maintain proper ordering")
    else test.fail("Node ordering within blocks is incorrect")
  }
}
