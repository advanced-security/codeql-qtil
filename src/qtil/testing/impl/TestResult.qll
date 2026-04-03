private import qtil.strings.TaggedString

private newtype TTestResult =
  TPass() or
  TFail()

class TestResult extends TTestResult {
  string toString() {
    // This resulting string will be printed and shown to users
    this = TPass() and result = "PASS: "
    or
    this = TFail() and result = "FAILURE: "
  }

  predicate isPass() { this = TPass() }

  predicate isFail() { this = TFail() }
}
