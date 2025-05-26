import qtil.inheritance.Finitize
import qtil.inheritance.Instance
import qtil.testing.Qnit

predicate finiteStr(string x) { x in ["foo", "bar", "baz"] }

class FiniteStr = Finitize<string, finiteStr/1>::Type;

// Test that this is a valid declaration.
class InstanceStr = Instance<FiniteStr>::Type;

class TestFiniteString extends Test, Case {
  override predicate run(Qnit test) {
    if
      count(FiniteStr t) = 3 and
      any(FiniteStr t) = "foo" and
      any(FiniteStr t) = "bar" and
      any(FiniteStr t) = "baz" and
      // Test that members are inherited correctly.
      any(FiniteStr t).toUpperCase() = "FOO" and
      // Test that the InstanceStr class has the same number of instances.
      count(InstanceStr i) = 3
    then test.pass("Finitize works with finite strings")
    else test.fail("Finitize not working correctly.")
  }
}
