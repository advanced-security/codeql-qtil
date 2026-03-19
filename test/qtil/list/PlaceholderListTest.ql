import qtil.list.PlaceholderList
import qtil.testing.Qnit

/**
 * A finite stringable type for use as test elements.
 */
class TestElement extends int {
  TestElement() { this in [1..5] }

  string toString() { exists(int n | n = this | result = n.toString()) }
}

/**
 * A finite stringable type for use as test placeholders.
 */
class TestPlaceholder extends int {
  TestPlaceholder() { this in [1..6] }

  string toString() { exists(int n | n = this | result = n.toString()) }
}

/**
 * A test configuration using default maxResults (3).
 *
 * - Element 1: 1 placeholder (p=1)
 * - Element 2: 2 placeholders (p=1,2)
 * - Element 3: 3 placeholders (p=1,2,3)
 * - Element 4: 4 placeholders (p=1,2,3,4) — more than maxResults
 */
module TestConfig implements PlaceholderListSig<TestElement, TestPlaceholder> {
  predicate problems(TestElement e, string msg, TestPlaceholder p, string pStr) {
    e = 1 and p = 1 and pStr = p.toString() and msg = "$@ is cool"
    or
    e = 2 and p in [1 .. 2] and pStr = p.toString() and msg = "$@ is cool"
    or
    e = 3 and p in [1 .. 3] and pStr = p.toString() and msg = "$@ is cool"
    or
    e = 4 and p in [1 .. 4] and pStr = p.toString() and msg = "$@ is cool"
  }
}

module DefaultMaxInstance = PlaceholderList<TestElement, TestPlaceholder, TestConfig>;

/**
 * A test configuration with maxResults = 2.
 *
 * - Element 5: 4 placeholders (p=1,2,3,4) — more than maxResults
 */
module TestConfigMaxTwo implements PlaceholderListSig<TestElement, TestPlaceholder> {
  predicate problems(TestElement e, string msg, TestPlaceholder p, string pStr) {
    e = 5 and p in [1 .. 4] and pStr = p.toString() and msg = "$@ is related"
  }

  int maxResults() { result = 2 }
}

/**
 * A test configuration with maxResults = 1.
 * Tests the special case where only 1 placeholder is shown with overflow.
 *
 * - Element 5 (in this config): 3 placeholders — tests "N more" with no comma
 */
module TestConfigMaxOne implements PlaceholderListSig<TestElement, TestPlaceholder> {
  predicate problems(TestElement e, string msg, TestPlaceholder p, string pStr) {
    e = 5 and p in [1 .. 3] and pStr = p.toString() and msg = "$@ is related"
  }

  int maxResults() { result = 1 }
}

module MaxOneInstance = PlaceholderList<TestElement, TestPlaceholder, TestConfigMaxOne>;

module MaxTwoInstance = PlaceholderList<TestElement, TestPlaceholder, TestConfigMaxTwo>;

class TestMaxOneResults extends Test, Case {
  override predicate run(Qnit test) {
    // Element 5: 3 placeholders, maxResults=1 → shows 1 + "and 2 more" (no comma before "and")
    if
      MaxOneInstance::problems(5, "$@ and 2 more is related", 1, "1", 1, "", 1, "")
    then test.pass("MaxResults=1 with overflow: correct message without comma before 'and'")
    else test.fail("MaxResults=1 with overflow: incorrect output")
  }
}

class TestSinglePlaceholder extends Test, Case {
  override predicate run(Qnit test) {
    // Element 1: 1 placeholder → message unchanged, p1 filled, p2/p3 use p1 with ""
    if
      DefaultMaxInstance::problems(1, "$@ is cool", 1, "1", 1, "", 1, "")
    then test.pass("Single placeholder: correct message and placeholder slots")
    else test.fail("Single placeholder: incorrect output")
  }
}

class TestTwoPlaceholders extends Test, Case {
  override predicate run(Qnit test) {
    // Element 2: 2 placeholders → "$@ and $@ is cool", p1/p2 filled, p3 uses p1 with ""
    if
      DefaultMaxInstance::problems(2, "$@ and $@ is cool", 1, "1", 2, "2", 1, "")
    then test.pass("Two placeholders: correct message and placeholder slots")
    else test.fail("Two placeholders: incorrect output")
  }
}

class TestThreePlaceholders extends Test, Case {
  override predicate run(Qnit test) {
    // Element 3: 3 placeholders → "$@, $@, and $@ is cool", all slots filled
    if
      DefaultMaxInstance::problems(3, "$@, $@, and $@ is cool", 1, "1", 2, "2", 3, "3")
    then test.pass("Three placeholders: correct message and placeholder slots")
    else test.fail("Three placeholders: incorrect output")
  }
}

class TestExcessPlaceholders extends Test, Case {
  override predicate run(Qnit test) {
    // Element 4: 4 placeholders, maxResults=3 → shows 3 + "and 1 more", first 3 slots filled
    if
      DefaultMaxInstance::problems(4, "$@, $@, $@, and 1 more is cool", 1, "1", 2, "2", 3, "3")
    then test.pass("Excess placeholders (4 with max 3): correct message and placeholder slots")
    else test.fail("Excess placeholders (4 with max 3): incorrect output")
  }
}

class TestCustomMaxResults extends Test, Case {
  override predicate run(Qnit test) {
    // Element 5: 4 placeholders, maxResults=2 → shows 2 + "and 2 more", first 2 slots filled, p3 padded
    if
      MaxTwoInstance::problems(5, "$@, $@, and 2 more is related", 1, "1", 2, "2", 1, "")
    then test.pass("Custom maxResults (4 with max 2): correct message and placeholder slots")
    else test.fail("Custom maxResults (4 with max 2): incorrect output")
  }
}

class TestNoDuplicateRows extends Test, Case {
  override predicate run(Qnit test) {
    // Each element should produce exactly one output row
    if
      count(string msg, TestPlaceholder p1, string s1, TestPlaceholder p2, string s2,
        TestPlaceholder p3, string s3 |
        DefaultMaxInstance::problems(1, msg, p1, s1, p2, s2, p3, s3)
      ) = 1 and
      count(string msg, TestPlaceholder p1, string s1, TestPlaceholder p2, string s2,
        TestPlaceholder p3, string s3 |
        DefaultMaxInstance::problems(2, msg, p1, s1, p2, s2, p3, s3)
      ) = 1 and
      count(string msg, TestPlaceholder p1, string s1, TestPlaceholder p2, string s2,
        TestPlaceholder p3, string s3 |
        DefaultMaxInstance::problems(3, msg, p1, s1, p2, s2, p3, s3)
      ) = 1 and
      count(string msg, TestPlaceholder p1, string s1, TestPlaceholder p2, string s2,
        TestPlaceholder p3, string s3 |
        DefaultMaxInstance::problems(4, msg, p1, s1, p2, s2, p3, s3)
      ) = 1
    then test.pass("Each element produces exactly one output row")
    else test.fail("Some element produces more or fewer than one output row")
  }
}
