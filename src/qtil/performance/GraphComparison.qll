signature module GraphComparisonSig {
  class Node;

  predicate comparisonRoot(Node a, Node b);

  predicate terminallyEquivalent(Node a, Node b);

  predicate equivalentIfTransivitelyEquivalent(Node a, Node b, Node c, Node d);
}

module GraphComparison<GraphComparisonSig Config> {
  predicate compares(Config::Node a, Config::Node b) {
    Config::comparisonRoot(a, b)
    or
    exists(Config::Node aPrev, Config::Node bPrev |
      compares(aPrev, bPrev) and
      not Config::terminallyEquivalent(a, b) and
      Config::equivalentIfTransivitelyEquivalent(aPrev, bPrev, a, b)
    )
  }

  predicate equivalent(Config::Node a, Config::Node b) {
    compares(a, b) and
    (
      Config::terminallyEquivalent(a, b)
      or
      forex(Config::Node aNext, Config::Node bNext |
        Config::equivalentIfTransivitelyEquivalent(a, b, aNext, bNext) and
        equivalent(aNext, bNext)
      )
    )
  }

  bindingset[a, b]
  pragma[inline_late]
  predicate equivalentUnordered(Config::Node a, Config::Node b) {
    equivalent(a, b) or
    equivalent(b, a)
  }
}
