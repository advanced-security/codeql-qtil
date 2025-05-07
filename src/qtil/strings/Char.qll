private import qtil.inheritance.Instance

// Import predicates `join(...)` from the `qtil.strings` module without namespace collision.
private module Str {
  import qtil.strings.Join
}

/**
 * A class representing a single character, backed by an integer code point.
 *
 * *Caution*: As a subtype of `int`, this will behave similarly to `c` where accidental integer
 * operations can occur. For example, `charOf("a") + 1` will yield the integer `98` where a type
 * error may be expected, and `charOf("a") + charOf("b")` will yield the integer `195` where the
 * string "ab" may be expected. Luckily, `charOf("a") + "b"` will yield the (likely expected) string
 * "ab", as CodeQL converts the "integer" representation of the `Char` to a string using the
 * implementation of `toString()` in this class, which will yield the string "a" rather than the
 * string "97". These are all the result of the design choice working around the fact that CodeQL
 * has a limited number of options for representing infinite types, and the fact that there are too
 * many code points for it to be efficient to represent them all exhaustively via a finite disjoint
 * type such as a `newtype`. If this class were to extend `string`, then APIs which expect a `Char`
 * would accept strings with multiple characters without a type error. By extending `int`, the
 * problem is avoided at the risk of allowing integers in place of an explicit `Char` type.
 *
 * To construct a `Char`, use the `charOf(string)` predicate or constrain `.isStr(string)`.
 */
class Char extends InfInstance<int>::Type {
  /**
   * There must be a unicode character corresponding to the code point for this to be a `Char`.
   */
  bindingset[this]
  Char() { exists(inst().toUnicode()) }

  /**
   * Turn the code point into a string containing the relevant unicode character.
   */
  bindingset[this]
  pragma[inline]
  string toString() { result = inst().toUnicode() }

  /**
   * Get the code point of this character.
   */
  bindingset[this]
  pragma[inline]
  int codePoint() { result = inst() }

  /**
   * Holds if the character is not an uppercase letter.
   *
   * This means it holds for digits and special characters, which matches the behavior of
   * `string.isLowercase()`.
   */
  bindingset[this]
  pragma[inline]
  predicate isLowercase() { toString().isLowercase() }

  /**
   * Provides the lowercase version of this character if it is an uppercase letter, otherwise
   * provides itself.
   *
   * This means digits and special characters will provide themselves as a result, which matches the
   * behavior of `string.toLowerCase()`.
   */
  bindingset[this]
  pragma[inline]
  Char toLowercase() { result.isStr(toString().toLowerCase()) }

  /**
   * Holds if the character is not a lowercase letter.
   *
   * This means it holds for digits and special characters, which matches the behavior of
   * `string.isUppercase()`.
   */
  bindingset[this]
  pragma[inline]
  predicate isUppercase() { toString().isUppercase() }

  /**
   * Provides the uppercase version of this character if it is a lowercase letter, otherwise
   * provides itself.
   *
   * This means digits and special characters will provide themselves as a result, which matches the
   * behavior of `string.toUpperCase()`.
   */
  bindingset[this]
  pragma[inline]
  Char toUppercase() { result.isStr(toString().toUpperCase()) }

  /**
   * Holds if the character is a digit, i.e. a character in the range 0-9.
   */
  bindingset[this]
  pragma[inline]
  predicate isDigit() { toString() in ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"] }

  /**
   * Holds if the character is a letter, i.e. a character in the range A-Z or a-z.
   */
  bindingset[this]
  pragma[inline]
  predicate isAlphabetic() { not toString().toLowerCase() = toString().toUpperCase() }

  /**
   * Holds if the character is not a digit or a letter, i.e. a symbol or other special character.
   */
  bindingset[this]
  pragma[inline]
  predicate isSpecial() {
    not isDigit() and
    not isAlphabetic()
  }

  /**
   * Holds if the character is an ascii codepoint, in the range 0-127, rather than a unicode
   * codepoint.
   */
  bindingset[this]
  pragma[inline]
  predicate isAscii() {
    codePoint() >= 0 and
    codePoint() <= 127
  }

  /**
   * Holds if the provided str is contains one character, and that character is the same as this.
   */
  bindingset[s]
  pragma[inline]
  predicate isStr(string s) { s = inst().toUnicode() }

  /**
   * Repeats this character n times, where n is a non-negative integer.
   *
   * For example, `charOf("a").repeat(3)` will yield the string "aaa".
   */
  bindingset[this, n]
  pragma[inline]
  string repeat(int n) {
    n >= 0 and
    result = concat(int x | x = [1 .. n] | this.toString())
  }

  bindingset[this]
  string twice() { result = this.toString() + this.toString() }

  /**
   * Places this character at the start and end of the provided string.
   *
   * For example, `charOf("$").wrap("foo")` will yield the string "$foo$".
   */
  bindingset[this, s]
  pragma[inline]
  string wrap(string s) { result = this.toString() + s + this.toString() }

  /**
   * Uses this character as a separator to join the provided strings together.
   *
   * This member is overloaded to allow for 2-8 arguments.
   */
  bindingset[this, v1, v2]
  pragma[inline]
  string join(string v1, string v2) { result = Str::join(this.toString(), v1, v2) }

  /**
   * Uses this character as a separator to join the provided strings together.
   *
   * This member is overloaded to allow for 2-8 arguments.
   */
  bindingset[this, v1, v2, v3]
  pragma[inline]
  string join(string v1, string v2, string v3) { result = Str::join(this.toString(), v1, v2, v3) }

  /**
   * Uses this character as a separator to join the provided strings together.
   *
   * This member is overloaded to allow for 2-8 arguments.
   */
  bindingset[this, v1, v2, v3, v4]
  pragma[inline]
  string join(string v1, string v2, string v3, string v4) {
    result = Str::join(this.toString(), v1, v2, v3, v4)
  }

  /**
   * Uses this character as a separator to join the provided strings together.
   *
   * This member is overloaded to allow for 2-8 arguments.
   */
  bindingset[this, v1, v2, v3, v4, v5]
  pragma[inline]
  string join(string v1, string v2, string v3, string v4, string v5) {
    result = Str::join(this.toString(), v1, v2, v3, v4, v5)
  }

  /**
   * Uses this character as a separator to join the provided strings together.
   *
   * This member is overloaded to allow for 2-8 arguments.
   */
  bindingset[this, v1, v2, v3, v4, v5, v6]
  pragma[inline]
  string join(string v1, string v2, string v3, string v4, string v5, string v6) {
    result = Str::join(this.toString(), v1, v2, v3, v4, v5, v6)
  }

  /**
   * Uses this character as a separator to join the provided strings together.
   *
   * This member is overloaded to allow for 2-8 arguments.
   */
  bindingset[this, v1, v2, v3, v4, v5, v6, v7]
  pragma[inline]
  string join(string v1, string v2, string v3, string v4, string v5, string v6, string v7) {
    result = Str::join(this.toString(), v1, v2, v3, v4, v5, v6, v7)
  }

  /**
   * Uses this character as a separator to join the provided strings together.
   *
   * This member is overloaded to allow for 2-8 arguments.
   */
  bindingset[this, v1, v2, v3, v4, v5, v6, v7, v8]
  pragma[inline]
  string join(string v1, string v2, string v3, string v4, string v5, string v6, string v7, string v8) {
    result = Str::join(this.toString(), v1, v2, v3, v4, v5, v6, v7, v8)
  }

  /**
   * Splits the provided string on occurrences of this character.
   *
   * Holds for all results such that the result is a section of the string after being split.
   */
  bindingset[this, s]
  pragma[inline]
  string split(string s) { result = s.splitAt(this.toString()) }

  /**
   * Holds when the result equals the nth section of the provided string after being split on this
   * character, where n is the idx parameter.
   */
  bindingset[this, s, idx]
  pragma[inline]
  string split(string s, int idx) { result = s.splitAt(this.toString(), idx) }

  /**
   * Returns all of the offsets (starting at 0) of this character in the provided string. Has no
   * results if the character does not exist in the string.
   *
   * Equivalent to `str.indexOf(this.toString())`.
   */
  bindingset[this, s]
  pragma[inline]
  int indexIn(string s) { result = s.indexOf(this.toString()) }

  /**
   * Returns the index of the nth offset of where this character occurs in the provided string, starting
   * the search the provided `startAt` index. Has no results if the character does not exist in the
   * string.
   *
   * Equivalent to `str.indexOf(this.toString(), idx, startAt)`.
   */
  bindingset[this, s, startAt]
  pragma[inline]
  int indexIn(string s, int idx, int startAt) { result = s.indexOf(this.toString(), idx, startAt) }
}

/**
 * Get the `Char` representation of the provided string, which must be a single character.
 *
 * Does not hold if the string is empty or contains more than one character.
 */
bindingset[s]
pragma[inline]
Char charOf(string s) { result.isStr(s) }
