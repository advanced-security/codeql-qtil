import qtil.strings.Plural
import qtil.testing.Qnit

class TestBasePlural extends Test, Case {
  override predicate run(Qnit test) {
    if plural("apple") = "apples"
    then test.pass("Basic pluralization works")
    else test.fail("Basic pluralization doesn't work")
  }
}

class TestPluralZero extends Test, Case {
  override predicate run(Qnit test) {
    if plural("apple", 0) = "apples"
    then test.pass("Pluralization with zero works")
    else test.fail("Pluralization with zero doesn't work")
  }
}

class TestPluralOne extends Test, Case {
  override predicate run(Qnit test) {
    if plural("apple", 1) = "apple"
    then test.pass("Pluralization with one works")
    else test.fail("Pluralization with one doesn't work")
  }
}

class TestPluralNegativeOne extends Test, Case {
  override predicate run(Qnit test) {
    if plural("apple", -1) = "apples"
    then test.pass("Pluralization with negative one works")
    else test.fail("Pluralization with negative one doesn't work")
  }
}

class TestPluralMany extends Test, Case {
  override predicate run(Qnit test) {
    if plural("apple", [2 .. 100]) = "apples"
    then test.pass("Pluralization with two works")
    else test.fail("Pluralization with two doesn't work")
  }
}

class TestPluralWithCustomTerms extends Test, Case {
  override predicate run(Qnit test) {
    if plural("octopus", "octopi", 2) = "octopi"
    then test.pass("Pluralization with custom terms works")
    else test.fail("Pluralization with custom terms doesn't work")
  }
}

class TestPluralWithCustomTermsSingular extends Test, Case {
  override predicate run(Qnit test) {
    if plural("octopus", "octopi", 1) = "octopus"
    then test.pass("Pluralization with custom terms singular works")
    else test.fail("Pluralization with custom terms singular doesn't work")
  }
}
