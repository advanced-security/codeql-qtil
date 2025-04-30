/**
 * A module to create queries that have a message format with parameters and placeholders, without
 * worrying about the placeholder ordering.
 * 
 * Imagine implementing a query with the following types of results, where parenthesizes indicate
 * placeholders with links.
 *  - "Variable (foo) is passed to function (bar) with constant value (-1)."
 *  - "Constant value (-1) is passed to function (bar)."
 *  - "Variable (foo) is unused with constant value (-1)."
 * 
 * In an ordinary "problem" query, this might be tedious and involve something like the following,
 * before you can even start writing the query:
 * 
 * ```ql
 * abstract class TypeOfProblem extends ... {
 *   Element getElement();
 *   string getMessage();
 *   Element getPlacolderElement1();
 *   string getPlaceholderString1();
 *   Element getPlacolderElement2();
 *   string getPlaceholderString2();
 *   Element getPlacolderElement3();
 *   string getPlaceholderString3();
 * }
 * ...
 * from TypeOfProblem p where ...
 * select p.getElement(), p.getMessage(), p.getPlaceholderElement1(), p.getPlaceholderString1(),
 *   ...
 * ```
 * 
 * By using this module, you can skip the boilerplate and go straight to defining the types of
 * results your query will report:
 * 
 * ```
 * import qtil.cpp.format.QLFormat
 * predicate problem(Element elem, Template msg) {
 *   ... and
 *   msg = tpl("Variable {var} is passed to function {func} with constant value {val}.")
 *       .withParam("var", var.getName(), var)
 *       .withParam("func", func.getName(), func)
 *       .withParam("val", val.toString(), val)
 *   or ... and
 *   msg = tpl("Constant value {val} is passed to function {func}.")
 *      .withParam("func", func.getName(), func)
 *      .withParam("val", val.toString(), val)
 *   or ...
 * }
 * 
 * import Problem<problem/2>::Query
 * ```
 */
private import qtil.inheritance.UnderlyingString
private import qtil.parameterization.Finalize
private import qtil.parameterization.SignaturePredicates
private import codeql.util.Location
private import qtil.stringlocation.StringLocation
private import qtil.tuple.Pair

/**
 * A signature module that is required to configure the QlFormat module to understand locations
 * in the current query language.
 * 
 * This module should have preexisting implementations in the `qtil` modules for each language,
 * so that you don't have to implement it yourself, for instance, `qtil.cpp.format.QLFormat`.
 */
signature module LocatableConfig<LocationSig Location> {
  class Locatable {
    Location getLocation();

    string toString();
  }
}

module QlFormat<LocationSig Location, LocatableConfig<Location> LocConfig> {
  private class Locatable = LocConfig::Locatable;

  private StringLocation stringLocation(Locatable elem) {
    result = LocationToString<Location>::stringLocation(elem.getLocation())
  }

  bindingset[format]
  Template tpl(string format) { result = format }

  bindingset[this]
  class Template extends Final<UnderlyingString>::Type {

    bindingset[this, key, text, elem]
    Template withParam(string key, string text, Locatable elem) {
      result = withParamBase(key, text, stringLocation(elem))
    }

    bindingset[this, key, text]
    Template withParam(string key, string text) {
      result = str().replaceAll("{" + key + "}", text)
    }

    bindingset[this, key, text, elem]
    private Template withParamBase(string key, string text, StringLocation elem) {
      result = this + "$" + key + "$" + text + "$" + elem + "$"
    }

    bindingset[this, idx]
    predicate hasParam(string key, string text, StringLocation elem, int idx) {
      exists(int dlridx |
        dlridx = idx * 4 and
        key = str().substring(str().indexOf("$", dlridx, 0) + 1, str().indexOf("$", dlridx + 1, 0)) and
        text = str().substring(str().indexOf("$", dlridx + 1, 0) + 1, str().indexOf("$", dlridx + 2, 0)) and
        elem = str().substring(str().indexOf("$", dlridx + 2, 0) + 1, str().indexOf("$", dlridx + 3, 0))
      )
    }

    bindingset[this]
    predicate hasParam(string key, string text, StringLocation elem) {
      hasParam(key, text, elem, [0 .. 9])
    }

    bindingset[this]
    string getMessage() { result = str().substring(0, str().indexOf("$", 0, 0)) }
  }

  module Problem<Binary<Locatable, Template>::pred/2 problem> {
    bindingset[format, key]
    int getParamIndex(string format, string key) {
      "{" + key + "}" = format.regexpFind("\\{[a-zA-Z0-9_]+\\}", result, _)
    }

    class Problem extends Final<Pair<Locatable, Template, problem/2>::Pair>::Type {
      Locatable getLocatable() { result = this.getFirst() }

      string getMessage() {
        result = getTemplate().getMessage()
      }

      Template getTemplate() { result = this.getSecond() }

      string toString() { result = getTemplate() }

      string getFormattedMessage() {
        result = getMessage().regexpReplaceAll("\\{[a-zA-Z0-9_]+\\}", "\\$@")
      }

      bindingset[this, key, idx]
      predicate hasParamIndex(string key, int idx) { getParamIndex(getMessage(), key) = idx }

      bindingset[this, idx]
      predicate hasFormattedParam(int idx, string str, StringLocation elem) {
        exists(string key |
          hasParamIndex(key, idx) and
          getTemplate().hasParam(key, str, elem)
        )
      }
    }

    module Query {
      bindingset[problem, idx]
      predicate getExtra(Problem problem, int idx, string str, StringLocation elem) {
        if problem.hasFormattedParam(idx, _, _)
        then problem.hasFormattedParam(idx, str, elem)
        else (
          elem = stringLocation("", 0, 0, 0, 0) and
          str = "[unused]"
        )
      }

      query predicate problem(
        Locatable loc, string msg, StringLocation elem1, string str1, StringLocation elem2,
        string str2
      ) {
        exists(Problem p |
          p.getLocatable() = loc and
          p.getFormattedMessage() = msg and
          getExtra(p, 0, str1, elem1) and
          getExtra(p, 1, str2, elem2)
        )
      }
    }
  }
}
