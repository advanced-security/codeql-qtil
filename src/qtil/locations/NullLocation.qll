private import codeql.util.Unit
private import codeql.util.Option
private import codeql.util.Location
private import qtil.parameterization.Finalize

/**
 * A class that represents a location that does not exist.
 *
 * Satisfies the `LocationSig` interface, but does not have any location information. The CodeQL
 * engine will use an empty filename and line/column numbers of 0 when this class is selected as a
 * query result location.
 */
class NullLocation extends Unit {
  predicate hasLocationInfo(
    string filePath, int startLine, int startColumn, int endLine, int endColumn
  ) {
    none()
  }
}
