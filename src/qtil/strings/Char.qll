private import qtil.inheritance.Instance

private module Str {
  import qtil.strings.Join
}

class Char extends InfInstance<int>::Type {
  bindingset[this]
  Char() { exists(inst().toUnicode()) }

  bindingset[this]
  string toString() { result = inst().toUnicode() }

  bindingset[this]
  int codePoint() { result = inst() }

  bindingset[this]
  predicate isLowercase() { toString().isLowercase() }

  bindingset[this]
  Char toLowercase() { result = toString().toLowerCase().codePointAt(0) }

  bindingset[this]
  predicate isUppercase() { toString().isUppercase() }

  bindingset[this]
  Char toUppercase() { result = toString().toUpperCase().codePointAt(0) }

  bindingset[this]
  predicate isDigit() { toString() in ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"] }

  bindingset[this]
  predicate isAlphabetic() { not toString().toLowerCase() = toString().toUpperCase() }

  bindingset[this]
  predicate isSpecial() {
    not isDigit() and
    not isAlphabetic()
  }

  bindingset[this]
  predicate isAscii() {
    codePoint() >= 0 and
    codePoint() <= 127
  }

  bindingset[s]
  predicate isStr(string s) { s.codePointAt(0) = this }

  bindingset[this, n]
  string repeat(int n) {
    n >= 0 and
    result = concat(int x | x = [1 .. n] | this.toString())
  }

  bindingset[this, s]
  string wrap(string s) { result = this.toString() + s + this.toString() }

  bindingset[this, v1, v2]
  string join(string v1, string v2) { result = Str::join(this.toString(), v1, v2) }

  bindingset[this, v1, v2, v3]
  string join(string v1, string v2, string v3) { result = Str::join(this.toString(), v1, v2, v3) }

  bindingset[this, v1, v2, v3, v4]
  string join(string v1, string v2, string v3, string v4) {
    result = Str::join(this.toString(), v1, v2, v3, v4)
  }

  bindingset[this, v1, v2, v3, v4, v5]
  string join(string v1, string v2, string v3, string v4, string v5) {
    result = Str::join(this.toString(), v1, v2, v3, v4, v5)
  }

  bindingset[this, v1, v2, v3, v4, v5, v6]
  string join(string v1, string v2, string v3, string v4, string v5, string v6) {
    result = Str::join(this.toString(), v1, v2, v3, v4, v5, v6)
  }

  bindingset[this, v1, v2, v3, v4, v5, v6, v7]
  string join(string v1, string v2, string v3, string v4, string v5, string v6, string v7) {
    result = Str::join(this.toString(), v1, v2, v3, v4, v5, v6, v7)
  }

  bindingset[this, v1, v2, v3, v4, v5, v6, v7, v8]
  string join(string v1, string v2, string v3, string v4, string v5, string v6, string v7, string v8) {
    result = Str::join(this.toString(), v1, v2, v3, v4, v5, v6, v7, v8)
  }

  bindingset[this, s, idx]
  string split(string s, int idx) {
    result = s.splitAt(this.toString(), idx)
  }

  bindingset[this, s]
  string split(string s) {
    result = s.splitAt(this.toString())
  }

  bindingset[this, s]
  int indexIn(string s) {
    result = s.indexOf(this.toString())
  }

  bindingset[this, s, startAt]
  int indexIn(string s, int idx, int startAt) {
    result = s.indexOf(this.toString(), idx, startAt)
  }
}

bindingset[s]
Char charOf(string s) { result.isStr(s) }
