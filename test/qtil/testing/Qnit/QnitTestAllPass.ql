import qtil.testing.Qnit
class QnitTestPass extends Test, Case {
    override predicate run(Qnit test) {
        if (any())
        then test.pass("A test case can pass")
        else test.fail("A test case can't pass")
    }
}