import qtil.locations.OptionalLocation
import qtil.testing.Qnit
import codeql.util.Unit

class MyLocation extends string {
  MyLocation() { this in ["file.cpp", "file2.cpp"] }

  string getFilePath() { hasLocationInfo(result, _, _, _, _) }

  int getStartLine() { hasLocationInfo(_, result, _, _, _) }

  int getStartColumn() { hasLocationInfo(_, _, result, _, _) }

  int getEndLine() { hasLocationInfo(_, _, _, result, _) }

  int getEndColumn() { hasLocationInfo(_, _, _, _, result) }

  predicate hasLocationInfo(
    string filePath, int startLine, int startColumn, int endLine, int endColumn
  ) {
    this = filePath and
    (
      filePath = "file.cpp" and
      startLine = 1 and
      startColumn = 2 and
      endLine = 3 and
      endColumn = 4
      or
      filePath = "file2.cpp" and
      startLine = 5 and
      startColumn = 6 and
      endLine = 7 and
      endColumn = 8
    )
  }
}

int countLocations(OptionalLocation<MyLocation>::Location loc) {
  result = count(string f, int sl, int sc, int el, int ec | loc.hasLocationInfo(f, sl, sc, el, ec))
}

class TestOptionalLocationNone extends Test, Case {
  override predicate run(Qnit test) {
    if
      exists(OptionalLocation<MyLocation>::Location loc |
        loc.isNone() and
        countLocations(loc) = 0
      )
    then test.pass("OptionalLocation has no location info")
    else test.fail("OptionalLocation should not have location info")
  }
}

class TestOptionalLocationSome extends Test, Case {
  override predicate run(Qnit test) {
    if
      exists(OptionalLocation<MyLocation>::Location loc |
        loc.asSome().getFilePath() = "file.cpp" and
        loc.hasLocationInfo("file.cpp", 1, 2, 3, 4) and
        countLocations(loc) = 1
      ) and
      exists(OptionalLocation<MyLocation>::Location loc |
        loc.asSome().getFilePath() = "file2.cpp" and
        loc.hasLocationInfo("file2.cpp", 5, 6, 7, 8) and
        countLocations(loc) = 1
      )
    then test.pass("OptionalLocation has correct location info")
    else test.fail("OptionalLocation has incorrect location info")
  }
}
