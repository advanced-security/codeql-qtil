import qtil.results.LimitResults
import Bugs

module TestConfig implements LimitResultsConfigSig<Bug, BugField> {
  predicate problem(Bug bug, BugField field) { field.getBug() = bug }

  bindingset[remaining]
  string message(Bug bug, BugField field, string remaining) {
    result = bug.getName() + " has field " + field.getFieldName() + remaining
  }
}

module Results = LimitResults<Bug, BugField, TestConfig>;

query predicate problems(Bug bug, string msg, BugField field, string fieldStr) {
  Results::problems(bug, msg, field, fieldStr)
}
