import qtil.list.PlaceholderList

/**
 * A finite stringable type for use as test elements.
 */
class TestElement extends int {
  TestElement() { this in [1..6] }

  string toString() { exists(int n | n = this | result = n.toString()) }
}

/**
 * A finite stringable type for use as test placeholders.
 */
class TestPlaceholder extends int {
  TestPlaceholder() { this in [1..7] }

  string toString() { exists(int n | n = this | result = n.toString()) }
}

/**
 * A test configuration using default maxResults (5).
 *
 * - Element 1: 1 placeholder (p=1)
 * - Element 2: 2 placeholders (p=1,2)
 * - Element 3: 3 placeholders (p=1,2,3)
 * - Element 4: 4 placeholders (p=1,2,3,4)
 * - Element 5: 5 placeholders (p=1..5)
 * - Element 6: 6 placeholders (p=1..6) — more than maxResults
 */
module TestConfig implements PlaceholderListSig<TestElement, TestPlaceholder> {
  predicate problems(TestElement e, string msg, TestPlaceholder p, string pStr) {
    p in [1..e] and pStr = p.toString() and msg = "$@ is cool"
  }
}

module DefaultMax = PlaceholderList<TestElement, TestPlaceholder, TestConfig>;

query predicate testDefault(
  TestElement e, string outMsg,
  TestPlaceholder p1, string s1,
  TestPlaceholder p2, string s2,
  TestPlaceholder p3, string s3,
  TestPlaceholder p4, string s4,
  TestPlaceholder p5, string s5
) {
  DefaultMax::problems(e, outMsg, p1, s1, p2, s2, p3, s3, p4, s4, p5, s5)
}

/**
 * A test configuration with maxResults = 2.
 *
 * - Element 1: 1 placeholder
 * - Element 2: 2 placeholders (exact max)
 * - Element 3: 3 placeholders — overflow by 1
 */
module TestConfigMaxTwo implements PlaceholderListSig<TestElement, TestPlaceholder> {
  predicate problems(TestElement e, string msg, TestPlaceholder p, string pStr) {
    e in [1..3] and p in [1..e] and pStr = p.toString() and msg = "$@ is related"
  }

  int maxResults() { result = 2 }
}

module MaxTwo = PlaceholderList<TestElement, TestPlaceholder, TestConfigMaxTwo>;

query predicate testMaxTwo(
  TestElement e, string outMsg,
  TestPlaceholder p1, string s1,
  TestPlaceholder p2, string s2,
  TestPlaceholder p3, string s3,
  TestPlaceholder p4, string s4,
  TestPlaceholder p5, string s5
) {
  MaxTwo::problems(e, outMsg, p1, s1, p2, s2, p3, s3, p4, s4, p5, s5)
}

