import qtil.strings.Chars
import qtil.testing.Qnit
import qtil.parameterization.SignatureTypes
import Chars

class TestSymbolChars extends Test, Case {
  predicate passes() {
    amp().isStr("&") and
    asterisk().isStr("*") and
    at().isStr("@") and
    backslash().isStr("\\") and
    backtick().isStr("`") and
    caret().isStr("^") and
    closeBracket().isStr("]") and
    closeParen().isStr(")") and
    colon().isStr(":") and
    comma().isStr(",") and
    dollar().isStr("$") and
    dot().isStr(".") and
    doubleQuote().isStr("\"") and
    excl().isStr("!") and
    gt().isStr(">") and
    hash().isStr("#") and
    lt().isStr("<") and
    minus().isStr("-") and
    newline().isStr("\n") and
    openBracket().isStr("[") and
    openParen().isStr("(") and
    percent().isStr("%") and
    pipe().isStr("|") and
    plus().isStr("+") and
    question().isStr("?") and
    semicolon().isStr(";") and
    singleQuote().isStr("'") and
    slash().isStr("/") and
    space().isStr(" ") and
    tab().isStr("\t") and
    tilde().isStr("~") and
    underscore().isStr("_")
  }

  override predicate run(Qnit test) {
    if passes()
    then test.pass("All symbol chars correct")
    else test.fail("Not all symbol chars correct")
  }
}

class TestUnprintableCharacters extends Test, Case {
  override predicate run(Qnit test) {
    if
      null() = 0 and
      bell() = 7 and
      backspace() = 8 and
      linefeed() = 10 and
      carriageReturn() = 13 and
      cancel() = 24 and
      escape() = 27 and
      fileSeparator() = 28
    then test.pass("All unprintable chars correct")
    else test.fail("Not all unprintable chars correct")
  }
}

class TestLowercaseCharacters extends Test, Case {
  predicate passes() {
    a().isStr("a") and
    b().isStr("b") and
    c().isStr("c") and
    d().isStr("d") and
    e().isStr("e") and
    f().isStr("f") and
    g().isStr("g") and
    h().isStr("h") and
    i().isStr("i") and
    j().isStr("j") and
    k().isStr("k") and
    l().isStr("l") and
    m().isStr("m") and
    n().isStr("n") and
    o().isStr("o") and
    p().isStr("p") and
    q().isStr("q") and
    r().isStr("r") and
    s().isStr("s") and
    t().isStr("t") and
    u().isStr("u") and
    v().isStr("v") and
    w().isStr("w") and
    x().isStr("x") and
    y().isStr("y") and
    z().isStr("z")
  }

  override predicate run(Qnit test) {
    if passes()
    then test.pass("All lowercase alphabetic chars correct")
    else test.fail("Not all lowercase alphabetic chars correct")
  }
}

class TestUppercaseCharacters extends Test, Case {
  predicate passes() {
    upperA().isStr("A") and
    upperB().isStr("B") and
    upperC().isStr("C") and
    upperD().isStr("D") and
    upperE().isStr("E") and
    upperF().isStr("F") and
    upperG().isStr("G") and
    upperH().isStr("H") and
    upperI().isStr("I") and
    upperJ().isStr("J") and
    upperK().isStr("K") and
    upperL().isStr("L") and
    upperM().isStr("M") and
    upperN().isStr("N") and
    upperO().isStr("O") and
    upperP().isStr("P") and
    upperQ().isStr("Q") and
    upperR().isStr("R") and
    upperS().isStr("S") and
    upperT().isStr("T") and
    upperU().isStr("U") and
    upperV().isStr("V") and
    upperW().isStr("W") and
    upperX().isStr("X") and
    upperY().isStr("Y") and
    upperZ().isStr("Z")
  }

  override predicate run(Qnit test) {
    if passes()
    then test.pass("All uppercase alphabetic chars correct")
    else test.fail("Not all uppercase alphabetic chars correct")
  }
}

class TestDigitCharacters extends Test, Case {
  override predicate run(Qnit test) {
    if
      one().isStr("1") and
      two().isStr("2") and
      three().isStr("3") and
      four().isStr("4") and
      five().isStr("5") and
      six().isStr("6") and
      seven().isStr("7") and
      eight().isStr("8") and
      nine().isStr("9") and
      zero().isStr("0")
    then test.pass("All digit chars correct")
    else test.fail("Not all digit chars correct")
  }
}
