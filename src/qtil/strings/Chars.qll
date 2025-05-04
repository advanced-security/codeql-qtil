import qtil.strings.Char

/**
 * A module that declares predicates for defining common separators to the various `ListBuilder`
 * modules defined in this file.
 */
module Chars {
  Char comma() { result.isStr(",") }

  Char dollar() { result.isStr("$") }

  Char colon() { result.isStr(":") }

  Char at() { result.isStr("@") }

  Char hash() { result.isStr("#") }

  Char excl() { result.isStr("!") }

  Char caret() { result.isStr("^") }

  Char amp() { result.isStr("&") }

  Char pipe() { result.isStr("|") }

  Char semicolon() { result.isStr(";") }

  Char plus() { result.isStr("+") }

  Char minus() { result.isStr("-") }

  Char slash() { result.isStr("/") }

  Char backslash() { result.isStr("\\") }

  Char dot() { result.isStr(".") }

  Char question() { result.isStr("?") }

  Char percent() { result.isStr("%") }

  Char tilde() { result.isStr("~") }

  Char space() { result.isStr(" ") }

  Char tab() { result.isStr("\t") }

  Char newline() { result.isStr("\n") }

  Char backtick() { result.isStr("`") }
}