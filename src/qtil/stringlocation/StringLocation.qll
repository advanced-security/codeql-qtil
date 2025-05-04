private import qtil.tuple.StringTuple
private import qtil.inheritance.Instance
private import qtil.list.ListBuilder
private import StringTuple<Separator::colon/0> as StrTup
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
  StringLocation stringLocation(Location elem) {
    exists(string filePath, int startLine, int startColumn, int endLine, int endColumn |
      elem.hasLocationInfo(filePath, startLine, startColumn, endLine, endColumn) and
      result = stringLocation(filePath, startLine, startColumn, endLine, endColumn)
    )
  }
}
