import qtil.results.LimitResults
import qtil.testing.Qnit
import Bugs

module TestConfig implements LimitResultsConfigSig<Bug, BugField> {
  predicate problem(Bug bug, BugField field) { field.getBug() = bug }

  bindingset[remaining]
  string message(Bug bug, BugField field, string remaining) {
    result = bug.getName() + " has field " + field.getFieldName() + remaining
  }

  string orderBy(BugField field) { result = field.getFieldName() }

  int maxResults() { result = 3 }
}

module Results = LimitResults<Bug, BugField, TestConfig>;

/** BugA has 1 field (X), which is fewer than maxResults=3, so all results are shown. */
class TestBugAResultCount extends Test, Case {
  override predicate run(Qnit test) {
    if count(BugField f, string msg | Results::hasLimitedResult(any(Bug b | b = TBugA()), f, msg)) =
      1
    then test.pass("BugA: 1 result shown (fewer than maxResults)")
    else test.fail("BugA: wrong result count")
  }
}

/** BugA shows field X with no suffix since total <= maxResults. */
class TestBugANoSuffix extends Test, Case {
  override predicate run(Qnit test) {
    if
      exists(BugField f, string msg |
        Results::hasLimitedResult(any(Bug b | b = TBugA()), f, msg) and
        f.getFieldName() = "X" and
        msg = "BugA has field X"
      )
    then test.pass("BugA: correct message with no suffix")
    else test.fail("BugA: message incorrect")
  }
}

/** BugB has 3 fields (A, B, C), exactly maxResults=3, so all results are shown. */
class TestBugBResultCount extends Test, Case {
  override predicate run(Qnit test) {
    if count(BugField f, string msg | Results::hasLimitedResult(any(Bug b | b = TBugB()), f, msg)) =
      3
    then test.pass("BugB: 3 results shown (exactly maxResults)")
    else test.fail("BugB: wrong result count")
  }
}

/** BugB shows all 3 fields with no suffix since total <= maxResults. */
class TestBugBNoSuffix extends Test, Case {
  override predicate run(Qnit test) {
    if
      forall(string fieldName |
        fieldName = ["A", "B", "C"] and
        exists(BugField f |
          f.getFieldName() = fieldName and
          f.getBugName() = "BugB"
        )
      |
        exists(BugField f, string msg |
          Results::hasLimitedResult(any(Bug b | b = TBugB()), f, msg) and
          f.getFieldName() = fieldName and
          msg = "BugB has field " + fieldName
        )
      )
    then test.pass("BugB: all 3 results shown with no suffix")
    else test.fail("BugB: some results have wrong message or are missing")
  }
}

/** BugC has 5 fields (A, B, C, D, E), which exceeds maxResults=3, so only 3 are shown. */
class TestBugCResultCount extends Test, Case {
  override predicate run(Qnit test) {
    if count(BugField f, string msg | Results::hasLimitedResult(any(Bug b | b = TBugC()), f, msg)) =
      3
    then test.pass("BugC: 3 results shown (capped at maxResults)")
    else test.fail("BugC: wrong result count")
  }
}

/** BugC shows only the first 3 fields alphabetically (A, B, C), not D or E. */
class TestBugCTopRanked extends Test, Case {
  override predicate run(Qnit test) {
    if
      forall(string fieldName | fieldName = ["A", "B", "C"] |
        exists(BugField f |
          Results::hasLimitedResult(any(Bug b | b = TBugC()), f, _) and
          f.getFieldName() = fieldName and
          f.getBugName() = "BugC"
        )
      ) and
      not exists(BugField f |
        Results::hasLimitedResult(any(Bug b | b = TBugC()), f, _) and
        f.getFieldName() = ["D", "E"] and
        f.getBugName() = "BugC"
      )
    then test.pass("BugC: top 3 alphabetical fields shown, D and E omitted")
    else test.fail("BugC: wrong fields shown")
  }
}

/** BugC shows a suffix " (and 2 more)" since 5 - 3 = 2 entities are omitted. */
class TestBugCSuffix extends Test, Case {
  override predicate run(Qnit test) {
    if
      forall(BugField f, string msg |
        Results::hasLimitedResult(any(Bug b | b = TBugC()), f, msg)
      |
        msg.matches("% (and 2 more)")
      )
    then test.pass("BugC: all shown results have ' (and 2 more)' suffix")
    else test.fail("BugC: some results have wrong suffix")
  }
}
