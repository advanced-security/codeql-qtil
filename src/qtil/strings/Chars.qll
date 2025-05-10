import qtil.strings.Char

/**
 * A module that declares predicates for defining common separators to the various `ListBuilder`
 * modules defined in this file.
 */
module Chars {
  /** Nullary predicate that returns a comma: `,`. */
  pragma[inline]
  Char comma() { result.isStr(",") }

  /** Nullary predicate that returns a dollar sign: `$`. */
  pragma[inline]
  Char dollar() { result.isStr("$") }

  /** Nullary predicate that returns a colon: `:`. */
  pragma[inline]
  Char colon() { result.isStr(":") }

  /** Nullary predicate that returns an at symbol: `@`. */
  pragma[inline]
  Char at() { result.isStr("@") }

  /** Nullary predicate that returns a pound/hash symbol: `#`. */
  pragma[inline]
  Char hash() { result.isStr("#") }

  /** Nullary predicate that returns an exclamation point: `!`. */
  pragma[inline]
  Char excl() { result.isStr("!") }

  /** Nullary predicate that returns a caret: `^`. */
  pragma[inline]
  Char caret() { result.isStr("^") }

  /** Nullary predicate that returns an ampersand: `&`. */
  pragma[inline]
  Char amp() { result.isStr("&") }

  /** Nullary predicate that returns a pipe symbol: `|`. */
  pragma[inline]
  Char pipe() { result.isStr("|") }

  /** Nullary predicate that returns a semicolon: `;`. */
  pragma[inline]
  Char semicolon() { result.isStr(";") }

  /** Nullary predicate that returns a plus symbol: `+`. */
  pragma[inline]
  Char plus() { result.isStr("+") }

  /** Nullary predicate that returns an asterisk symbol: `*`. */
  pragma[inline]
  Char asterisk() { result.isStr("*") }

  /** Nullary predicate that returns a dash/minus symbol: `-`. */
  pragma[inline]
  Char minus() { result.isStr("-") }

  /** Nullary predicate that returns an underscore symbol: `_`. */
  pragma[inline]
  Char underscore() { result.isStr("_") }

  /** Nullary predicate that returns a forward slash: `/`. */
  pragma[inline]
  Char slash() { result.isStr("/") }

  /** Nullary predicate that returns a backslash: `\`. */
  pragma[inline]
  Char backslash() { result.isStr("\\") }

  /** Nullary predicate that returns a dot/period: `.`. */
  pragma[inline]
  Char dot() { result.isStr(".") }

  /** Nullary predicate that returns a question mark: `?`. */
  pragma[inline]
  Char question() { result.isStr("?") }

  /** Nullary predicate that returns a percentage symbol: `%`. */
  pragma[inline]
  Char percent() { result.isStr("%") }

  /** Nullary predicate that returns a tilde: `~`. */
  pragma[inline]
  Char tilde() { result.isStr("~") }

  /** Nullary predicate that returns a space character: ` `. */
  pragma[inline]
  Char space() { result.isStr(" ") }

  /** Nullary predicate that returns a tab character: `\t`. */
  pragma[inline]
  Char tab() { result.isStr("\t") }

  /** Nullary predicate that returns a newline character: `\n`. */
  pragma[inline]
  Char newline() { result.isStr("\n") }

  /** Nullary predicate that returns a backtick: "`". */
  pragma[inline]
  Char backtick() { result.isStr("`") }

  /** Nullary predicate that returns an open parenthesis: `(`. */
  pragma[inline]
  Char openParen() { result.isStr("(") }

  /** Nullary predicate that returns a closing parenthesis: `)`. */
  pragma[inline]
  Char closeParen() { result.isStr(")") }

  /** Nullary predicate that returns an open bracket: `[`. */
  pragma[inline]
  Char openBracket() { result.isStr("[") }

  /** Nullary predicate that returns a closing bracket: `]`. */
  pragma[inline]
  Char closeBracket() { result.isStr("]") }

  /** Nullary predicate that returns a less than symbol: `<`. */
  pragma[inline]
  Char lt() { result.isStr("<") }

  /** Nullary predicate that returns a greater than symbol: `>`. */
  pragma[inline]
  Char gt() { result.isStr(">") }

  /** Nullary predicate that returns single quote character: `'`. */
  pragma[inline]
  Char singleQuote() { result.isStr("'") }

  /** Nullary predicate that returns double quote character: `"`. */
  pragma[inline]
  Char doubleQuote() { result.isStr("\"") }

  /** Nullary predicate that returns a NULL character (0x0). */
  Char null() { result = 0 }

  /** Nullary predicate that returns a bell character (0x7). */
  Char bell() { result = 7 }

  /** Nullary predicate that returns a backspace character (0x8). */
  Char backspace() { result = 8 }

  /** Nullary predicate that returns a linefeed character (0xA) */
  Char linefeed() { result = 10 }

  /** Nullary predicate that returns a carriage return character (0xD) */
  Char carriageReturn() { result = 13 }

  /** Nullary predicate that returns a cancel character (0x18) */
  Char cancel() { result = 24 }

  /** Nullary predicate that returns a cancel character (0x1B) */
  Char escape() { result = 27 }

  /** Nullary predicate that returns a cancel character (0x1C) */
  Char fileSeparator() { result = 28 }

  /** Nullary predicate that returns a lowercase "a" character. */
  Char a() { result.isStr("a") }

  /** Nullary predicate that returns an uppercase "A" character. */
  Char upperA() { result.isStr("A") }

  /** Nullary predicate that returns a lowercase "b" character. */
  Char b() { result.isStr("b") }

  /** Nullary predicate that returns an uppercase "B" character. */
  Char upperB() { result.isStr("B") }

  /** Nullary predicate that returns a lowercase "c" character. */
  Char c() { result.isStr("c") }

  /** Nullary predicate that returns an uppercase "C" character. */
  Char upperC() { result.isStr("C") }

  /** Nullary predicate that returns a lowercase "d" character. */
  Char d() { result.isStr("d") }

  /** Nullary predicate that returns an uppercase "D" character. */
  Char upperD() { result.isStr("D") }

  /** Nullary predicate that returns a lowercase "e" character. */
  Char e() { result.isStr("e") }

  /** Nullary predicate that returns an uppercase "E" character. */
  Char upperE() { result.isStr("E") }

  /** Nullary predicate that returns a lowercase "f" character. */
  Char f() { result.isStr("f") }

  /** Nullary predicate that returns an uppercase "F" character. */
  Char upperF() { result.isStr("F") }

  /** Nullary predicate that returns a lowercase "g" character. */
  Char g() { result.isStr("g") }

  /** Nullary predicate that returns an uppercase "G" character. */
  Char upperG() { result.isStr("G") }

  /** Nullary predicate that returns a lowercase "h" character. */
  Char h() { result.isStr("h") }

  /** Nullary predicate that returns an uppercase "H" character. */
  Char upperH() { result.isStr("H") }

  /** Nullary predicate that returns a lowercase "i" character. */
  Char i() { result.isStr("i") }

  /** Nullary predicate that returns an uppercase "I" character. */
  Char upperI() { result.isStr("I") }

  /** Nullary predicate that returns a lowercase "j" character. */
  Char j() { result.isStr("j") }

  /** Nullary predicate that returns an uppercase "J" character. */
  Char upperJ() { result.isStr("J") }

  /** Nullary predicate that returns a lowercase "k" character. */
  Char k() { result.isStr("k") }

  /** Nullary predicate that returns an uppercase "K" character. */
  Char upperK() { result.isStr("K") }

  /** Nullary predicate that returns a lowercase "l" character. */
  Char l() { result.isStr("l") }

  /** Nullary predicate that returns an uppercase "L" character. */
  Char upperL() { result.isStr("L") }

  /** Nullary predicate that returns a lowercase "m" character. */
  Char m() { result.isStr("m") }

  /** Nullary predicate that returns an uppercase "M" character. */
  Char upperM() { result.isStr("M") }

  /** Nullary predicate that returns a lowercase "n" character. */
  Char n() { result.isStr("n") }

  /** Nullary predicate that returns an uppercase "N" character. */
  Char upperN() { result.isStr("N") }

  /** Nullary predicate that returns a lowercase "o" character. */
  Char o() { result.isStr("o") }

  /** Nullary predicate that returns an uppercase "O" character. */
  Char upperO() { result.isStr("O") }

  /** Nullary predicate that returns a lowercase "p" character. */
  Char p() { result.isStr("p") }

  /** Nullary predicate that returns an uppercase "P" character. */
  Char upperP() { result.isStr("P") }

  /** Nullary predicate that returns a lowercase "q" character. */
  Char q() { result.isStr("q") }

  /** Nullary predicate that returns an uppercase "Q" character. */
  Char upperQ() { result.isStr("Q") }

  /** Nullary predicate that returns a lowercase "r" character. */
  Char r() { result.isStr("r") }

  /** Nullary predicate that returns an uppercase "R" character. */
  Char upperR() { result.isStr("R") }

  /** Nullary predicate that returns a lowercase "s" character. */
  Char s() { result.isStr("s") }

  /** Nullary predicate that returns an uppercase "S" character. */
  Char upperS() { result.isStr("S") }

  /** Nullary predicate that returns a lowercase "t" character. */
  Char t() { result.isStr("t") }

  /** Nullary predicate that returns an uppercase "T" character. */
  Char upperT() { result.isStr("T") }

  /** Nullary predicate that returns a lowercase "u" character. */
  Char u() { result.isStr("u") }

  /** Nullary predicate that returns an uppercase "U" character. */
  Char upperU() { result.isStr("U") }

  /** Nullary predicate that returns a lowercase "v" character. */
  Char v() { result.isStr("v") }

  /** Nullary predicate that returns an uppercase "V" character. */
  Char upperV() { result.isStr("V") }

  /** Nullary predicate that returns a lowercase "w" character. */
  Char w() { result.isStr("w") }

  /** Nullary predicate that returns an uppercase "W" character. */
  Char upperW() { result.isStr("W") }

  /** Nullary predicate that returns a lowercase "x" character. */
  Char x() { result.isStr("x") }

  /** Nullary predicate that returns an uppercase "X" character. */
  Char upperX() { result.isStr("X") }

  /** Nullary predicate that returns a lowercase "y" character. */
  Char y() { result.isStr("y") }

  /** Nullary predicate that returns an uppercase "Y" character. */
  Char upperY() { result.isStr("Y") }

  /** Nullary predicate that returns a lowercase "z" character. */
  Char z() { result.isStr("z") }

  /** Nullary predicate that returns an uppercase "Z" character. */
  Char upperZ() { result.isStr("Z") }

  /** Nullary predicate that returns the character "1". */
  Char one() { result.isStr("1") }

  /** Nullary predicate that returns the character "2". */
  Char two() { result.isStr("2") }

  /** Nullary predicate that returns the character "3". */
  Char three() { result.isStr("3") }

  /** Nullary predicate that returns the character "4". */
  Char four() { result.isStr("4") }

  /** Nullary predicate that returns the character "5". */
  Char five() { result.isStr("5") }

  /** Nullary predicate that returns the character "6". */
  Char six() { result.isStr("6") }

  /** Nullary predicate that returns the character "7". */
  Char seven() { result.isStr("7") }

  /** Nullary predicate that returns the character "8". */
  Char eight() { result.isStr("8") }

  /** Nullary predicate that returns the character "9". */
  Char nine() { result.isStr("9") }

  /** Nullary predicate that returns the character "0". */
  Char zero() { result.isStr("0") }
}
