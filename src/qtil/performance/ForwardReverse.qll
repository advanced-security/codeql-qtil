private import qtil.parameterization.SignatureTypes
private import qtil.parameterization.Finalize

signature module ForwardReverseSig<FiniteType Node> {
  predicate start(Node n1);

  predicate edge(Node n1, Node n2);

  predicate end(Node n1);
}

module ForwardReverse<FiniteType Node, ForwardReverseSig<Node> Config> {
  class ForwardNode extends Final<Node>::Type {
    ForwardNode() {
      Config::start(this) or
      exists(ForwardNode n | Config::edge(n, this))
    }

    string toString() { result = "ForwardNode" }
  }

  class ReverseNode extends ForwardNode {
    ReverseNode() {
      Config::end(this) or
      exists(ReverseNode n | Config::edge(n, this))
    }

    override string toString() { result = "ReverseNode" }
  }

  predicate hasPath(Node n1, Node n2) {
    n1 instanceof ReverseNode and
    n2 instanceof ReverseNode and
    Config::edge(n1, n2)
    or
    exists(ReverseNode nMid |
      hasPath(n1, nMid) and
      Config::edge(nMid, n2)
    )
  }
}
