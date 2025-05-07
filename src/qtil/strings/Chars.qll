import qtil.strings.Char

/**
 * A module that declares predicates for defining common separators to the various `ListBuilder`
 * modules defined in this file.
 */
module Chars {
  pragma[inline]
  Char comma() { result.isStr(",") }

  pragma[inline]
  Char dollar() { result.isStr("$") }

  pragma[inline]
  Char colon() { result.isStr(":") }

  pragma[inline]
  Char at() { result.isStr("@") }

  pragma[inline]
  Char hash() { result.isStr("#") }

  pragma[inline]
  Char excl() { result.isStr("!") }

  pragma[inline]
  Char caret() { result.isStr("^") }

  pragma[inline]
  Char amp() { result.isStr("&") }

  pragma[inline]
  Char pipe() { result.isStr("|") }

  pragma[inline]
  Char semicolon() { result.isStr(";") }

  pragma[inline]
  Char plus() { result.isStr("+") }

  pragma[inline]
  Char minus() { result.isStr("-") }

  pragma[inline]
  Char slash() { result.isStr("/") }

  pragma[inline]
  Char backslash() { result.isStr("\\") }

  pragma[inline]
  Char dot() { result.isStr(".") }

  pragma[inline]
  Char question() { result.isStr("?") }

  pragma[inline]
  Char percent() { result.isStr("%") }

  pragma[inline]
  Char tilde() { result.isStr("~") }

  pragma[inline]
  Char space() { result.isStr(" ") }

  pragma[inline]
  Char tab() { result.isStr("\t") }

  pragma[inline]
  Char newline() { result.isStr("\n") }

  pragma[inline]
  Char backtick() { result.isStr("`") }
}
