import qtil.testing.Qnit

class QnitTestPass extends Test, Case {
  override predicate run(Qnit test) {
    if any() then test.pass("A test case can pass") else test.fail("A test case can't pass")
  }
}

class QnitTestFail extends Test, Case {
  override predicate run(Qnit test) {
    if none()
    then test.pass("This test should have failed")
    else test.fail("This test is supposed to fail")
  }
}

class QnitTestComplexPass extends Test, Case {
  predicate isEqualToOne(int i) { i = 1 }

  override predicate run(Qnit test) {
    if isEqualToOne(1)
    then test.pass("A complex test case can pass")
    else test.fail("A complex test case can't pass")
  }
}

class QnitTestComplexFail extends Test, Case {
  predicate isEqualToOne(int i) { i = 1 }

  override predicate run(Qnit test) {
    if isEqualToOne(2)
    then test.pass("This complex test should have failed")
    else test.fail("This complex test is supposed to fail")
  }
}
