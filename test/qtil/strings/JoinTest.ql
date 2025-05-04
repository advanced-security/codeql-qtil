import qtil.strings.Join
import qtil.testing.Qnit

class JoinTest extends Test, Case {
  override predicate run(Qnit test) {
    if
      join(" ", "a", "b") = "a b" and
      join(",", "a", "b") = "a,b" and
      join(" ", "a", "b", "c") = "a b c" and
      join(",", "a", "b", "c") = "a,b,c" and
      join(" ", "a", "b", "c", "d") = "a b c d" and
      join(",", "a", "b", "c", "d") = "a,b,c,d" and
      join(" ", "a", "b", "c", "d", "e") = "a b c d e" and
      join(",", "a", "b", "c", "d", "e") = "a,b,c,d,e" and
      join(" ", "a", "b", "c", "d", "e", "f") = "a b c d e f" and
      join(",", "a", "b", "c", "d", "e", "f") = "a,b,c,d,e,f" and
      join(" ", "a", "b", "c", "d", "e", "f", "g") = "a b c d e f g" and
      join(",", "a", "b", "c", "d", "e", "f", "g") = "a,b,c,d,e,f,g" and
      join(" ", "a", "b", "c", "d", "e", "f", "g", "h") = "a b c d e f g h" and
      join(",", "a", "b", "c", "d", "e", "f", "g", "h") = "a,b,c,d,e,f,g,h"
    then test.pass("Basic joins work")
    else test.fail("Basic joins not working")
  }
}
