/**
 * A module for limiting the number of results reported per finding to at most `N`, while appending
 * an "and M more" suffix to the message when there are additional results beyond the limit.
 *
 * This is useful for queries that find multiple related entities per finding (such as fields,
 * parameters, or call sites) but where listing all of them would be too noisy. Instead, only the
 * top `N` entities are reported (ordered by `orderBy()`), and the message notes how many were
 * omitted.
 *
 * ## Usage
 *
 * Implement the `LimitResultsConfigSig` signature and instantiate the `LimitResults` module. Only
 * `problem` and `message` are required — `placeholderString`, `orderBy`, `maxResults`, and
 * `andMoreText` have sensible defaults. The instantiated module's `problems` query predicate is
 * automatically part of the query output without any `from`/`where`/`select` boilerplate:
 *
 * ```ql
 * module MyConfig implements LimitResultsConfigSig<MyFinding, MyEntity> {
 *   predicate problem(MyFinding finding, MyEntity entity) {
 *     entity = finding.getAnEntity()
 *   }
 *
 *   bindingset[remaining]
 *   string message(MyFinding finding, MyEntity entity, string remaining) {
 *     result = "Finding " + finding.getName() + " has entity $@" + remaining + "."
 *   }
 * }
 *
 * module Results = LimitResults<MyFinding, MyEntity, MyConfig>;
 * ```
 */

private import qtil.parameterization.SignatureTypes

/**
 * A signature for configuring the `LimitResults` module.
 *
 * Only `problem` and `message` must be implemented. The predicates `placeholderString`,
 * `orderBy`, `maxResults`, and `andMoreText` have defaults and may be overridden.
 */
signature module LimitResultsConfigSig<FiniteStringableType Finding, FiniteStringableType Entity> {
  /**
   * The relationship between findings and their associated entities.
   *
   * Defines which entities are relevant to a given finding. All entities satisfying this predicate
   * will be counted, but only the top `maxResults()` (ordered by `orderBy()`) will be reported.
   */
  predicate problem(Finding finding, Entity entity);

  /**
   * Builds the message for the finding, incorporating the "and N more" remaining string.
   *
   * The `remaining` parameter is either an empty string (when all entities are shown) or a string
   * like `" (and 2 more)"` when some entities are omitted. The message should embed `remaining`
   * appropriately, for example: `result = "Foo is broken" + remaining + "."`.
   */
  bindingset[remaining]
  string message(Finding finding, Entity entity, string remaining);

  /**
   * The display string for an entity.
   *
   * Used as the `entityStr` column in the `problems` query predicate output. Also used as the
   * default ordering key — see `orderBy`.
   *
   * Defaults to `entity.toString()`.
   */
  default string placeholderString(Entity entity) { result = entity.toString() }

  /**
   * The key to use when ordering entities within a finding (ascending).
   *
   * Entities with smaller order keys are reported first. When the total count exceeds
   * `maxResults()`, only the first `maxResults()` entities by this ordering are reported.
   *
   * Defaults to `placeholderString(entity)`.
   */
  default string orderBy(Entity entity) { result = placeholderString(entity) }

  /**
   * The maximum number of entities to report per finding.
   *
   * When the total number of entities for a finding exceeds this value, only the first
   * `maxResults()` entities (by `orderBy()`) are reported, and the message includes the
   * `andMoreText()` suffix indicating the number of omitted entities.
   *
   * Defaults to `3`.
   */
  default int maxResults() { result = 3 }

  /**
   * The suffix appended to the message when `n` entities are omitted.
   *
   * The parameter `n` is the number of omitted entities (i.e. `total - maxResults()`). Override
   * this to customise the "and N more" text, for example to use a different locale.
   *
   * Defaults to `" (and N more)"`.
   */
  bindingset[n]
  default string andMoreText(int n) { result = " (and " + n + " more)" }
}

/**
 * A module that limits the number of results reported per finding, appending an "and N more"
 * suffix when additional entities exist beyond the configured maximum.
 *
 * The `problems` query predicate is the main entry point for use in a query. When this module is
 * instantiated as `module Results = LimitResults<...>`, the predicate `Results::problems` is
 * automatically part of the query output — no `from`/`where`/`select` boilerplate is needed.
 *
 * See `LimitResultsConfigSig` for configuration details.
 */
module LimitResults<FiniteStringableType Finding, FiniteStringableType Entity, LimitResultsConfigSig<Finding, Entity> Config> {
  /**
   * A query predicate that reports findings alongside one of their top-ranked entities and a
   * formatted message. This is the primary way to use this module in a query.
   *
   * Each result tuple `(finding, msg, entity, entityStr)` corresponds to one of the top-ranked
   * entities for a finding. `entityStr` is `Config::placeholderString(entity)`, suitable for use
   * as the placeholder text in a `select` column alongside `entity`.
   *
   * At most `Config::maxResults()` entities are reported per finding.
   */
  query predicate problems(Finding finding, string msg, Entity entity, string entityStr) {
    hasLimitedResult(finding, entity, msg) and
    entityStr = Config::placeholderString(entity)
  }

  /**
   * Holds for each finding and one of its top-ranked entities, providing the formatted message.
   *
   * At most `Config::maxResults()` entities are reported per finding. They are selected by ranking
   * all entities satisfying `Config::problem(finding, entity)` in ascending order of
   * `Config::orderBy(entity)`, and taking those with rank <= `Config::maxResults()`.
   *
   * The `message` is produced by `Config::message(finding, entity, remaining)`, where `remaining`
   * is `Config::andMoreText(n)` (with `n = total - maxResults()`) if the total exceeds
   * `Config::maxResults()`, or `""` otherwise.
   */
  predicate hasLimitedResult(Finding finding, Entity entity, string message) {
    exists(int total, int ranked, string remaining |
      total = count(Entity e | Config::problem(finding, e)) and
      entity =
        rank[ranked](Entity e | Config::problem(finding, e) |
          e order by Config::orderBy(e)
        ) and
      ranked <= Config::maxResults() and
      (
        total > Config::maxResults() and
        remaining = Config::andMoreText(total - Config::maxResults())
        or
        total <= Config::maxResults() and remaining = ""
      ) and
      message = Config::message(finding, entity, remaining)
    )
  }
}
