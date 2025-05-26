import qtil.locations.NullLocation
import qtil.testing.Qnit

class TestNullLocation extends Test, Case {
  override predicate run(Qnit test) {
    if exists(NullLocation loc | loc.hasLocationInfo("file.cpp", 1, 2, 3, 4))
    then test.fail("NullLocation should not have location info")
    else test.pass("NullLocation has no location info")
  }
}
