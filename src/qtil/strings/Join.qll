/**
 * A module for joining strings with a separator, for example, `join(":", "a", "b") = "a:b"`.
 *
 * This module is not designed to replace the `concat` aggregation in CodeQL, but may be useful in
 * rare cases where joining is required without aggregation.
 *
 * There are join predicate for joining 2 to 8 parts, all named `join`. The first argument is always
 * the separator string, and the remaining arguments are the strings to be joined.
 */

/**
 * Use the first argument as a separator to join two strings.
 *
 * This predicate is overloaded to allow for 2 to 8 non-separator arguments.
 */
bindingset[sep, v1, v2]
string join(string sep, string v1, string v2) { result = v1 + sep + v2 }

/**
 * Use the first argument as a separator to join three strings.
 *
 * This predicate is overloaded to allow for 2 to 8 non-separator arguments.
 */
bindingset[sep, v1, v2, v3]
string join(string sep, string v1, string v2, string v3) { result = v1 + sep + v2 + sep + v3 }

/**
 * Use the first argument as a separator to join four strings.
 *
 * This predicate is overloaded to allow for 2 to 8 non-separator arguments.
 */
bindingset[sep, v1, v2, v3, v4]
string join(string sep, string v1, string v2, string v3, string v4) {
  result = v1 + sep + v2 + sep + v3 + sep + v4
}

/**
 * Use the first argument as a separator to join five strings.
 *
 * This predicate is overloaded to allow for 2 to 8 non-separator arguments.
 */
bindingset[sep, v1, v2, v3, v4, v5]
string join(string sep, string v1, string v2, string v3, string v4, string v5) {
  result = v1 + sep + v2 + sep + v3 + sep + v4 + sep + v5
}

/**
 * Use the first argument as a separator to join six strings.
 *
 * This predicate is overloaded to allow for 2 to 8 non-separator arguments.
 */
bindingset[sep, v1, v2, v3, v4, v5, v6]
string join(string sep, string v1, string v2, string v3, string v4, string v5, string v6) {
  result = v1 + sep + v2 + sep + v3 + sep + v4 + sep + v5 + sep + v6
}

/**
 * Use the first argument as a separator to join seven strings.
 *
 * This predicate is overloaded to allow for 2 to 8 non-separator arguments.
 */
bindingset[sep, v1, v2, v3, v4, v5, v6, v7]
string join(string sep, string v1, string v2, string v3, string v4, string v5, string v6, string v7) {
  result = v1 + sep + v2 + sep + v3 + sep + v4 + sep + v5 + sep + v6 + sep + v7
}

/**
 * Use the first argument as a separator to join eight strings.
 *
 * This predicate is overloaded to allow for 2 to 8 non-separator arguments.
 */
bindingset[sep, v1, v2, v3, v4, v5, v6, v7, v8]
string join(
  string sep, string v1, string v2, string v3, string v4, string v5, string v6, string v7, string v8
) {
  result = v1 + sep + v2 + sep + v3 + sep + v4 + sep + v5 + sep + v6 + sep + v7 + sep + v8
}
