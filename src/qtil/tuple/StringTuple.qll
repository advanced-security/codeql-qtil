private import qtil.parameterization.Finalize
private import qtil.parameterization.SignaturePredicates
private import qtil.inheritance.UnderlyingString

/**
 * A tuple that contains only string values, such as a csv row.
 *
 * This module can be useful to create infinite types with some basic structure.
 */
module StringTuple<Nullary::Ret<string>::pred/0 separator> {
  bindingset[this]
  class Tuple extends Final<UnderlyingString>::Type {
    bindingset[this, idx]
    string get(int idx) { result = str().splitAt(separator(), idx) }

    bindingset[this, item]
    Tuple append(string item) { result = str() + separator() + item }

    bindingset[this]
    int size() { result = count(int idx | idx = str().indexOf(separator(), idx, 0)) }
  }

  bindingset[v1]
  Tuple of1(string v1) { result = v1 }

  bindingset[v1, v2]
  Tuple of2(string v1, string v2) { result = v1 + separator() + v2 }

  bindingset[v1, v2, v3]
  Tuple of3(string v1, string v2, string v3) { result = v1 + separator() + v2 + separator() + v3 }

  bindingset[v1, v2, v3, v4]
  Tuple of4(string v1, string v2, string v3, string v4) {
    result = v1 + separator() + v2 + separator() + v3 + separator() + v4
  }

  bindingset[v1, v2, v3, v4, v5]
  Tuple of5(string v1, string v2, string v3, string v4, string v5) {
    result = v1 + separator() + v2 + separator() + v3 + separator() + v4 + separator() + v5
  }

  bindingset[v1, v2, v3, v4, v5, v6]
  Tuple of6(string v1, string v2, string v3, string v4, string v5, string v6) {
    result =
      v1 + separator() + v2 + separator() + v3 + separator() + v4 + separator() + v5 + separator() +
        v6
  }

  bindingset[v1, v2, v3, v4, v5, v6, v7]
  Tuple of7(string v1, string v2, string v3, string v4, string v5, string v6, string v7) {
    result =
      v1 + separator() + v2 + separator() + v3 + separator() + v4 + separator() + v5 + separator() +
        v6 + separator() + v7
  }

  bindingset[v1, v2, v3, v4, v5, v6, v7, v8]
  Tuple of8(string v1, string v2, string v3, string v4, string v5, string v6, string v7, string v8) {
    result =
      v1 + separator() + v2 + separator() + v3 + separator() + v4 + separator() + v5 + separator() +
        v6 + separator() + v7 + separator() + v8
  }
}

module Separator {
  string comma() { result = "," }

  string dollar() { result = "$" }

  string colon() { result = ":" }

  string at() { result = "@" }

  string hash() { result = "#" }

  string excl() { result = "!" }

  string caret() { result = "^" }

  string amp() { result = "&" }

  string pipe() { result = "|" }

  string semicolon() { result = ";" }

  string plus() { result = "+" }

  string minus() { result = "-" }

  string slash() { result = "/" }

  string backslash() { result = "\\" }

  string dot() { result = "." }

  string question() { result = "?" }

  string percent() { result = "%" }

  string tilde() { result = "~" }

  string space() { result = " " }

  string tab() { result = "\t" }

  string newline() { result = "\n" }

  string backtick() { result = "`" }
}
