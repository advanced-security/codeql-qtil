private import qtil.inheritance.UnderlyingString

/**
 * A string that is re-typedef'd to Qnit for the sake of a pretty API.
 *
 * This class is used to define the predicate `run(Qnit test)`, which is prettier than
 * `run(string test)`, with the following methods:
 *  - `pass(description)`: Finish a test, with a pass description.
 *  - `fail(description)`: Finish a test, with a fail description.
 *  - `isFailing()`/`isPassing()`: Primarily for internal use.
 */
bindingset[this]
class Qnit extends UnderlyingString {
  /**
   * Call this method inside of `Test.run(Qnit test)` to report a failing test case.
   *
   * It is recommended to use unique strings for each test case, as this will allow you to
   * uniquely identify which tests failed, due to the way QL works.
   */
  bindingset[description]
  predicate fail(string description) { this = "FAILURE: " + description }

  /**
   * Call this method inside of `Test.run(Qnit test)` to report a passing test case.
   *
   * It is recommended to use unique strings for each test case, as this will allow Qnit to
   * properly count the number of tests that passed, due to the way QL works.
   */
  bindingset[name]
  predicate pass(string name) { this = "PASS: " + name }

  /**
   * Mostly intended for internal purposes, holds if the test fails.
   */
  bindingset[this]
  predicate isFailing() { str().matches("FAILURE: %") }

  /**
   * Mostly intended for internal purposes, holds if the test passes.
   */
  bindingset[this]
  predicate isPassing() { str().matches("PASS: %") }

  bindingset[this]
  string getDescription() { result = str().regexpReplaceAll("^(FAILURE|PASS): ", "") }
}