import qtil.inheritance.Finitize
import qtil.inheritance.Instance
import qtil.testing.Qnit

predicate finiteStr(string x) { x in ["foo", "bar", "baz"] }

// This should be a valid declaration.
class FiniteStr = Instance<Finitize<string, finiteStr/1>::Type>::Type;

class TestFiniteString extends Test, Case {
  override predicate run(Qnit test) {
    if count(FiniteStr t) = 3 and
      any(FiniteStr t) = "foo" and
      any(FiniteStr t) = "bar" and
      any(FiniteStr t) = "baz"
    then test.pass("Finitize works with finite strings")
    else
      test.fail("Finitize not working correctly.")
  }
}
