/** Simple pluralization utilities — appends "s" to a string, with optional count-based singular/plural selection. */
bindingset[str]
string plural(string str) { result = str + "s" }

bindingset[str, pcount]
string plural(string str, int pcount) { result = plural(str, plural(str), pcount) }

bindingset[single, plural, pcount]
string plural(string single, string plural, int pcount) {
  if pcount = 1 then result = single else result = plural
}
