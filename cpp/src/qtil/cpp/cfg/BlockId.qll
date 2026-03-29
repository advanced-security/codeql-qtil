private import cpp as cpp
private import qtil.cfg.BlockId
private import qtil.inheritance.Instance

/**
 * Get an ID for a given block, which is typically(*) unique.
 *
 * (*) Current implementation of algorithm that assigns blocks will not give unique for results
 * inside switch/case statements.
 */
int blockId(cpp::BasicBlock bb) { result = CppBlockId::blockId(bb) }

/**
 * Get an ID for a given control flow node, which is typically(*) unique.
 *
 * (*) Current implementation of algorithm that assigns blocks will not give unique for results
 * inside switch/case statements.
 */
int controlFlowNodeId(cpp::ControlFlowNode node) { result = CppBlockId::controlFlowNodeId(node) }

private module CppBlockIdConfig implements BlockIdConfigSig {
  class BasicBlock extends Instance<cpp::BasicBlock>::Type {
    BasicBlock getTrueSuccessor() { result = inst().getATrueSuccessor() }

    BasicBlock getFalseSuccessor() { result = inst().getAFalseSuccessor() }

    BasicBlock getASuccessor() { result = inst().getASuccessor() }

    ControlFlowNode getNode(int index) { result = inst().getNode(index) }
  }

  class EntryBasicBlock extends BasicBlock {
    EntryBasicBlock() { this instanceof cpp::EntryBasicBlock }
  }

  class ControlFlowNode extends Instance<cpp::ControlFlowNode>::Type {
    BasicBlock getBasicBlock() { result = inst().getBasicBlock() }
  }
}

private import BlockId<CppBlockIdConfig> as CppBlockId
