import qtil.strings.TaggedString
import qtil.testing.Qnit

class Tag extends string {
  Tag() { this in ["tagA", "tagB"] }

  string toString() { result = super.toString() }
}

class TestMakeTwoArguments extends Test, Case {
  override predicate run(Qnit test) {
    if
      exists(Tagged<Tag>::String str | str.make("tagA", "string value") |
        str.getTag() = "tagA" and str.getStr() = "string value"
      )
    then test.pass("make(tag, str) works correctly")
    else test.fail("make(tag, str) didn't work correctly")
  }
}

class TestMakeOneArgument extends Test, Case {
  override predicate run(Qnit test) {
    if
      exists(Tagged<Tag>::String str | str.make("string value").isTagged("tagA") |
        str.getTag() = "tagA" and str.getStr() = "string value"
      )
    then test.pass("make(str).isTagged(tag) works correctly")
    else test.fail("make(str).isTagged(tag) didn't work correctly")
  }
}
