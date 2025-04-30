import qtil.testing.Qnit
import qtil.stringlocation.StringLocation

class TestFromString extends Test, Case {
  override predicate run(Qnit test) {
    if stringLocation("file.cpp", 1, 2, 3, 4) = "file.cpp:1:2:3:4"
    then test.pass("Correct StringLocation from string")
    else test.fail("Incorrect StringLocation from string")
  }
}

class TestGetterMethodsFromString extends Test, Case {
  override predicate run(Qnit test) {
    if
      exists(StringLocation loc |
        loc = stringLocation("file.cpp", 1, 2, 3, 4) and
        loc.getFilePath() = "file.cpp" and
        loc.getStartLine() = 1 and
        loc.getStartColumn() = 2 and
        loc.getEndLine() = 3 and
        loc.getEndColumn() = 4
      )
    then test.pass("All getters correct")
    else test.fail("Some getters incorrect")
  }
}

class TestHasLocationInfoFromString extends Test, Case {
  override predicate run(Qnit test) {
    if
      exists(StringLocation loc |
        loc = stringLocation("file.cpp", 1, 2, 3, 4) and
        loc.hasLocationInfo("file.cpp", 1, 2, 3, 4)
      )
    then test.pass("Has correct location info")
    else test.fail("Does not have location info")
  }
}

class TestHasOnlyOneLocation extends Test, Case {
  override predicate run(Qnit test) {
    if
      count(string filePath, int startLine, int startColumn, int endLine, int endColumn |
        stringLocation("file", 1, 2, 3, 4)
            .hasLocationInfo(filePath, startLine, startColumn, endLine, endColumn)
      ) = 1
    then test.pass("Only one location")
    else test.fail("More than one location")
  }
}
