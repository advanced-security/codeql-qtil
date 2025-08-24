import qtil.testing.Qnit
import qtil.strings.Unicode

class UnicodeHasPropertyTest extends Test, Case {
  override predicate run(Qnit test) {
    if unicodeHasProperty("A".codePointAt(0), "General_Category", "Lu")
    then test.pass("Unicode is available and has General_Category 'Lu' for 'A'.")
    else test.fail("Unicode does not have General_Category 'Lu' for 'A'.")
  }
}

class UnicodeHasBooleanPropertyTest extends Test, Case {
  override predicate run(Qnit test) {
    if unicodeHasBooleanProperty(65, "Alphabetic")
    then test.pass("Unicode is available and 'A' is alphabetic.")
    else test.fail("Unicode does not have 'A' as alphabetic.")
  }
}

class UnicodeHasNumericPropertyTest extends Test, Case {
  override predicate run(Qnit test) {
    if unicodeHasNumericProperty("9".codePointAt(0), "Numeric_Value", 9)
    then test.pass("Unicode is available and '9' has numeric value 9.")
    else test.fail("Unicode does not have '9' with numeric value 9.")
  }
}

class StringContainsUnicodeEscapeTest extends Test, Case {
  override predicate run(Qnit test) {
    if containsUnicodeEscape("Hello \\u0041")
    then test.pass("String contains Unicode escape sequence.")
    else test.fail("String does not contain Unicode escape sequence.")
  }
}

class StringDoesNotContainUnicodeEscapeTest extends Test, Case {
  override predicate run(Qnit test) {
    if not containsUnicodeEscape("Hello A")
    then test.pass("String does not contain Unicode escape sequence.")
    else test.fail("String contains Unicode escape sequence.")
  }
}

class StringIsAsciiTest extends Test, Case {
  override predicate run(Qnit test) {
    if isAscii("Hello!") then test.pass("String is ASCII.") else test.fail("String is not ASCII.")
  }
}

class StringIsNotAsciiTest extends Test, Case {
  override predicate run(Qnit test) {
    if not isAscii("Hello ñ")
    then test.pass("String is not ASCII.")
    else test.fail("String is ASCII.")
  }
}

class UnescapeUnicodeTest extends Test, Case {
  override predicate run(Qnit test) {
    if unescapeUnicode("Hello \\u0041") = "Hello A"
    then test.pass("Unicode escape sequence unescaped correctly.")
    else test.fail("Unicode escape sequence not unescaped correctly.")
  }
}

class UnescapeUnicodeNoEscapeTest extends Test, Case {
  override predicate run(Qnit test) {
    if unescapeUnicode("Hello A") = "Hello A"
    then test.pass("String without escape sequence remains unchanged.")
    else test.fail("String without escape sequence changed incorrectly.")
  }
}

class UnescapeUnicodeMultipleEscapesTest extends Test, Case {
  override predicate run(Qnit test) {
    if unescapeUnicode("Hello \\u0041 and \\u00F1") = "Hello A and ñ"
    then test.pass("Multiple Unicode escape sequences unescaped correctly.")
    else test.fail("Multiple Unicode escape sequences not unescaped correctly.")
  }
}

class NonUax44IdentifierCodepointAsciiTest extends Test, Case {
  override predicate run(Qnit test) {
    if not nonUax44IdentifierCodepoint("asciiIdentifier", _)
    then test.pass("ASCII characters are valid UAX44 identifier codepoints.")
    else test.fail("ASCII characters are not recognized as valid UAX44 identifier codepoints.")
  }
}

class NonUax44IdentifierCodepointInvalidStartTest extends Test, Case {
  override predicate run(Qnit test) {
    if nonUax44IdentifierCodepoint("1invalid", 0)
    then test.pass("'1' is an invalid start for a UAX44 identifier.")
    else test.fail("'1' is not recognized as an invalid start for a UAX44 identifier.")
  }
}

class NonUax44IdentifierCodepointValidUnicodeCharsTest extends Test, Case {
  override predicate run(Qnit test) {
    if not nonUax44IdentifierCodepoint("valid_ñ_id", _)
    then test.pass("Valid Unicode characters are accepted in UAX44 identifiers.")
    else test.fail("Valid Unicode characters are not recognized as valid in UAX44 identifiers.")
  }
}

class NonUax44IdentifierCodepointInvalidContinueTest extends Test, Case {
  override predicate run(Qnit test) {
    if nonUax44IdentifierCodepoint("valid_id!", 8)
    then test.pass("'!' is an invalid continuation for a UAX44 identifier.")
    else test.fail("'!' is not recognized as an invalid continuation for a UAX44 identifier.")
  }
}

class NfcQuickCheckAsciiTest extends Test, Case {
  override predicate run(Qnit test) {
    if hasNfcNormalizationCheckResult("Hello", -1) = DefinitelyNormalized()
    then test.pass("ASCII string is definitely normalized.")
    else test.fail("ASCII string is not definitely normalized.")
  }
}

class NfcQuickCheckNonNormalizedTest extends Test, Case {
  override predicate run(Qnit test) {
    if hasNfcNormalizationCheckResult(unescapeUnicode("e\\u0340"), _) = DefinitelyNotNormalized()
    then test.pass("String with decomposed character is definitely not normalized.")
    else
      test.fail("String with decomposed character is not recognized as definitely not normalized.")
  }
}

class NfcQuickCheckNormalizedTest extends Test, Case {
  override predicate run(Qnit test) {
    if hasNfcNormalizationCheckResult("é", -1) = DefinitelyNormalized()
    then test.pass("String with precomposed character is definitely normalized.")
    else test.fail("String with precomposed character is not recognized as definitely normalized.")
  }
}

class NfcQuickCheckDefinitelyNotNormalizedIndexTest extends Test, Case {
  override predicate run(Qnit test) {
    if
      forex(int index |
        hasNfcNormalizationCheckResult(unescapeUnicode("e\\u0340 and \\u0341"), index) =
          DefinitelyNotNormalized()
      |
        index = 1 or index = 7
      )
    then test.pass("Index of definitely not normalized character identified correctly.")
    else test.fail("Index of definitely not normalized character not identified correctly.")
  }
}

class NfcQuickCheckMaybeNormalizedTest extends Test, Case {
  override predicate run(Qnit test) {
    if hasNfcNormalizationCheckResult(unescapeUnicode("a\\u0301"), _) = MaybeNormalized()
    then test.pass("String with maybe normalized character identified correctly.")
    else test.fail("String with maybe normalized character not identified correctly.")
  }
}

class NfcQuickCheckMixedMaybeAndNotNormalizedTest extends Test, Case {
  override predicate run(Qnit test) {
    if
      forex(int index, NormalizationCheckResult rslt |
        hasNfcNormalizationCheckResult(unescapeUnicode("a\\u0301 and \\u0340"), index) = rslt
      |
        index = 7 and rslt = DefinitelyNotNormalized()
      )
    then
      test.pass("Index of definitely not normalized character in mixed string identified correctly.")
    else
      test.fail("Index of definitely not normalized character in mixed string not identified correctly.")
  }
}

class NfcQuickCheckMultipleMaybeNormalizedIndicesTest extends Test, Case {
  override predicate run(Qnit test) {
    if
      forex(int index |
        hasNfcNormalizationCheckResult(unescapeUnicode("a\\u0301 and \\u0300"), index) =
          MaybeNormalized()
      |
        index = 1 or index = 7
      )
    then test.pass("Indices of maybe normalized characters identified correctly.")
    else test.fail("Indices of maybe normalized characters not identified correctly.")
  }
}
