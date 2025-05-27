import qtil.strings.Plural
import qtil.testing.impl.Qnit
import qtil.testing.impl.Test

query predicate test(string report) {
  if count(Qnit test | isFailing(test)) = 0
  then
    exists(int passed |
      passed = count(Qnit test | isPassing(test)) and
      report = plural("1 test", "All " + passed + " tests", passed) + " passed."
    )
  else
    exists(Qnit test |
      (isFailing(test) or isPassing(test)) and
      report = test
    )
}

private predicate isFailing(Qnit test) { exists(Case c | c.run(test) and test.isFailing()) }

private predicate isPassing(Qnit test) { exists(Case c | c.run(test) and test.isPassing()) }
