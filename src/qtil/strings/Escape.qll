private import qtil.parameterization.SignaturePredicates
private import qtil.tuple.StringTuple
private import qtil.inheritance.Instance
private import qtil.strings.Char

/**
 * An escape map that escapes newlines, carriage returns, and tabs, to `\n`, `\r`, and `\t`
 * respectively.
 *
 * See the `Escape` module for more details on how to use this escape map.
 */
predicate defaultEscapeMap(Char real, Char escaped) {
  real.isStr("\n") and escaped.isStr("n")
  or
  real.isStr("\r") and escaped.isStr("r")
  or
  real.isStr("\t") and escaped.isStr("t")
}

predicate emptyEscapeMap(Char real, Char escaped) { none() }

predicate regexEscapeMap(Char real, Char escaped) {
  // Regex characters do not escape to different characters, but rather to themselves. For example,
  // the newline character escapes to an escaped `n` in most contexts, but a dollar sign is escaped
  // to an escaped dollar sign. An escaped `n` escapes to a newline in most contexts, but an
  // escaped dollar sign in a regex escapes to a plain dollar sign.
  real.isStr(["(", ")", "|", "\\", ".", "+", "*", "?", "^", "$"]) and escaped = real
}

/**
 * A module for building predicates that escape and unescape strings, based on a map of characters
 * to escape and their escaped equivalents in the predicate `escapeMap`.
 *
 * The `escapeMap` predicate is a binary predicate that takes two strings, the first being the
 * character to escape and the second being the escaped equivalent. For example, if a newline should
 * be escaped to `\n`, and `\n` should be unescaped to a newline, then `escapeMap("\n", "n")` should
 * hold.
 *
 * The escape map is designed to work regardless of the escape character used. For example, if the
 * escape character is `$` instead of a backslash, then the previously mentioned escape map would
 * automatically escape `\n` into `$n` and unescape `$n` into `\n`.
 *
 * The predicate `escapeMap` does not need to declare that the escape character should itself be
 * escaped. This is handled by the `escape` and `unescape` predicates.
 *
 * ```ql
 * predicate myEscapeMap(Char real, Char escaped) {
 *  real.isStr("\n") and escaped.isStr("n")
 * }
 *
 * // Selects "foo\\nbar\\\\baz", "foo\nbar\\baz".
 * select Escape<myEscapeMap>::escape("foo\nbar\\baz", "\\"),
 *   Escape<myEscapeMap>::unescape("foo\\nbar\\\\baz", "\\")
 *
 * // Selects "foo$nbar$$baz", "foo\nbar$baz".
 * select Escape<myEscapeMap>::escape("foo\nbar$baz", "$"),
 *   Escape<myEscapeMap>::unescape("foo$nbar$$baz", "$")
 * ```
 *
 * The following predefined escape maps are available:
 * - `defaultEscapeMap`: The default escape map, which escapes newlines, carriage returns, and tabs.
 * - `regexEscapeMap`: The regex escape map, which escapes all regex special characters.
 * - `emptyEscapeMap`: An empty escape map, which does not escape any characters.
 */
module Escape<Binary<Char, Char>::pred/2 escapeMap> {
  /**
   * Perform the escape operation on a string, using the escape map, and a custom escape character.
   *
   * The escape character is also escaped in the string.
   *
   * See the module documentation (`Escape`) for more details.
   */
  bindingset[input, escaper]
  string escape(string input, Char escaper) {
    result =
      concat(int cpIn, int cpIdx, string strOut |
        cpIn = input.codePointAt(cpIdx) and
        if replacesOnEscape(input, escaper, cpIdx, _)
        then replacesOnEscape(input, escaper, cpIdx, strOut)
        else strOut = cpIn.toUnicode()
      |
        strOut order by cpIdx
      )
  }

  /**
   * Perform the escape operation on a string, using the escape map, using backslash as the escape
   * character.
   *
   * Backslash characters are also escaped in the string.
   *
   * See the module documentation (`Escape`) for more details.
   */
  bindingset[input]
  string escape(string input) { result = escape(input, charOf("\\")) }

  /**
   * Reverse the escape operation on a string, using the escape map, and a custom escape character.
   *
   * The escape character is also unescaped in the string when it is used to escape itself.
   *
   * See the module documentation (`Escape`) for more details.
   */
  bindingset[input, escaper]
  string unescape(string input, Char escaper) {
    result =
      concat(int groupIdx, string groupText, string strOut |
        groupText =
          input
              .regexpFind("(\\" + escaper.toString() + ".|[^\\" + escaper.toString() + "])",
                groupIdx, _) and
        unescapeReplaces(escaper, groupText, strOut)
      |
        strOut order by groupIdx
      )
  }

  /**
   * Reverse the escape operation on a string, using the escape map, using backslash as the escape
   * character.
   *
   * Double backslash characters are also unescaped in the string to a single backslash.
   *
   * See the module documentation (`Escape`) for more details.
   */
  bindingset[input]
  string unescape(string input) { result = unescape(input, charOf("\\")) }

  /**
   * Given the escape map, holds for an escaper, and a character or two character group, and the
   * replacement for that group.
   *
   * For example, if the escape map is `escapeMap("\n", "n")`, and the escaper is `\`, then
   * `unescapeReplaces("\\", "\\n", "\n")` holds, and `unescapeReplaces("\\", "a", "a") holds.
   *
   * This is because the unescape algorithm is just a state machine (implemented as a regex) that
   * grabs one character at a time, unless it sees the escaper, in which case it grabs two. Single
   * characters are not transformed. Escaped characters are transformed according to the escape
   * map: many characters are unescaped to themselves, but some are unescaped to other characters.
   * For example, a double backslash is typically unescaped to a single backslash, and an escaped
   * `n` is typically unescaped to a newline character.
   */
  bindingset[escaper, group]
  private predicate unescapeReplaces(Char escaper, string group, string output) {
    group = escaper.repeat(2) and
    output = escaper.toString()
    or
    exists(Char out, Char inp |
      escapeMap(out, inp) and
      group = escaper.toString() + inp.toString() and
      output = out.toString()
    )
    or
    not group.codePointAt(0) = escaper and
    output = group
  }

  /**
   * Given the escape map, holds for an escaper, a character index in the input string, and the
   * replacement for that character.
   *
   * For example, if the escape map is `escapeMap("\n", "n")`, and the escaper is `\`, then
   * `replacesOnEscape("foo\nbar", "\\", 3, "\\n")` holds, and
   * `replacesOnEscape("foo\\nbar", "\\", 0, "f")` holds.
   *
   * This performs a simple job. If we see an escape character, we escape it. If we see an escape
   * mapped character (a -> b), we place an escape before the new character "b". Anything else is
   * left alone.
   *
   * Note that many escape maps escape to themselves. For example, a double quote is typically
   * escaped by adding the escape character before it, and otherwise the double quote is not
   * changed. However, a newline character is typically not escaped to a backslash before a newline
   * character, but rather to a backslash followed by an `n` character.
   */
  bindingset[input, escaper, cpIdx]
  private predicate replacesOnEscape(string input, Char escaper, int cpIdx, string output) {
    exists(Char codeOut |
      escapeMap(input.codePointAt(cpIdx), codeOut) and
      output = escaper.toString() + codeOut.toString()
    )
    or
    input.codePointAt(cpIdx) = escaper and
    output = escaper.repeat(2)
  }
}

/**
 * A module for wrapping a string with a character, and escaping the wrapping character in the
 * string.
 *
 * For instance, this can wrap a string with double quotes, and escape the double quotes already in
 * the string.
 *
 * Takes an escape map predicate `escapeMap` that defines additional escaping behavior, such as
 * turning newlines into an escaped `n`.
 */
module WrapEscape<Nullary::Ret<Char>::pred/0 wrapChar, Binary<Char, Char>::pred/2 escapeMap> {
  /**
   * Add the wrapping character to the escape map, so that it is escaped to itself.
   */
  predicate newEscapeMap(Char real, Char escaped) {
    real = wrapChar() and escaped = wrapChar()
    or
    escapeMap(real, escaped)
  }

  /**
   * Escape a string using the escape map, and wrap the result with the wrapping character.
   *
   * The wrapping character, and the escape character, are also both escaped in the string.
   *
   * For example:
   *
   * ```ql
   * import WrapEscaping<Separator::percent/0, defaultEscapeMap>
   *
   * // Selects "%foo\\%bar\\\\baz" and "%foo\\%bar\\\\baz\\nqux".
   * select wrapEscaping("foo%bar\\baz", "\\"), wrapEscaping("foo%bar\\baz\nqux", "\\")
   *
   * // Selects "%foo.%bar..baz" and "%foo%bar..baz.nqux".
   * select wrapEscaping("foo%bar$baz", "."), wrapEscaping("foo%bar$baz\nqux", ".")
   * ```
   */
  bindingset[str, escape]
  string wrapEscaping(string str, Char escape) {
    result = wrapChar().wrap(Escape<newEscapeMap/2>::escape(str, escape))
  }

  bindingset[str]
  string wrapEscaping(string str) { result = wrapEscaping(str, charOf("\\")) }

  bindingset[str, escape]
  string unwrapUnescaping(string str, Char escape) {
    exists(string unwrapped |
      // Cut out the wrapping characters.
      unwrapped = str.substring(1, str.length() - 1) and
      // Ensure the character was actually wrapped with the wrapping character.
      str = wrapChar().wrap(unwrapped) and
      // Unescape the contents between the wrapping characters.
      result = Escape<newEscapeMap/2>::unescape(unwrapped, escape)
    )
  }

  bindingset[str]
  string unwrapUnescaping(string str) { result = unwrapUnescaping(str, charOf("\\")) }
}

/** Predicate to parameterize `WrapEscape` for double quoting strings. */
private Char doubleQuote() { result.isStr("\"") }

/** Predicate to parameterize `WrapEscape` for single quoting strings. */
private Char singleQuote() { result.isStr("'") }

/**
 * Wrap a string with double quotes, adding a backslash escape character if necessary.
 *
 * For instance, `doubleQuoteEscaping("foo") = "\"foo\""`, and
 * `doubleQuoteEscaping("foo\"bar") = "\"foo\\\"bar\""`.
 */
bindingset[str]
string doubleQuoteEscaping(string str) {
  result = WrapEscape<doubleQuote/0, defaultEscapeMap/2>::wrapEscaping(str, charOf("\\"))
}

/**
 * Unwrap a string with double quotes, removing the double quotes and any escape characters.
 *
 * For instance, `unescapeDoubleQuote("\"foo\"") = "foo"`, and
 * `unescapeDoubleQuote("\"foo\\\"bar\"") = "foo\"bar"`.
 *
 * Does not hold for any result value in the case where the string is not double quoted.
 */
bindingset[str]
string unescapeDoubleQuote(string str) {
  result = WrapEscape<doubleQuote/0, defaultEscapeMap/2>::unwrapUnescaping(str, charOf("\\"))
}

/**
 * Wrap a string with single quotes, adding a backslash escape character if necessary.
 *
 * For instance, `singleQuoteEscaping("foo") = "'foo'"`, and
 * `singleQuoteEscaping("foo'bar") = "'foo\\'bar"`.
 */
bindingset[str]
string singleQuoteEscaping(string str) {
  result = WrapEscape<singleQuote/0, defaultEscapeMap/2>::wrapEscaping(str, charOf("\\"))
}

/**
 * Unwrap a string with single quotes, removing the single quotes and any escape characters.
 *
 * For instance, `unescapeSingleQuote("'foo'") = "foo"`, and
 * `unescapeSingleQuote("'foo\\'bar'") = "foo'bar"`.
 *
 * Does not hold for any result value in the case where the string is not single quoted.
 */
bindingset[str]
string unescapeSingleQuote(string str) {
  result = WrapEscape<singleQuote/0, defaultEscapeMap/2>::unwrapUnescaping(str, charOf("\\"))
}

/**
 * Add escapes to a string literal to make it safe for use in a Java-style PRCE regex, as a direct
 * character by character match.
 *
 * For instance, `regexEscape("foo") = "foo"`, and
 * `regexEscape("^foo(bar)baz[qux]$") = "\\^foo\\(bar\\)baz\\[qux\\]\\$"`.
 */
bindingset[str]
string escapeRegex(string str) { result = Escape<regexEscapeMap/2>::escape(str, charOf("\\")) }

bindingset[str]
string unescapeRegex(string str) { result = Escape<regexEscapeMap/2>::unescape(str, charOf("\\")) }
