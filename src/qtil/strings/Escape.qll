/**
 * Add escape sequence (e.g., backslash) to a string before a relevant character (e.g., double
 * quote).
 *
 * For instance, `"foo%bar".escape("%", "$") = "foo$%bar"`, and
 * `"foo%bar$baz".escape("%", "$") = "foo$%bar$$baz"`.
 */
bindingset[escapee, escaper, str]
string escape(string str, string escapee, string escaper) {
  result = str.replaceAll(escaper, escaper + escaper).replaceAll(escapee, escaper + escapee)
}

/**
 * Add escape sequence (e.g., backslash) to a string before a relevant character (e.g., double
 * quote).
 *
 * For instance, `"foo%bar".escape("%") = "foo\\%bar"`, and
 * `"foo%bar\\baz".escape(",") = "foo\\%bar\\\\baz"`.
 */
bindingset[escapee, str]
string escape(string str, string escapee) { result = escape(str, escapee, "\\") }

/**
 * Wrap a string with a delimiter (e.g., double quote), adding a specifiable escape character if
 * necessary.
 *
 * For instance, `wrapEscaping("foo", "%", "$") = "%foo%"`, and
 * `wrapEscaping("foo%bar", "%", "$") = "%foo$%bar%"`.
 */
bindingset[delimiter, escape, str]
string wrapEscaping(string str, string delimiter, string escape) {
  result = delimiter + escape(str, delimiter, escape) + delimiter
}

/**
 * Wrap a string with a delimiter (e.g., double quote), adding a backslash escape character if
 * necessary.
 *
 * For instance, `wrapEscaping("foo", "%") = "%foo%"`, and
 * `wrapEscaping("foo%bar", "%") = "%foo\\%bar%"`.
 */
bindingset[delimiter, str]
string wrapEscaping(string str, string delimiter) { result = wrapEscaping(str, delimiter, "\\") }

/**
 * Wrap a string with double quotes, adding a backslash escape character if necessary.
 *
 * For instance, `doubleQuoteEscaping("foo") = "\"foo\""`, and
 * `doubleQuoteEscaping("foo\"bar") = "\"foo\\\"bar\""`.
 */
bindingset[str]
string doubleQuoteEscaping(string str) { result = wrapEscaping(str, "\"") }

/**
 * Wrap a string with single quotes, adding a backslash escape character if necessary.
 *
 * For instance, `singleQuoteEscaping("foo") = "'foo'"`, and
 * `singleQuoteEscaping("foo'bar") = "'foo\\'bar"`.
 */
bindingset[str]
string singleQuoteEscaping(string str) { result = wrapEscaping(str, "'") }

/**
 * Add escapes to a string literal to make it safe for use in a Java-style PRCE regex, as a direct
 * character by character match.
 *
 * For instance, `regexEscape("foo") = "foo"`, and
 * `regexEscape("^foo(bar)baz[qux]$") = "\\^foo\\(bar\\)baz\\[qux\\]\\$"`.
 */
bindingset[str]
string escapeRegex(string str) {
  result = str.regexpReplaceAll("[{}()\\[\\].+*?^$\\\\|]", "\\\\$0")
}

/**
 * Unescape a string by removing the specified escape character (e.g., backslash).
 *
 * For instance, `unescape("foo%bar", "%") = "foobar"`, and
 * `unescape("foo%bar%%baz", "%") = "foobar%baz"`.
 */
bindingset[escaper, str]
string unescape(string str, string escaper) {
  // Replace "${escaper}${char}" with "${char}". We must escape the escape character
  // to avoid it being interpreted as a regex special character.
  result = str.regexpReplaceAll(escapeRegex(escaper) + "(.)", "$1")
}

/**
 * Unescape a string by removing the backslash escape character.
 *
 * For instance, `unescape("foo\\%bar") = "foo%bar"`, and
 * `unescape("foo\\%bar\\\\baz") = "foo%bar\\baz"`.
 */
bindingset[str]
string unescape(string str) { result = unescape(str, "\\") }

/**
 * Get the contents of a wrapped string value, which may contain escape sequences using the
 * specified, escape sequence, removing the wrapping characters and one level of escapes.
 *
 * For instance, `unwrap("%foo%", "%", "$") = "foo"`, and
 * `unwrap("%foo$%bar$$baz%", ) = "foo%bar$baz`.
 *
 * Does not hold for any result value in the case where the string is not wrapped with the specified
 * delimiter.
 */
bindingset[str, delimiter, escape]
string unwrap(string str, string delimiter, string escape) {
  exists(string unwrapped |
    unwrapped = str.substring(delimiter.length(), str.length() - delimiter.length()) and
    unwrapped = delimiter + unwrapped + delimiter and
    result = unescape(unwrapped, escape)
  )
}

/**
 * Get the contents of a double quoted string literal, removing the double quotes and any escape
 * characters.
 *
 * For instance, `undoubleQuote("\"foo\"") = "foo"`, and
 * `undoubleQuote("\"foo\\\"bar\"") = "foo\"bar"`.
 * 
 * Does not hold for any result value in the case where the string is not double quoted.
 */
bindingset[str]
string undoubleQuote(string str) {
    result = unwrap(str, "\"", "\\")
}

/**
 * Get the contents of a single quoted string literal, removing the single quotes and any escape
 * characters.
 *
 * For instance, `unsingleQuote("'foo'") = "foo"`, and
 * `unsingleQuote("'foo\\'bar'") = "foo'bar"`.
 */
bindingset[str]
string unsingleQuote(string str) { result = unescape(str.substring(1, str.length() - 1)) }
