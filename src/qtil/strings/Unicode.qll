private import codeql.util.Numbers

/**
 * Returns the Unicode version used by the current QL environment.
 */
extensible predicate unicodeVersion(string version);

/**
 * Provieds properties of a Unicode code point, where the property is of 'enumeration', 'catalog',
 * or 'string-valued' type.
 *
 * For example, `Block` is an enumeration property, `Line_Break` is a catalog property, and
 * `Uppercase_Mapping` is a string-valued property.
 *
 * For boolean properties, see `unicodeHasBooleanProperty`, and for numeric properties, see
 * `unicodeHasNumericProperty`.
 */
extensible predicate unicodeHasProperty(int codePoint, string propertyName, string propertyValue);

/**
 * Holds when the Unicode code point's boolean property of the given name is true.
 *
 * For example, `Alphabetic` is a boolean property that can be true or false for a code point.
 *
 * For other types of properties, see `unicodeHasProperty`.
 */
extensible predicate unicodeHasBooleanProperty(int codePoint, string propertyName);

/**
 * Provides the numeric value of a Unicode code point's numeric property.
 *
 * For example, `Numeric_Value` is a numeric property that can be an integer or a decimal value
 * for a code point.
 *
 * For other types of properties, see `unicodeHasProperty` and `unicodeHasBooleanProperty`.
 */
extensible predicate unicodeHasNumericProperty(
  int codePoint, string propertyName, float numericValue
);

/**
 * Holds when the given string contains a Unicode escape sequence (e.g. "\u0041").
 */
bindingset[input]
predicate containsUnicodeEscape(string input) { input.regexpMatch(".*\\\\u[0-9a-fA-F]{4}") }

/**
 * Holds when the given string contains only ASCII characters (code points 0-127).
 *
 * Note that if the string contains Unicode escape sequences, those are treated as multiple ASCII
 * characters, not as a single Unicode character. See `unescapeUnicode` and `containsUnicodeEscape`
 * for handling such Unicode escape sequences.
 */
bindingset[input]
predicate isAscii(string input) { input.regexpMatch("^[\\x{0000}-\\x{007F}]*$") }

/**
 * Takes a string containing Unicode escape sequences (e.g. "\u0041"), and returns the unescaped
 * string.
 */
bindingset[input]
string unescapeUnicode(string input) {
  // The process of splitting the input string and re-assembling it is not very efficient, so we
  // only do it if we know there are Unicode escapes to process.
  if containsUnicodeEscape(input)
  then
    result =
      concat(int code, int idx |
        code = unescapedCodePointAt(input, idx)
      |
        code.toUnicode() order by idx
      )
  else result = input
}

/**
 * Takes a string containing Unicode escape sequences (e.g. "\u0041"), and an offset into that
 * string, and returns the unescaped character at that offset.
 *
 * Not intended for general use; but rather as a helper for `unescapeUnicode`.
 *
 * Note that the offset is based on the output string, not the input string, as the regexp used in
 * this predicate splits the input into pieces that are either a single character or a Unicode
 * escape sequence.
 */
bindingset[input]
private int unescapedCodePointAt(string input, int index) {
  exists(string match |
    match = input.regexpFind("(\\\\u[0-9a-fA-F]{4}|.)", index, _) and
    if match.matches("\\u%")
    then result = parseHexInt(match.substring(2, match.length()))
    else result = match.codePointAt(0)
  )
}

/**
 * Holds when the given string is a not a valid UAX44 identifier.
 *
 * Essentially, a class of characters may begin or continue a valid identifier, while another class
 * of characters may only continue a valid identifier, and other characters may not appear at all.
 * See the unicode standard Annex #44 for full details.
 *
 * The second parameter `index` holds for the index of each invalid codepoint in the string.
 */
bindingset[id]
predicate nonUax44IdentifierCodepoint(string id, int index) {
  exists(int codePoint |
    codePoint = id.codePointAt(index) and
    (
      not unicodeHasBooleanProperty(codePoint, "XID_Start") and
      not unicodeHasBooleanProperty(codePoint, "XID_Continue")
      or
      index = 0 and
      not unicodeHasBooleanProperty(codePoint, "XID_Start")
    )
  )
}

/**
 * An enumeration of possible results for an NFC normalization check.
 *
 * See the unicode standard Annex #15 for full details.
 *
 * The full algorithm to detect NFC normalization is too complex to be worth implementing in
 * CodeQL, and there are currently no plans to add support for this in the CodeQL language itself.
 * However, the unicode standard does define an "NFC_Quick_Check" property which can be used to
 * quickly determine if a string is definitely normalized, definitely not normalized, or may not be
 * normalized. This type is used to represent those three possible results.
 */
newtype NormalizationCheckResult =
  DefinitelyNormalized() or
  DefinitelyNotNormalized() or
  MaybeNormalized()

/**
 * Holds when the given string is not normalized, or may not be normalized, in NFC form. This is
 * only an approximation of the full NFC normalization check process.
 *
 * See the unicode standard Annex #15 for full details.
 *
 * If all codepoints in the string are definitely normalized, then this predicate returns
 * `DefinitelyNormalized()` and an index of -1. If any codepoint is definitely not normalized, then
 * this predicate returns `DefinitelyNotNormalized()` and holds for each definitely not normalized
 * codepoint's index. Otherwise, if any codepoint may not be normalized, then this predicate returns
 * `MaybeNormalized()` and holds for each maybe not normalized codepoint's index.
 *
 * The exact algorithm to detect NFC normalization is too complex to be worth implementing in
 * CodeQL, and there are currently no plans to add support for this in the CodeQL language itself.
 * However, the unicode standard does define an "NFC_Quick_Check" property which can be used to
 * quickly determine if a string is definitely normalized, definitely not normalized, or may not be
 * normalized. This member predicate exposes that information for approximate checking of NFC
 * normalization.
 */
bindingset[id]
NormalizationCheckResult hasNfcNormalizationCheckResult(string id, int index) {
  // The process of splitting the input string and checking each codepoint is not very efficient, so we
  // only do it if we know there are non-ASCII characters to process. If the string is ASCII, then it is
  // definitely normalized.
  if isAscii(id)
  then result = DefinitelyNormalized() and index = -1
  else
    if nfcQuickCheckCodepointImpl(id, _) = DefinitelyNotNormalized()
    then
      result = DefinitelyNotNormalized() and
      nfcQuickCheckCodepointImpl(id, index) = DefinitelyNotNormalized()
    else
      if nfcQuickCheckCodepointImpl(id, _) = MaybeNormalized()
      then
        result = MaybeNormalized() and
        nfcQuickCheckCodepointImpl(id, index) = MaybeNormalized()
      else (
        result = DefinitelyNormalized() and index = -1
      )
}

/**
 * Helper predicate for `hasNfcNormalizationCheckResult` that checks the `NFC_QC` property of each
 * codepoint in the string.
 *
 * The result is _only_ `DefinitelyNotNormalized()` or `MaybeNormalized()`. If all codepoints are
 * definitely normalized, then this predicate does not hold at all.
 */
bindingset[id]
private NormalizationCheckResult nfcQuickCheckCodepointImpl(string id, int index) {
  exists(int codePoint, string noOrMaybe |
    codePoint = id.codePointAt(index) and
    unicodeHasProperty(codePoint, "NFC_QC", noOrMaybe) and
    noOrMaybe = ["N", "M"] and
    result = quickCheckResultFromString(noOrMaybe)
  )
}

/**
 * Translates an `NFC_QC` property value string into a `NormalizationCheckResult`.
 */
private NormalizationCheckResult quickCheckResultFromString(string noOrMaybe) {
  noOrMaybe = "Y" and result = DefinitelyNormalized()
  or
  noOrMaybe = "N" and result = DefinitelyNotNormalized()
  or
  noOrMaybe = "M" and result = MaybeNormalized()
}
