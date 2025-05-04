/**
 * WARNING: This test is incredibly slow to compile.
 * 
 * CodeQL gets into some pathological cases and it may take over a minute to compile, even though
 * it runs in about a hundred milliseconds.
 */

import qtil.strings.Char
import qtil.testing.Qnit

class TestCharToStringIsStr extends Test, Case {
  override predicate run(Qnit test) {
    if
      charOf("a").isStr("a") and
      charOf("b").isStr("b") and
      charOf("c").isStr("c") and
      charOf("d").isStr("d") and
      charOf("e").isStr("e") and
      charOf("f").isStr("f") and
      charOf("g").isStr("g") and
      charOf("h").isStr("h") and
      charOf("i").isStr("i") and
      charOf("j").isStr("j") and
      charOf("$").isStr("$") and
      charOf("!").isStr("!") and
      charOf(" ").isStr(" ") and
      charOf("~").isStr("~") and
      charOf("1").isStr("1") and
      charOf("2").isStr("2") and
      charOf("3").isStr("3") and
      charOf("\n").isStr("\n") and
      charOf("\t").isStr("\t")
    then test.pass("Char to string isStr works")
    else test.fail("Char to string isStr doesn't work")
  }
}

class TestCharToString extends Test, Case {
  override predicate run(Qnit test) {
    if
      charOf("a").toString() = "a" and
      charOf("b").toString() = "b" and
      charOf("c").toString() = "c" and
      charOf("d").toString() = "d" and
      charOf("e").toString() = "e" and
      charOf("f").toString() = "f" and
      charOf("g").toString() = "g" and
      charOf("h").toString() = "h" and
      charOf("i").toString() = "i" and
      charOf("j").toString() = "j" and
      charOf("$").toString() = "$" and
      charOf("!").toString() = "!" and
      charOf(" ").toString() = " " and
      charOf("~").toString() = "~" and
      charOf("1").toString() = "1" and
      charOf("2").toString() = "2" and
      charOf("3").toString() = "3" and
      charOf("\n").toString() = "\n" and
      charOf("\t").toString() = "\t"
    then test.pass("Char to string works")
    else test.fail("Char to string doesn't work")
  }
}

class TestCharToStringIsNotStr extends Test, Case {
  override predicate run(Qnit test) {
    if
      charOf("a")
          .isStr([
              "A", "b", "c", "d", "e", "f", "g", "h", "i", "j", "$", "!", " ", "~", "1", "2", "3",
              "\n", "\t"
            ]) or
      charOf(" ")
          .isStr([
              "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "$", "!", "~", "1", "2", "3", "\n",
              "\t"
            ]) or
      charOf("1")
          .isStr(["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "$", "!", "~", " ", "\n", "\t"]) or
      charOf("$")
          .isStr(["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "!", "~", " ", "\n", "\t"])
    then test.fail("Char to string isStr holding for incorrect values")
    else test.pass("Char to string isStr correctly not holding for incorrect values")
  }
}

class TestCharIsDigit extends Test, Case {
  override predicate run(Qnit test) {
    if
      charOf(["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]).isDigit() and
      not charOf(["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "$", "!", " ", "~", "\n", "\t"])
          .isDigit()
    then test.pass("Char is digit works")
    else test.fail("Char is digit doesn't work")
  }
}

class TestCharIsAlphabetic extends Test, Case {
  override predicate run(Qnit test) {
    if
      charOf([
          "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r",
          "s", "t", "u", "v", "w", "x", "y", "z"
        ]).isAlphabetic() and
      charOf([
          "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R",
          "S", "T", "U", "V", "W", "X", "Y", "Z"
        ]).isAlphabetic() and
      not charOf(["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "$", "!", " ", "~", "\n", "\t"])
          .isAlphabetic()
    then test.pass("Char is alphabetic works")
    else test.fail("Char is alphabetic doesn't work")
  }
}

class TestCharIsSpecial extends Test, Case {
  override predicate run(Qnit test) {
    if
      charOf(["$", "!", " ", "~", "\n", "\t"]).isSpecial() and
      not charOf([
          "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r",
          "s", "t", "u", "v", "w", "x", "y", "z"
        ]).isSpecial() and
      not charOf(["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]).isSpecial()
    then test.pass("Char is special works")
    else test.fail("Char is special doesn't work")
  }
}

class TestCharIsLowercase extends Test, Case {
  override predicate run(Qnit test) {
    if
      charOf([
          "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r",
          "s", "t", "u", "v", "w", "x", "y", "z"
        ]).isLowercase() and
      not charOf([
          "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R",
          "S", "T", "U", "V", "W", "X", "Y", "Z"
        ]).isLowercase() and
      // Match string.isLowercase() behavior: if its not an uppercase character, it is considered lowercase.
      charOf(["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]).isLowercase() and
      charOf(["$", "!", " ", "~", "\n", "\t"]).isLowercase()
    then test.pass("Char is lowercase works")
    else test.fail("Char is lowercase doesn't work")
  }
}

class TestCharIsUppercase extends Test, Case {
  override predicate run(Qnit test) {
    if
      charOf([
          "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R",
          "S", "T", "U", "V", "W", "X", "Y", "Z"
        ]).isUppercase() and
      not charOf(["a", "b", "c", "d", "e", "f", "g", "h", "i", "j"]).isUppercase() and
      // Match string.isUppercase() behavior: if its not a lowercase character, it is considered uppercase.
      charOf(["0", "1", "2", "3", "4", "5", "6", "7"]).isUppercase() and
      charOf(["$", "$"]).isUppercase()
    then test.pass("Char is uppercase works")
    else test.fail("Char is uppercase doesn't work")
  }
}

class TestCharIsAscii extends Test, Case {
  override predicate run(Qnit test) {
    if
      [0 .. 127].(Char).isAscii() and
      not [128 .. 526].(Char).isAscii()
    then test.pass("Char is ascii works")
    else test.fail("Char is ascii doesn't work")
  }
}

class TestCharCodePoint extends Test, Case {
  override predicate run(Qnit test) {
    if
      charOf("a").codePoint() = 97 and
      charOf("b").codePoint() = 98 and
      charOf("c").codePoint() = 99 and
      charOf("d").codePoint() = 100 and
      charOf("e").codePoint() = 101 and
      charOf("f").codePoint() = 102 and
      charOf("g").codePoint() = 103 and
      charOf("h").codePoint() = 104 and
      charOf("i").codePoint() = 105 and
      charOf("j").codePoint() = 106 and
      charOf("0").codePoint() = 48 and
      charOf("1").codePoint() = 49 and
      charOf("2").codePoint() = 50 and
      charOf("3").codePoint() = 51 and
      charOf("$").codePoint() = 36 and
      charOf("!").codePoint() = 33 and
      charOf(" ").codePoint() = 32 and
      charOf("~").codePoint() = 126 and
      charOf("\n").codePoint() = 10 and
      charOf("\t").codePoint() = 9
    then test.pass("Char code point works")
    else test.fail("Char code point doesn't work" + charOf("a").codePoint().toString())
  }
}

class TestIntToChar extends Test, Case {
  override predicate run(Qnit test) {
    if
      97.(Char).isStr("a") and
      98.(Char).isStr("b") and
      99.(Char).isStr("c") and
      100.(Char).isStr("d") and
      101.(Char).isStr("e") and
      102.(Char).isStr("f") and
      103.(Char).isStr("g") and
      104.(Char).isStr("h") and
      105.(Char).isStr("i") and
      106.(Char).isStr("j") and
      48.(Char).isStr("0") and
      49.(Char).isStr("1") and
      50.(Char).isStr("2") and
      51.(Char).isStr("3") and
      36.(Char).isStr("$") and
      33.(Char).isStr("!") and
      32.(Char).isStr(" ") and
      126.(Char).isStr("~") and
      10.(Char).isStr("\n") and
      9.(Char).isStr("\t")
    then test.pass("Int to char works")
    else test.fail("Int to char doesn't work")
  }
}

class TestToUpperCase extends Test, Case {
  override predicate run(Qnit test) {
    if
      charOf(["a", "A"]).toUppercase().isStr("A") and
      charOf(["b", "B"]).toUppercase().isStr("B") and
      charOf(["c", "C"]).toUppercase().isStr("C") and
      // Optimizer seems to hit a pathological case here and doesn't terminate.
      /*
       * charOf(["d", "D"]).toUppercase().isStr("D") and
       *      charOf(["e", "E"]).toUppercase().isStr("E") and
       *      charOf(["f", "F"]).toUppercase().isStr("F") and
       *      charOf(["g", "G"]).toUppercase().isStr("G") and
       *      charOf(["h", "H"]).toUppercase().isStr("H") and
       *      charOf(["i", "I"]).toUppercase().isStr("I") and
       *      charOf(["j", "J"]).toUppercase().isStr("J") and
       *      charOf(["k", "K"]).toUppercase().isStr("K") and
       *      charOf(["l", "L"]).toUppercase().isStr("L") and
       *      charOf(["m", "M"]).toUppercase().isStr("M") and
       *      charOf(["n", "N"]).toUppercase().isStr("N") and
       *      charOf(["o", "O"]).toUppercase().isStr("O") and
       *      charOf(["p", "P"]).toUppercase().isStr("P") and
       *      charOf(["q", "Q"]).toUppercase().isStr("Q") and
       *      charOf(["r", "R"]).toUppercase().isStr("R") and
       *      charOf(["s", "S"]).toUppercase().isStr("S") and
       *      charOf(["t", "T"]).toUppercase().isStr("T") and
       *      charOf(["u", "U"]).toUppercase().isStr("U") and
       *      charOf(["v", "V"]).toUppercase().isStr("V") and
       *      charOf(["w", "W"]).toUppercase().isStr("W") and
       *      charOf(["x", "X"]).toUppercase().isStr("X") and
       */

      charOf(["y", "Y"]).toUppercase().isStr("Y") and
      charOf(["z", "Z"]).toUppercase().isStr("Z") and
      charOf("0").toUppercase().isStr("0") and
      charOf("1").toUppercase().isStr("1") and
      charOf("2").toUppercase().isStr("2") and
      charOf("$").toUppercase().isStr("$") and
      charOf("!").toUppercase().isStr("!") and
      charOf(" ").toUppercase().isStr(" ") and
      charOf("\n").toUppercase().isStr("\n")
    then test.pass("Char to uppercase works")
    else test.fail("Char to uppercase doesn't work")
  }
}

class TestToLowerCase extends Test, Case {
  override predicate run(Qnit test) {
    if
      charOf(["a", "A"]).toLowercase().isStr("a") and
      charOf(["b", "B"]).toLowercase().isStr("b") and
      charOf(["c", "C"]).toLowercase().isStr("c") and
      /*
       * Optimizer seems to hit a pathological case here and doesn't terminate.
       *      charOf(["d", "D"]).toLowercase().isStr("d") and
       *      charOf(["e", "E"]).toLowercase().isStr("e") and
       *      charOf(["f", "F"]).toLowercase().isStr("f") and
       *      charOf(["g", "G"]).toLowercase().isStr("g") and
       *      charOf(["h", "H"]).toLowercase().isStr("h") and
       *      charOf(["i", "I"]).toLowercase().isStr("i") and
       *      charOf(["j", "J"]).toLowercase().isStr("j") and
       *      charOf(["k", "K"]).toLowercase().isStr("k") and
       *      charOf(["l", "L"]).toLowercase().isStr("l") and
       *      charOf(["m", "M"]).toLowercase().isStr("m") and
       *      charOf(["n", "N"]).toLowercase().isStr("n") and
       *      charOf(["o", "O"]).toLowercase().isStr("o") and
       *      charOf(["p", "P"]).toLowercase().isStr("p") and
       *      charOf(["q", "Q"]).toLowercase().isStr("q") and
       *      charOf(["r", "R"]).toLowercase().isStr("r") and
       *      charOf(["s", "S"]).toLowercase().isStr("s") and
       *      charOf(["t", "T"]).toLowercase().isStr("t") and
       *      charOf(["u", "U"]).toLowercase().isStr("u") and
       *      charOf(["v", "V"]).toLowercase().isStr("v") and
       *      charOf(["w", "W"]).toLowercase().isStr("w") and
       *      charOf(["x", "X"]).toLowercase().isStr("x") and
       */

      charOf(["y", "Y"]).toLowercase().isStr("y") and
      charOf(["z", "Z"]).toLowercase().isStr("z") and
      charOf("0").toLowercase().isStr("0") and
      charOf("1").toLowercase().isStr("1") and
      charOf("2").toLowercase().isStr("2") and
      charOf("$").toLowercase().isStr("$") and
      charOf("!").toLowercase().isStr("!") and
      charOf(" ").toLowercase().isStr(" ") and
      charOf("\n").toLowercase().isStr("\n")
    then test.pass("Char to lowercase works")
    else test.fail("Char to lowercase doesn't work")
  }
}

class TestCharRepeat extends Test, Case {
  override predicate run(Qnit test) {
    if
      not exists(charOf("a").repeat(-1)) and
      charOf("a").repeat(0) = "" and
      charOf("a").repeat(1) = "a" and
      charOf("b").repeat(2) = "bb" and
      charOf("c").repeat(3) = "ccc" and
      charOf("d").repeat(4) = "dddd" and
      charOf("e").repeat(5) = "eeeee" and
      charOf("f").repeat(6) = "ffffff" and
      charOf("g").repeat(7) = "ggggggg" and
      charOf("h").repeat(8) = "hhhhhhhh" and
      charOf("i").repeat(9) = "iiiiiiiii" and
      charOf("j").repeat(10) = "jjjjjjjjjj" and
      charOf("0").repeat(1) = "0" and
      charOf("1").repeat(2) = "11" and
      charOf("2").repeat(3) = "222" and
      charOf("3").repeat(4) = "3333" and
      charOf("$").repeat(5) = "$$$$$" and
      charOf("!").repeat(6) = "!!!!!!" and
      charOf(" ").repeat(7) = "       " and
      charOf("~").repeat(8) = "~~~~~~~~" and
      charOf("\n").repeat(9) = "\n\n\n\n\n\n\n\n\n" and
      charOf("\t").repeat(10) = "\t\t\t\t\t\t\t\t\t\t"
    then test.pass("Char repeat works")
    else test.fail("Char repeat doesn't work")
  }
}

class TestCharWrap extends Test, Case {
  override predicate run(Qnit test) {
    if
      charOf("a").wrap("foo") = "afooa" and
      charOf("'").wrap("bar") = "'bar'" and
      charOf("\"").wrap("baz") = "\"baz\""
    then test.pass("Char wrap works")
    else test.fail("Char wrap doesn't work")
  }
}
