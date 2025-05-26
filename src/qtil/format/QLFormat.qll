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
private import qtil.inheritance.Finitize
private import qtil.parameterization.Finalize
private import qtil.parameterization.SignaturePredicates
private import codeql.util.Location
private import qtil.locations.StringLocation
private import qtil.tuple.Pair
private import qtil.locations.OptionalLocation
private import qtil.locations.Locatable

module QlFormat<LocationSig Location, LocatableConfig<Location> LocConfig> {
  private class Locatable = LocConfig::Locatable;

  bindingset[elem]
  pragma[inline]
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
    pragma[inline_late]
    Template withParam(string key, string text) { result = str().replaceAll("{" + key + "}", text) }

    bindingset[this, key, text, elem]
    private Template withParamBase(string key, string text, StringLocation elem) {
      result = this + "$" + key + "$" + text + "$" + elem + "$"
    }

    bindingset[this, idx]
    predicate hasParam(string key, string text, string stringLocation, int idx) {
      exists(int dlridx |
        dlridx = idx * 4 and
        key = str().splitAt("$", dlridx + 1) and
        text = str().splitAt("$", dlridx + 2) and
        stringLocation = str().splitAt("$", dlridx + 3)
      )
    }

    bindingset[this]
    string getMessage() { result = str().substring(0, str().indexOf("$", 0, 0)) }
  }

  module Problem<Binary<Locatable, Template>::pred/2 problem> {
    private predicate templateExists(Template str) { problem(_, str) }

    /**
     * A performance related class to prevent CodeQL from splitting template strings multiple times.
     * At this point, there are a finite set of templates, so using a finite type is generally
     * preferable and more performant.
     */
    private class FiniteTemplate extends Final<Finitize<Template, templateExists/1>::Type>::Type
    {
      pragma[nomagic]
      predicate hasParam2(string key, int index, string text, string location) {
        // Perform the same concretization trick. There is a finite set of parameters within each
        // template, so we can use a finite type and get a large performance boost.
        "{" + key + "}" = this.str().regexpFind("\\{[a-zA-Z0-9_]+\\}", index, _) and
        super.hasParam(key, text, location, index)
      }
    }

    class Problem extends Final<Pair<Locatable, Template, problem/2>::Pair>::Type {
      Locatable getLocatable() { result = this.getFirst() }

      string getMessage() { result = getTemplate().getMessage() }

      FiniteTemplate getTemplate() { result = this.getSecond() }

      string getFormattedMessage() {
        result = getMessage().regexpReplaceAll("\\{[a-zA-Z0-9_]+\\}", "\\$@")
      }

      predicate hasParamIndex(int idx) { getTemplate().hasParam2(_, idx, _, _) }

      predicate hasFormattedParam(int idx, string str, string elem) {
        getTemplate().hasParam2(_, idx, str, elem)
      }
    }

    module Query {
      /** A predicate for usage with the FinitizedStringLocation module, for performance. */
      private predicate existsStrLoc(StringLocation str) {
        exists(Problem p | p.getTemplate().hasParam2(_, _, _, str))
      }

      // The problem predicate is now fully known, and the set of locations is finite. Use a finite
      // type to hold the locations to avoid redundant string splitting. This makes a huge
      // difference in performance.
      private class FiniteLocation = FinitizeStringLocation<existsStrLoc/1>::Location;

      private class OptionalLocation = OptionalLocation<FiniteLocation>::Location;

      bindingset[idx]
      private predicate getExtra(Problem problem, int idx, string str, OptionalLocation elem) {
        if problem.hasParamIndex(idx)
        then
          exists(StringLocation loc |
            problem.hasFormattedParam(idx, str, loc) and
            elem.asSome().toString() = loc
          )
        else (
          elem.isNone() and
          str = "[unused]"
        )
      }

      query predicate problems(
        Locatable loc, string msg, OptionalLocation elem1, string str1, OptionalLocation elem2,
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
