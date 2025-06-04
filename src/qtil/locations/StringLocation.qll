private import qtil.tuple.StringTuple
private import qtil.inheritance.Instance
private import qtil.list.ListBuilder
private import qtil.strings.Chars
private import StringTuple<Chars::colon/0> as StrTup
private import codeql.util.Location

/**
 * An infinite class that can represent any location, backed by a string.
 *
 * To "construct" a string location, use the `stringLocation()` predicate.
 *
 * This class is useful anywhere that strings or infinite types are useful, and for reporting
 * locations that don't exist in a database. For instance, it can be useful to store these locations
 * in an infinite StringTuple. For more, see `LocationToString`.
 *
 * *Caution*: Infinite types are not always the best choice for performance. Before using this
 * class, consider if you can reasonably use the standard finite type Location type instead. When
 * your use has reached a finite set of locations, you can use the `FinitizeStringLocation` module
 * to reduce the performance overhead of using infinite types.
 */
bindingset[this]
class StringLocation extends InfInstance<StrTup::Tuple>::Type {
  bindingset[this]
  int getStartLine() { result = inst().get(1).toInt() }

  bindingset[this]
  int getStartColumn() { result = inst().get(2).toInt() }

  bindingset[this]
  int getEndLine() { result = inst().get(3).toInt() }

  bindingset[this]
  int getEndColumn() { result = inst().get(4).toInt() }

  bindingset[this]
  string getFilePath() { result = inst().get(0) }

  bindingset[this]
  predicate hasLocationInfo(
    string filePath, int startLine, int startColumn, int endLine, int endColumn
  ) {
    filePath = getFilePath() and
    startLine = getStartLine() and
    startColumn = getStartColumn() and
    endLine = getEndLine() and
    endColumn = getEndColumn()
  }
}

/**
 * "Construct" a string location from a file path and line/column numbers.
 *
 * See `StringLocation` for more details.
 */
bindingset[filePath, startLine, startColumn, endLine, endColumn]
StringLocation stringLocation(
  string filePath, int startLine, int startColumn, int endLine, int endColumn
) {
  result =
    StrTup::of5(filePath, startLine.toString(), startColumn.toString(), endLine.toString(),
      endColumn.toString())
}

/**
 * A module that provides a way to convert a location to a `StringLocation`.
 *
 * This module is parameterized because each language has its own way of representing locations.
 *
 * Typically, this module should be imported via `qtil.lang` for the query you are writing, e.g.,
 * `qtil.cpp` or `qtil.java`, rather than instantiating it with a location signature yourself.
 *
 * ```ql
 * import qtil.cpp
 *
 * // Selects function names and locations via a string tuple.
 * from StringTuple tuple, Function f
 * where tuple = StringTuple::of2(f.getName(), stringLocation(f.getLocation()))
 * select tuple.getFirst(), tuple.getSecond()
 * ```
 */
module LocationToString<LocationSig Location> {
  /**
   * Construct a `StringLocation` from the given location object.
   *
   * See `StringLocation` for more details.
   */
  bindingset[elem]
  pragma[inline_late]
  StringLocation stringLocation(Location elem) {
    exists(string filePath, int startLine, int startColumn, int endLine, int endColumn |
      elem.hasLocationInfo(filePath, startLine, startColumn, endLine, endColumn) and
      result = stringLocation(filePath, startLine, startColumn, endLine, endColumn)
    )
  }
}

/**
 * A module that provides a way to concretize a string location, typically for performance
 * reasons.
 *
 * The `hasLocationInfo` predicate may perform redundant string splitting operations due to it being
 * an infinite type. Assuming the query has reached a finite set of string locations, this module
 * allows you to create a set of finite and immutable concrete string locations, which can be
 * used to improve performance.
 *
 * Example:
 *
 * ```ql
 * StringLocation getLocations() {
 *   // Predicate where string locations are highly convenient.
 * }
 *
 * // Selects "file.cpp:1:2:3:4" and efficiently extracts the hasLocationInfo predicate.
 * from FinitizeStringLocation<getLocations()>::Location loc
 * select loc.toString(), loc
 * ```
 */
module FinitizeStringLocation<Unary<StringLocation>::pred/1 locations> {
  private import qtil.inheritance.Finitize
  private import qtil.parameterization.Finalize

  /**
   * The finite class.
   *
   * Note that we have to override getFilePath(), getStartLine(), etc. to ensure that the
   * `bindingset[this]` is removed, so that the class can be used as a location.
   */
  class Location extends Final<Finitize<StringLocation, locations/1>::Type>::Type {
    string getFilePath() { result = super.getFilePath() }

    int getStartLine() { result = super.getStartLine() }

    int getStartColumn() { result = super.getStartColumn() }

    int getEndLine() { result = super.getEndLine() }

    int getEndColumn() { result = super.getEndColumn() }

    predicate hasLocationInfo(
      string filePath, int startLine, int startColumn, int endLine, int endColumn
    ) {
      filePath = getFilePath() and
      startLine = getStartLine() and
      startColumn = getStartColumn() and
      endLine = getEndLine() and
      endColumn = getEndColumn()
    }
  }
}
