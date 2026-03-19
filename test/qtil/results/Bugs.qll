/**
 * Test data for LimitResultsTest.ql.
 *
 * Models a simple set of "bugs", each associated with a set of "fields".
 *
 * - BugA: 1 field (X) - fewer than maxResults
 * - BugB: 3 fields (A, B, C) - exactly maxResults
 * - BugC: 5 fields (A, B, C, D, E) - more than maxResults
 */
newtype TBug =
  TBugA() or
  TBugB() or
  TBugC()

class Bug extends TBug {
  string getName() {
    this = TBugA() and result = "BugA"
    or
    this = TBugB() and result = "BugB"
    or
    this = TBugC() and result = "BugC"
  }

  string toString() { result = getName() }
}

newtype TBugField =
  TBugFieldPair(string bugName, string fieldName) {
    bugName = "BugA" and fieldName = "X"
    or
    bugName = "BugB" and fieldName = ["A", "B", "C"]
    or
    bugName = "BugC" and fieldName = ["A", "B", "C", "D", "E"]
  }

class BugField extends TBugField {
  string getBugName() { this = TBugFieldPair(result, _) }

  string getFieldName() { this = TBugFieldPair(_, result) }

  string toString() { result = getBugName() + "." + getFieldName() }

  Bug getBug() { result.getName() = getBugName() }
}
