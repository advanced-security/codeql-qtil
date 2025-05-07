private import qtil.tuple.StringTuple
private import qtil.inheritance.Instance
private import qtil.list.ListBuilder
private import qtil.strings.Chars
private import StringTuple<Chars::colon/0> as StrTup
private import codeql.util.Location

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

bindingset[filePath, startLine, startColumn, endLine, endColumn]
StringLocation stringLocation(
  string filePath, int startLine, int startColumn, int endLine, int endColumn
) {
  result =
    StrTup::of5(filePath, startLine.toString(), startColumn.toString(), endLine.toString(),
      endColumn.toString())
}

module LocationToString<LocationSig Location> {
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
 * from ConcretizeStringLocation<getLocations()>::Location loc
 * select loc.toString(), loc
 * ```
 */
module ConcretizeStringLocation<Nullary::Ret<string>::pred/0 locations> {
  class Location extends Instance<StringTuple<Chars::colon/0>::Concretize<locations/0>::Tuple5>::Type
  {
    string getFilePath() { result = inst().getFirst() }

    int getStartLine() { result = inst().getSecond().toInt() }

    int getStartColumn() { result = inst().getThird().toInt() }

    int getEndLine() { result = inst().getFourth().toInt() }

    int getEndColumn() { result = inst().getFifth().toInt() }

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
