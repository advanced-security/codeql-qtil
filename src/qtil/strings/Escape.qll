private import qtil.parameterization.SignaturePredicates
private import qtil.tuple.StringTuple
private import qtil.inheritance.Instance
private import qtil.strings.Char
private import qtil.list.ListBuilder
private import qtil.strings.Other

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

pragma[inline]
predicate emptyEscapeMap(Char real, Char escaped) { none() }

/**
 * A predicate to define an escape map that allows for any string to be escaped in such a way that
 * it can be used in a regex, and matches itself (e.g., special characters match themselves rather
 * than changing the meaning of the regex).
 *
 * Used by the predicate `escapeRegex`.
 *
 * *Caution*: This does not handle regex UN-escaping. For example, it does not handle unescaping
 * `\uXXXX` or `\xXX` sequences. In terms of unescaping, this can only unescape a raw string back to
 * itself after it has been escaped by this same escape map.
 */
predicate regexEscapeMap(Char real, Char escaped) {
  // Regex characters do not escape to different characters, but rather to themselves. For example,
  // the newline character escapes to an escaped `n` in most contexts, but a dollar sign is escaped
  // to an escaped dollar sign. An escaped `n` escapes to a newline in most contexts, but an
  // escaped dollar sign in a regex escapes to a plain dollar sign.
  real.isStr(["(", ")", "|", "\\", ".", "+", "*", "?", "^", "$", "]", "[", "{", "}"]) and
  escaped = real
  or
  real.isStr("\n") and escaped.isStr("n")
  or
  real.isStr("\r") and escaped.isStr("r")
  or
  real.isStr("\t") and escaped.isStr("t")
  or
  // Bell
  real = 7 and escaped.isStr("a")
  or
  // Formfeed
  real = 12 and escaped.isStr("f")
  or
  // Escape
  real = 27 and escaped.isStr("e")
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
   *
   * Note: adding pragma[inline_late] is very important for compilation speed. Otherwise, we hit
   * pathological cases of possible binding sets after inlining every involved predicate, which must
   * occur due to the bindingset. The performance effects of `inline_late` on callers has not yet
   * been evaluated.
   */
  bindingset[input, escaper]
  pragma[inline_late]
  string escape(string input, Char escaper) {
    result =
      concat(int cpIn, int cpIdx, string strOut |
        cpIn = input.codePointAt(cpIdx) and
        replacesOnEscape(cpIn, escaper, strOut)
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
   *
   * Note: adding pragma[inline_late] is very important for compilation speed. Otherwise, we hit
   * pathological cases of possible binding sets after inlining every involved predicate, which must
   * occur due to the bindingset. The performance effects of `inline_late` on callers has not yet
   * been evaluated.
   */
  bindingset[input, escaper]
  pragma[inline_late]
  string unescape(string input, Char escaper) {
    result =
      concat(int groupIdx, string groupText, string strOut |
        // We must use a regex as a state machine. The state is either "escaped - grap the next
        // character literally" or "not escaped - grap the current character if it is not the
        // escape character. Specify "(?s)" to enable DOTALL mode, so that "." matches newlines,
        // for the rare scenario where the escape character is a newline.
        groupText =
          input
              .regexpFind("(?s)(" + escapeRegexChar(escaper) + ".|[^" + escapeRegexChar(escaper) +
                  "])", groupIdx, _) and
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
    group = escaper.twice() and
    output = escaper.toString()
    or
    exists(Char out, Char inp |
      escapeMap(out, inp) and
      group = escaper.toString() + inp.toString() and
      output = out.toString()
    )
    or
    not pragma[only_bind_out](group.codePointAt(0)) = escaper and
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
  bindingset[input, escaper]
  pragma[inline_late]
  private predicate replacesOnEscape(Char input, Char escaper, string output) {
    exists(Char codeOut |
      escapeMap(input, codeOut) and
      output = escaper.toString() + codeOut.toString()
    )
    or
    input = escaper and
    output = escaper.twice()
    or
    not escapeMap(input, _) and
    not input = escaper and
    output = input.toString()
  }
}

/**
 * We can't use `Escape<escapeRegexMap/2>::escape` here, as a parameterized module cannot
 * instantiate itself.
 *
 * This is used to create regexes that find the escape character in a string. Without using regex,
 * we would need to make a recursive predicate with a bindingset (on the string input), which
 * isn't allowed, to properly find the escape characters and handle escaped escape characters.
 *
 * Bootstrap regex escaping here more simply, make sure special characters like `$` and `(` are
 * escaped to `\$` and `\(`, and make sure alphabetic characters are not (or `w` will be escaped
 * to `\w` which matches any word character), and special characters like newlines are escaped to
 * `\n`.
 */
bindingset[char]
pragma[inline]
private string escapeRegexChar(Char char) {
  if regexEscapeMap(char, _)
  then
    exists(Char escaped |
      regexEscapeMap(char, escaped) and
      result = "\\" + escaped.toString()
    )
  else result = char.toString()
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
  pragma[inline]
  predicate newEscapeMap(Char real, Char escaped) {
    // Escape wrapping with a character like a double quote requires escaping inner double quotes.
    // However, escape wrapping with tabs, when tabs are already escaped to to /t, does not require
    // additional entries in the escape map.
    not escapeMap(wrapChar(), _) and
    real = wrapChar() and
    escaped = wrapChar()
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

/**
 *  A module for making CSV-like separated strings, with a custom separator and escape character.
 *
 * When the separator or escape character is found in a string to be concatenated, it is escaped
 * with the escape character. For example, if the separator is `,` and the escape character is `\`,
 * then adding joining `foo,bar` with `baz\\qux` will yield `foo\\,bar,baz\\\\qux`.
 *
 * Example usage:
 * ```ql
 * import SeparatedEscape<Separator::comma/0, defaultEscapeMap> as CSV
 *
 * // Selects "foo\\,bar,baz\\\\qux"
 * select CSV::EscapeBackslash::join("foo,bar", "baz\\qux")
 *
 * // Selects [0, "foo,bar"] and [1, "baz\\qux"]
 * from int i, string s
 * where s = CSV::EscapeBackslash::split("foo\\bar,baz\\\\qux", i)
 * select i, s
 *
 * string getItem(int i) { ... }
 * select CSV::concatIndexed<getItem/1>::join()
 */
module SeparatedEscape<Nullary::Ret<Char>::pred/0 separator, Binary<Char, Char>::pred/2 escapeMap> {
  /**
   * Add the separator character to the escape map, so that it is escaped to itself.
   *
   * This is necessary for the `join` function to work correctly, as it needs to escape the
   * separator character in the string.
   */
  pragma[inline]
  private predicate newEscapeMap(Char real, Char escaped) {
    // Escape separator with a character like a comma requires escaping inner commas. However,
    // escape wrapping with tabs, when tabs are already escaped to to /t, does not require
    // additional entries in the escape map.
    not escapeMap(separator(), _) and
    real = separator() and
    escaped = separator()
    or
    escapeMap(real, escaped)
  }

  /**
   * A module containing a set of functions `of2`, `of3`, etc., that construct a separated list
   * using the specified separator and backslash as the escape character, escaping entries as
   * necessary.
   */
  module EscapeBackslash {
    // Import the predicates `of2`, `of3`, etc. from the `ListBuilder` module, and use the
    // `escapeItem` predicate to escape the items in the list.
    import ListBuilderOf<separator/0, string, escapeItem/1>
  }

  /**
   * A module containing a set of functions `of2`, `of3`, etc., that construct a separated list
   * using the specified separator and a custom escape character, escaping entries as necessary.
   */
  module EscapedWith<Nullary::Ret<Char>::pred/0 escaper> {
    // Private predicate that escapes the separator character in the string, using the specified
    // escape character given by `escaper()`.
    bindingset[str]
    private string newEscapeItem(string str) {
      result = Escape<newEscapeMap/2>::escape(str, escaper())
    }

    // Import the predicates `of2`, `of3`, etc. from the `ListBuilder` module, and use the
    // `newEscpeItem` predicate to escape the items in the list.
    import ListBuilderOf<separator/0, string, newEscapeItem/1>
  }

  /**
   * Escape a string using the escape map, using backslash as the escape character.
   *
   * Typically performed internally on each item before building the list, but public in case it is
   * needed for other purposes.
   */
  bindingset[str]
  string escapeItem(string str) { result = Escape<newEscapeMap/2>::escape(str, charOf("\\")) }

  /**
   * Escape a string using the escape map, using a custom escape character.
   *
   * Typically performed internally on each item before building the list, but public in case it is
   * needed for other purposes.
   */
  bindingset[str, escaper]
  string escapeItem(string str, Char escaper) {
    result = Escape<newEscapeMap/2>::escape(str, escaper)
  }

  /**
   * Unescape a string using the escape map, using backslash as the escape character.
   *
   * Typically performed internally on each item after splitting the list to get the semantic
   * meaning of each item, but public in case it is needed for other purposes.
   */
  bindingset[str, escaper]
  string unescapeItem(string str, Char escaper) {
    result = Escape<newEscapeMap/2>::unescape(str, escaper)
  }

  /**
   * Unescape a string using the escape map, using backslash as the escape character.
   *
   * Typically performed internally on each item after splitting the list to get the semantic
   * meaning of each item, but public in case it is needed for other purposes.
   */
  bindingset[str]
  string unescapeItem(string str) { result = Escape<newEscapeMap/2>::unescape(str, charOf("\\")) }

  /**
   * A module that can concatenate all of the results of a predicate, unordered, using the specified
   * separator and escaping each item as necessary.
   *
   * For an unordered version of this module, for cases such as maintaining a set of strings, where
   * the order does not matter, use the module `ConcatUnordered`.
   *
   * Usage:
   * ```ql
   * import SeparatedEscape<Separator::comma/0, defaultEscapeMap> as CSV
   *
   * string name(int idx) { idx = 1 and result = "foo" or idx = 2 and result = "bar" }
   *
   * // Selects "foo,bar"
   * select CSV::Concat<names/0>::join()
   * ```
   */
  module Concat<Unary<int>::Ret<string>::pred/1 items> {
    /**
     * Join all items returned by the specified predicate, escaping each item using backslash as the
     * escape character.
     */
    string join() {
      //result = joinEscapedBy(charOf("//")) }
      result = ConcatDelimOrderFixed<separator/0, escapePredicateItem/1>::join()
    }

    private string escapePredicateItem(int x) { result = escapeItem(items(x)) }
    ///**
    // * Join all items returned by the specified predicate, escaping each item using the specified
    // * escape character.
    // */
    //bindingset[escaper]
    //string joinEscapedBy(Char escaper) {
    //  result = ConcatDelimOrderFixed<separator/0, escapePredicateItem/1>::join()
    //  //result =
    //  //  concat(string str, int index |
    //  //    str = items(index)
    //  //  |
    //  //    escapeItem(str, escaper) order by index, escaper.toString()
    //  //  )
    //}
  }

  /**
   * Split and unescape the nth item in the string, starting at zero, separated by the separator
   * character, escaped by a custom escape character.
   *
   * For instance, `split("foo\\,bar,baz\\\\qux", 0, charOf("\\"))` will yield `foo,bar`, while
   * index 1 will yield `baz\\qux`.
   *
   * Note: adding pragma[inline_late] is very important for compilation speed. Otherwise, we hit
   * pathological cases of possible binding sets after inlining every involved predicate, which must
   * occur due to the bindingset. The performance effects of `inline_late` on callers has not yet
   * been evaluated.
   */
  bindingset[str, escaper]
  pragma[inline_late]
  string split(string str, int index, Char escaper) {
    exists(string group, string escaperRegex, string separatorRegex |
      // We must use a regex as a state machine. The state is either "escaped - grab the next
      // character literally" or "not escaped", where a separator indicates a split and any other
      // character is taken as text in the current group.
      //
      // Some additional regex magic is required:
      // - The `(?s)` at the start of the regex enables DOTALL mode, so that "." matches newlines
      //       in the rare case that the escape character is a newline.
      // - The `(?<=...)` is positive lookbehind that ensures the current match is preceded by a
      //       separator or the start of the string. Without this, the end of the string matches
      //       the regex (since it uses '*'), which is not what we want.
      // - (\\.|[^\\,]) is the basic regex pattern for reading escaped vs unescaped characters.
      //       The `\\.` matches an escaped character, and the `[^\\,]` matches any other
      //       character. The `*` at the end of the regex means that we can match any number of
      //       characters, including zero. This pattern won't match a separator, and then the java
      //       Pattern.find() method will skip over it to find the next match.
      escaperRegex = escapeRegexChar(escaper) and
      separatorRegex = escapeRegexChar(separator()) and
      group =
        str.regexpFind("(?s)(?<=" + separatorRegex + "|^)(" + escaperRegex + ".|[^" + escaperRegex +
            separatorRegex + "])*", index, _) and
      result = unescapeItem(group, escaper)
    )
  }

  /**
   * Split and unescape the nth item in the string, starting at zero, separated by the separator
   * character.
   *
   * Uses backslash as the escape character.
   *
   * For instance, `split("foo\\,bar,baz\\\\qux", 0)` will yield `foo,bar`, while index 1 will yield
   * `baz\\qux`.
   */
  bindingset[str]
  string split(string str, int index) { result = split(str, index, charOf("\\")) }

  /**
   * Split a string into its unescaped component parts, by the separator character, using a custom
   * escape character.
   *
   * For instance, `splitWithEscaper("foo\\,bar,baz\\\\qux", "\\")` will yield
   * `["foo,bar", "baz\\qux"]`.
   */
  bindingset[str, escaper]
  string splitWithEscaper(string str, Char escaper) { result = split(str, _, escaper) }

  /**
   * Split a string into its unescaped component parts, by the separator character, using backslash
   * as the escape character.
   *
   * For instance, `split("foo\\,bar,baz\\\\qux")` will yield `["foo,bar", "baz\\qux"]`.
   */
  bindingset[str]
  string split(string str) { result = splitWithEscaper(str, charOf("\\")) }
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
 *
 * To unescape the result of this function back to itself, use the module
 * `Escape<regexEscapeMap/2>`. An `unescapeRegex` function is not provided, as the name may be
 * misleading.
 */
bindingset[str]
string escapeRegex(string str) { result = Escape<regexEscapeMap/2>::escape(str, charOf("\\")) }
