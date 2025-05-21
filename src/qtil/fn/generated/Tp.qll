/**
 * GENERATED CODE. DO NOT MODIFY.
 */

private import qtil.parameterization.SignatureTypes
private import qtil.fn.FnTypes

/**
 * A module for transforming a "Tuple predicate" with 1 arguments.
 *
 * In qtil speak:
 *  - a "Function" (FnX) is a predicate with a bindingset[] on all of its arguments, and a result
 *  - a "TuplePredicate " (TpX) is a predicate with finite arguments and no result
 *  - a "Relation" (RelX) is a predicate with finite arguments and a finite result
 *  - a "Property" (PropX) is a predicate with a bindingset[] on all arguments no result
 *
 * Essentially, a tuple predicate `Tp<A, B, C>` represents a finite set of tuples `(a, b, c)`. This
 * module accepts a tuple predicate (`predicate p(A, B, C)`) as an input, and offers functional
 * programming features on top of it such as `map` and `filter`, as well as some relational algebra
 * features such as projection and joins.
 *
 * Example:
 * ```ql
 * predicate livesIn(Person p, City c) { c = p.getCity() }
 * string describe(Person p, City c) { result = p.getName() + " lives in " + c.getName() }
 *
 * // selects "Peter lives in New York", "Wanda lives in London", ...
 * select Tp2<Person, City, livesIn/2>::Map<string, describe/2>::find()
 * ```
 */
module Tp1<InfiniteStringableType A, TpType1<A>::tp/1 base> {
  /**
   * Get the set of first values in the set of tuples that satisfy the given predicate.
   */
  A first() { base(result) }

  /**
   * Get the set of first values in the set of tuples that satisfy the given predicate.
   */
  module First {
    import Tp1<A, first/0>
  }

  /**
   * Map a function over the tuples in this tuple set, and get a new tuple predicate back
   * representing the set of tuples after being transformed by that function.
   *
   * Sibling module of `Relate` (which takes a "relation" instead of a "function").
   *
   * Note that this implicitly performs a "flatMap," as the mapping function may return zero or
   * more than one result per tuple.
   *
   * Example:
   * ```ql
   * predicate livesIn(Person p, City c) { c = p.getCity() }
   * string describe(Person p, City c) { result = p.getName() + " lives in " + c.getName() }
   *
   * // selects "Peter lives in New York", "Wanda lives in London", ...
   * select Tp2<Person, City, livesIn/2>::Map<string, describe/2>::find()
   * ```
   */
  module Map<InfiniteStringableType R, FnType1<R, A>::fn/1 map> {
    /**
     * Get the result of mapping the function `map` over the set of tuples represented by this
     * tuple predicate.
     *
     * For mapping a "relation" (as opposed to a "function") over this tuple set, see `MapRelate`.
     */
    R find() {
      exists(A a |
        base(a) and
        result = map(a)
      )
    }
    // TODO: import ResultSet<R, find/0>
  }

  /**
   * Maps a relation over the tuples in this tuple set, and get a new tuple predicate back
   * representing the related values to the tuples in this set.
   *
   * Sibling module of `Map` (which takes a "function" instead of a "relation").
   *
   * Note that this implicitly performs an intersection with the domain tuple set of the given
   * relation.
   *
   * Example:
   * ```ql
   * predicate livesIn(Person p, City c) { c = p.getCity() }
   * Address hasMailingAddress(Person p, City c) { ... }
   *
   * // Selects the mailing addresses that correspond to the people, city in `livesIn`.
   * select Tp2<Person, City, livesIn/2>::Relate<Address, hasMailingAddress/2>::find()
   * ```
   *
   * To preserve `Person`, `City`, see `ExtendRelate`.
   */
  module Relate<InfiniteStringableType R, RelType1<R, A>::rel/1 r> {
    /**
     * Get the result of mapping the relation `r` over the set of tuples represented by this tuple
     * predicate.
     *
     * For mapping a "function" (as opposed to a "relation") over this tuple set, see `MapRelate`.
     */
    R find() {
      exists(A a |
        base(a) and
        result = r(a)
      )
    }
    // TODO: import ResultSet<R, find/0>
  }

  /**
   * An alias for `Map`, but the result is a "tuple set" (a predicate(A a) with one parameter and no
   * result) instead of a `ResultSet` (a predicate `R pred()` with no parameters and result `R`).
   *
   * Sibling module of `ProjectRelate1` (which takes a "relation" instead of a "function").
   *
   * See `Map` for more details.
   */
  module Project1<InfiniteStringableType R, FnType1<R, A>::fn/1 map> {
    /**
     * A predicate tuple that represents the result of a projection, from the input tuple
     * predicate, to a new tuple predicate with a single column derived from applying a tuple to the
     * given function `map`.
     *
     * For projecting this tuple by a "relation" (as opposed to a "function"), see `ProjectRelate`.
     */
    predicate tp(R related) {
      exists(A a |
        base(a) and
        related = map(a)
      )
    }
    // TODO: import Tp1<R, tp/1> ?
  }

  /**
   * An alias for `Relate`, but the result is a "tuple set" (a predicate(A a) with one parameter and no
   * result) instead of a `ResultSet` (a predicate `R pred()` with no parameters and result `R`).
   *
   * Sibling module of `Project1` (which takes a "function" instead of a "relation").
   *
   * See `Relate` for more details.
   */
  module ProjectRelate1<InfiniteStringableType R, RelType1<R, A>::rel/1 r> {
    /**
     * A predicate tuple that represents the result of a projection, from the input tuple
     * predicate, to a new tuple predicate with a single column derived from the given relation
     * `r`.
     *
     * For projecting this tuple by a "function" (as opposed to a "relation"), see `Project`.
     */
    predicate tp(R related) {
      exists(A a |
        base(a) and
        related = r(a)
      )
    }
    // TODO: import Tp1<R, tp/1> ?
  }

  /**
   * Project this tuple set to a new tuple set of 2 values per row, by using a set of
   * projection functions.
   *
   * Sibling module of `ProjectRelate2` (which takes a set of "relations" instead of "functions").
   *
   * Each project function accepts the values of a tuple from this tuple set, and returns a new
   * value, where the value returned by the nth function will become the nth column in the new tuple
   * set.
   *
   * For example, the following projection switches (first, last) names to (last, first) names.
   * ```ql
   * predicate firstLast(string first, string last) { exists(Person p | ... ) }
   *
   * import Tp2<string, string, firstLast/2>
   *   ::Project2<string, string,
   *       Tuples2<string, string>::getFirst/2,
   *       Tuples2<string, string>::getSecond/2>
   *   as LastFirst
   *
   * // Selects ("Curie", "Maria"), ("Einstein", "Albert"), etc.
   * from string a, string b where LastFirst::tp(a, b) select a, b
   * ```
   */
  module Project2<
    InfiniteStringableType A0, InfiniteStringableType B0, FnType1<A0, A>::fn/1 pja0,
    FnType1<B0, A>::fn/1 pjb0>
  {
    predicate tp(A0 a0, B0 b0) {
      exists(A a |
        base(a) and
        a0 = pja0(a) and
        b0 = pjb0(a)
      )
    }
  }

  /**
   * Project this tuple set to a new tuple set of 2 values per row, by using a set of
   * relations.
   *
   * Sibling module of `Project2` (which takes a set of "functions" instead of "relations").
   *
   * Each projection relation accepts the values of a tuple from this tuple set, and returns a new
   * value, where the value held by the nth relation will become the nth column in the new tuple
   * set.
   *
   * For example, the following projection switches (first, last) names to (last, first) names.
   * ```ql
   * predicate siblings(Person a, Person b) { ... }
   * Person motherOf(Person a, Person b) { ... }
   * Person fatherOf(Person a, Person b) { ... }
   *
   * import Tp2<Person, Person, siblings/2>
   *     ::Project2<Person, Person, motherOf/2, fatherOf/2>
   *   as SiblingParents
   *
   * // Selects (mother, father) that have a pair of children
   * from Person mother, Person father where SiblingParents::tp(mother, father)
   * select mother, father
   * ```
   */
  module ProjectRelate2<
    InfiniteStringableType A0, InfiniteStringableType B0, RelType1<A0, A>::rel/1 pja0,
    RelType1<B0, A>::rel/1 pjb0>
  {
    predicate tp(A0 a0, B0 b0) {
      exists(A a |
        base(a) and
        a0 = pja0(a) and
        b0 = pjb0(a)
      )
    }
  }

  /**
   * Project this tuple set to a new tuple set of 3 values per row, by using a set of
   * projection functions.
   *
   * Sibling module of `ProjectRelate3` (which takes a set of "relations" instead of "functions").
   *
   * Each project function accepts the values of a tuple from this tuple set, and returns a new
   * value, where the value returned by the nth function will become the nth column in the new tuple
   * set.
   *
   * For example, the following projection switches (first, last) names to (last, first) names.
   * ```ql
   * predicate firstLast(string first, string last) { exists(Person p | ... ) }
   *
   * import Tp2<string, string, firstLast/2>
   *   ::Project2<string, string,
   *       Tuples2<string, string>::getFirst/2,
   *       Tuples2<string, string>::getSecond/2>
   *   as LastFirst
   *
   * // Selects ("Curie", "Maria"), ("Einstein", "Albert"), etc.
   * from string a, string b where LastFirst::tp(a, b) select a, b
   * ```
   */
  module Project3<
    InfiniteStringableType A0, InfiniteStringableType B0, InfiniteStringableType C0,
    FnType1<A0, A>::fn/1 pja0, FnType1<B0, A>::fn/1 pjb0, FnType1<C0, A>::fn/1 pjc0>
  {
    predicate tp(A0 a0, B0 b0, C0 c0) {
      exists(A a |
        base(a) and
        a0 = pja0(a) and
        b0 = pjb0(a) and
        c0 = pjc0(a)
      )
    }
  }

  /**
   * Project this tuple set to a new tuple set of 3 values per row, by using a set of
   * relations.
   *
   * Sibling module of `Project3` (which takes a set of "functions" instead of "relations").
   *
   * Each projection relation accepts the values of a tuple from this tuple set, and returns a new
   * value, where the value held by the nth relation will become the nth column in the new tuple
   * set.
   *
   * For example, the following projection switches (first, last) names to (last, first) names.
   * ```ql
   * predicate siblings(Person a, Person b) { ... }
   * Person motherOf(Person a, Person b) { ... }
   * Person fatherOf(Person a, Person b) { ... }
   *
   * import Tp2<Person, Person, siblings/2>
   *     ::Project2<Person, Person, motherOf/2, fatherOf/2>
   *   as SiblingParents
   *
   * // Selects (mother, father) that have a pair of children
   * from Person mother, Person father where SiblingParents::tp(mother, father)
   * select mother, father
   * ```
   */
  module ProjectRelate3<
    InfiniteStringableType A0, InfiniteStringableType B0, InfiniteStringableType C0,
    RelType1<A0, A>::rel/1 pja0, RelType1<B0, A>::rel/1 pjb0, RelType1<C0, A>::rel/1 pjc0>
  {
    predicate tp(A0 a0, B0 b0, C0 c0) {
      exists(A a |
        base(a) and
        a0 = pja0(a) and
        b0 = pjb0(a) and
        c0 = pjc0(a)
      )
    }
  }

  /**
   * Project this tuple set to a new tuple set of 4 values per row, by using a set of
   * projection functions.
   *
   * Sibling module of `ProjectRelate4` (which takes a set of "relations" instead of "functions").
   *
   * Each project function accepts the values of a tuple from this tuple set, and returns a new
   * value, where the value returned by the nth function will become the nth column in the new tuple
   * set.
   *
   * For example, the following projection switches (first, last) names to (last, first) names.
   * ```ql
   * predicate firstLast(string first, string last) { exists(Person p | ... ) }
   *
   * import Tp2<string, string, firstLast/2>
   *   ::Project2<string, string,
   *       Tuples2<string, string>::getFirst/2,
   *       Tuples2<string, string>::getSecond/2>
   *   as LastFirst
   *
   * // Selects ("Curie", "Maria"), ("Einstein", "Albert"), etc.
   * from string a, string b where LastFirst::tp(a, b) select a, b
   * ```
   */
  module Project4<
    InfiniteStringableType A0, InfiniteStringableType B0, InfiniteStringableType C0,
    InfiniteStringableType D0, FnType1<A0, A>::fn/1 pja0, FnType1<B0, A>::fn/1 pjb0,
    FnType1<C0, A>::fn/1 pjc0, FnType1<D0, A>::fn/1 pjd0>
  {
    predicate tp(A0 a0, B0 b0, C0 c0, D0 d0) {
      exists(A a |
        base(a) and
        a0 = pja0(a) and
        b0 = pjb0(a) and
        c0 = pjc0(a) and
        d0 = pjd0(a)
      )
    }
  }

  /**
   * Project this tuple set to a new tuple set of 4 values per row, by using a set of
   * relations.
   *
   * Sibling module of `Project4` (which takes a set of "functions" instead of "relations").
   *
   * Each projection relation accepts the values of a tuple from this tuple set, and returns a new
   * value, where the value held by the nth relation will become the nth column in the new tuple
   * set.
   *
   * For example, the following projection switches (first, last) names to (last, first) names.
   * ```ql
   * predicate siblings(Person a, Person b) { ... }
   * Person motherOf(Person a, Person b) { ... }
   * Person fatherOf(Person a, Person b) { ... }
   *
   * import Tp2<Person, Person, siblings/2>
   *     ::Project2<Person, Person, motherOf/2, fatherOf/2>
   *   as SiblingParents
   *
   * // Selects (mother, father) that have a pair of children
   * from Person mother, Person father where SiblingParents::tp(mother, father)
   * select mother, father
   * ```
   */
  module ProjectRelate4<
    InfiniteStringableType A0, InfiniteStringableType B0, InfiniteStringableType C0,
    InfiniteStringableType D0, RelType1<A0, A>::rel/1 pja0, RelType1<B0, A>::rel/1 pjb0,
    RelType1<C0, A>::rel/1 pjc0, RelType1<D0, A>::rel/1 pjd0>
  {
    predicate tp(A0 a0, B0 b0, C0 c0, D0 d0) {
      exists(A a |
        base(a) and
        a0 = pja0(a) and
        b0 = pjb0(a) and
        c0 = pjc0(a) and
        d0 = pjd0(a)
      )
    }
  }

  /**
   * Project this tuple set to a new tuple set of 5 values per row, by using a set of
   * projection functions.
   *
   * Sibling module of `ProjectRelate5` (which takes a set of "relations" instead of "functions").
   *
   * Each project function accepts the values of a tuple from this tuple set, and returns a new
   * value, where the value returned by the nth function will become the nth column in the new tuple
   * set.
   *
   * For example, the following projection switches (first, last) names to (last, first) names.
   * ```ql
   * predicate firstLast(string first, string last) { exists(Person p | ... ) }
   *
   * import Tp2<string, string, firstLast/2>
   *   ::Project2<string, string,
   *       Tuples2<string, string>::getFirst/2,
   *       Tuples2<string, string>::getSecond/2>
   *   as LastFirst
   *
   * // Selects ("Curie", "Maria"), ("Einstein", "Albert"), etc.
   * from string a, string b where LastFirst::tp(a, b) select a, b
   * ```
   */
  module Project5<
    InfiniteStringableType A0, InfiniteStringableType B0, InfiniteStringableType C0,
    InfiniteStringableType D0, InfiniteStringableType E0, FnType1<A0, A>::fn/1 pja0,
    FnType1<B0, A>::fn/1 pjb0, FnType1<C0, A>::fn/1 pjc0, FnType1<D0, A>::fn/1 pjd0,
    FnType1<E0, A>::fn/1 pje0>
  {
    predicate tp(A0 a0, B0 b0, C0 c0, D0 d0, E0 e0) {
      exists(A a |
        base(a) and
        a0 = pja0(a) and
        b0 = pjb0(a) and
        c0 = pjc0(a) and
        d0 = pjd0(a) and
        e0 = pje0(a)
      )
    }
  }

  /**
   * Project this tuple set to a new tuple set of 5 values per row, by using a set of
   * relations.
   *
   * Sibling module of `Project5` (which takes a set of "functions" instead of "relations").
   *
   * Each projection relation accepts the values of a tuple from this tuple set, and returns a new
   * value, where the value held by the nth relation will become the nth column in the new tuple
   * set.
   *
   * For example, the following projection switches (first, last) names to (last, first) names.
   * ```ql
   * predicate siblings(Person a, Person b) { ... }
   * Person motherOf(Person a, Person b) { ... }
   * Person fatherOf(Person a, Person b) { ... }
   *
   * import Tp2<Person, Person, siblings/2>
   *     ::Project2<Person, Person, motherOf/2, fatherOf/2>
   *   as SiblingParents
   *
   * // Selects (mother, father) that have a pair of children
   * from Person mother, Person father where SiblingParents::tp(mother, father)
   * select mother, father
   * ```
   */
  module ProjectRelate5<
    InfiniteStringableType A0, InfiniteStringableType B0, InfiniteStringableType C0,
    InfiniteStringableType D0, InfiniteStringableType E0, RelType1<A0, A>::rel/1 pja0,
    RelType1<B0, A>::rel/1 pjb0, RelType1<C0, A>::rel/1 pjc0, RelType1<D0, A>::rel/1 pjd0,
    RelType1<E0, A>::rel/1 pje0>
  {
    predicate tp(A0 a0, B0 b0, C0 c0, D0 d0, E0 e0) {
      exists(A a |
        base(a) and
        a0 = pja0(a) and
        b0 = pjb0(a) and
        c0 = pjc0(a) and
        d0 = pjd0(a) and
        e0 = pje0(a)
      )
    }
  }

  /**
   * Project this tuple set to a new tuple set of 6 values per row, by using a set of
   * projection functions.
   *
   * Sibling module of `ProjectRelate6` (which takes a set of "relations" instead of "functions").
   *
   * Each project function accepts the values of a tuple from this tuple set, and returns a new
   * value, where the value returned by the nth function will become the nth column in the new tuple
   * set.
   *
   * For example, the following projection switches (first, last) names to (last, first) names.
   * ```ql
   * predicate firstLast(string first, string last) { exists(Person p | ... ) }
   *
   * import Tp2<string, string, firstLast/2>
   *   ::Project2<string, string,
   *       Tuples2<string, string>::getFirst/2,
   *       Tuples2<string, string>::getSecond/2>
   *   as LastFirst
   *
   * // Selects ("Curie", "Maria"), ("Einstein", "Albert"), etc.
   * from string a, string b where LastFirst::tp(a, b) select a, b
   * ```
   */
  module Project6<
    InfiniteStringableType A0, InfiniteStringableType B0, InfiniteStringableType C0,
    InfiniteStringableType D0, InfiniteStringableType E0, InfiniteStringableType F0,
    FnType1<A0, A>::fn/1 pja0, FnType1<B0, A>::fn/1 pjb0, FnType1<C0, A>::fn/1 pjc0,
    FnType1<D0, A>::fn/1 pjd0, FnType1<E0, A>::fn/1 pje0, FnType1<F0, A>::fn/1 pjf0>
  {
    predicate tp(A0 a0, B0 b0, C0 c0, D0 d0, E0 e0, F0 f0) {
      exists(A a |
        base(a) and
        a0 = pja0(a) and
        b0 = pjb0(a) and
        c0 = pjc0(a) and
        d0 = pjd0(a) and
        e0 = pje0(a) and
        f0 = pjf0(a)
      )
    }
  }

  /**
   * Project this tuple set to a new tuple set of 6 values per row, by using a set of
   * relations.
   *
   * Sibling module of `Project6` (which takes a set of "functions" instead of "relations").
   *
   * Each projection relation accepts the values of a tuple from this tuple set, and returns a new
   * value, where the value held by the nth relation will become the nth column in the new tuple
   * set.
   *
   * For example, the following projection switches (first, last) names to (last, first) names.
   * ```ql
   * predicate siblings(Person a, Person b) { ... }
   * Person motherOf(Person a, Person b) { ... }
   * Person fatherOf(Person a, Person b) { ... }
   *
   * import Tp2<Person, Person, siblings/2>
   *     ::Project2<Person, Person, motherOf/2, fatherOf/2>
   *   as SiblingParents
   *
   * // Selects (mother, father) that have a pair of children
   * from Person mother, Person father where SiblingParents::tp(mother, father)
   * select mother, father
   * ```
   */
  module ProjectRelate6<
    InfiniteStringableType A0, InfiniteStringableType B0, InfiniteStringableType C0,
    InfiniteStringableType D0, InfiniteStringableType E0, InfiniteStringableType F0,
    RelType1<A0, A>::rel/1 pja0, RelType1<B0, A>::rel/1 pjb0, RelType1<C0, A>::rel/1 pjc0,
    RelType1<D0, A>::rel/1 pjd0, RelType1<E0, A>::rel/1 pje0, RelType1<F0, A>::rel/1 pjf0>
  {
    predicate tp(A0 a0, B0 b0, C0 c0, D0 d0, E0 e0, F0 f0) {
      exists(A a |
        base(a) and
        a0 = pja0(a) and
        b0 = pjb0(a) and
        c0 = pjc0(a) and
        d0 = pjd0(a) and
        e0 = pje0(a) and
        f0 = pjf0(a)
      )
    }
  }

  /**
   * Maps the set of first values in the set of tuples that satisfy the given predicate,
   * against a mapper function.
   *
   * Sibling function of `MapRelateFirst`, which operates on "relations" instead of
   * "functions."
   *
   * Example:
   * ```ql
   * predicate employs(Company company, Person person) { ... }
   *
   * // Selects the ages of employed People.
   * select Tp2<Company, Person, employs/2>
   *   ::MapSecond<int, getAge/1>
   *   ::find()
   * ```
   */
  module MapFirst<InfiniteStringableType R, FnType1<R, A>::fn/1 map> {
    R find() {
      exists(A a |
        base(a) and
        result = map(a)
      )
    }
  }

  /**
   * Maps the set of first values in the set of tuples that satisfy the given predicate,
   * against a mapper relation.
   *
   * Sibling function of `MapFirst`, which operates on "functions" instead of
   * "relations."
   *
   * Example:
   * ```ql
   * predicate employs(Company company, Person person) { ... }
   * Pet getPets(Person p) { ... }
   *
   * // Selects the pets of employed People.
   * select Tp2<Company, Person, employs/2>
   *   ::MapRelateSecond<Pet, getPets/1>
   *   ::find()
   * ```
   */
  module MapRelateFirst<InfiniteStringableType R, RelType1<R, A>::rel/1 map> {
    R find() {
      exists(A a |
        base(a) and
        result = map(a)
      )
    }
  }

  /**
   * Extend this tuple predicate to have an additional column, by intersecting it with a tuple
   * predicate with one additional parameter and all existing matching.
   */
  module ExtendIntersect<InfiniteStringableType Z, TpType2<A, Z>::tp/2 tp2> {
    predicate tp(A a, Z z) {
      base(a) and
      tp2(a, z)
    }
  }

  /**
   * Extend this tuple predicate to have an additional column, by running a provided function over
   * each tuple in this predicate's tuple set, and using the result of that function as the new
   * column.
   *
   * Sibling module of `ExtendByRelation`, which takes a "relation" instead of a "function."
   */
  module ExtendByFn<InfiniteStringableType R, FnType1<R, A>::fn/1 ext> {
    predicate tp(A a, R r) {
      base(a) and
      r = ext(a)
    }
  }

  /**
   * Extend this tuple predicate to have an additional column, by running a provided relation over
   * each tuple in this predicate's tuple set, and using the result of that relation as the new
   * column.
   *
   * Sibling module of `ExtendByFn`, which takes a "function" instead of a "relation."
   */
  module ExtendByRelation<InfiniteStringableType R, RelType1<R, A>::rel/1 ext> {
    predicate tp(A a, R r) {
      base(a) and
      r = ext(a)
    }
  }

  /**
   * Maps the set of first values in the set of tuples that satisfy the given predicate,
   * against a mapper function, and use the result to add a column to this tuple set.
   *
   * Sibling function of `ExtendRelateFirst`, which operates on "relations" instead of
   * "functions."
   *
   * Example:
   * ```ql
   * predicate hasName(Person person, string name) { ... }
   * string getInitials(string name) { ... }
   *
   * // Selects (person, name, initials)
   * import Tp2<Person, string, hasName/2>
   *   ::ExtendMapSecond<string, getInitials/1>
   *   ::Query
   * ```
   */
  module ExtendMapFirst<InfiniteStringableType R, FnType1<R, A>::fn/1 map> {
    predicate tp(A a, R r) {
      base(a) and
      r = map(a)
    }
  }

  /**
   * Maps the set of first values in the set of tuples that satisfy the given predicate,
   * against a mapper function, and use the result to add a column to this tuple set.
   *
   * Sibling function of `ExtendRelateFirst`, which operates on "relations" instead of
   * "functions."
   *
   * Example:
   * ```ql
   * predicate employs(Company company, Person person) { ... }
   * Address hasAddress(Person p) { ... }
   *
   * // Selects (company, person, age) for all employed people.
   * import Tp2<Company, Person, employs/2>
   *   ::ExtendRelateSecond<getAge/1>
   *   ::Query
   * ```
   */
  module ExtendRelateFirst<InfiniteStringableType R, RelType1<R, A>::rel/1 map> {
    predicate tp(A a, R r) {
      base(a) and
      r = map(a)
    }
  }

  /**
   * Takes a property which filters the contents of the current tuple set and produces a new one.
   *
   * Sibling predicate of `intersect`, which takes a "tuple predicate" instead of a "property."
   */
  module Filter<PropType1<A>::prop/1 flt> {
    predicate tp(A a) {
      flt(a) and
      base(a)
    }
  }

  /**
   * Takes a tuple set and intersects it with the current tuple set to produce a new one.
   *
   * Sibling predicate of `filter`, which takes a "property" instead of a "tuple set."
   */
  module Intersect<TpType1<A>::tp/1 tp2> {
    predicate tp(A a) {
      tp2(a) and
      base(a)
    }
  }

  /**
   * Creates a new tuple predicate that is a union of the current tuple set and the given one.
   */
  module Union<TpType1<A>::tp/1 tp2> {
    predicate tp(A a) {
      tp2(a) or
      base(a)
    }
  }

  /**
   * Creates a new tuple predicate that holds the elements only in the current tuple set, not the
   * given one.
   */
  module Difference<TpType1<A>::tp/1 tp2> {
    predicate tp(A a) {
      base(a) and
      not tp2(a)
    }
  }

  /**
   * Checks if (a, b, c, ...) is a member of the tuple set represented by this "tuple predicate."
   */
  predicate contains(A a) { base(a) }

  /**
   * A module with a single predicate, `holds`, that holds if the current tuple set contains all
   * of the tuples of the given tuple predicate `tp2`.
   */
  module ContainsAll<TpType1<A>::tp/1 tp2> {
    predicate holds() { forall(A a | tp2(a) | base(a)) }
  }

  /**
   * A module with a single predicate, `holds`, that holds if the current tuple set contains any
   * of the tuples of the given tuple predicate `tp2`.
   *
   * Sibling predicate of `AnyHoldsFor`, which takes a "property" instead of a "tuple predicate."
   */
  module ContainsAny<TpType1<A>::tp/1 tp2> {
    predicate holds() {
      exists(A a |
        tp2(a) and
        base(a)
      )
    }
  }

  /**
   * A module with a single predicate, `holds`, that holds if any of the tuples in the current tuple
   * satisfy the given property `prop`.
   *
   * Sibling predicate of `ContainsAny`, which takes a "tuple predicate" instead of a "property."
   */
  module AnyHoldsFor<PropType1<A>::prop/1 prop> {
    predicate holds() {
      exists(A a |
        base(a) and
        prop(a)
      )
    }
  }

  /**
   * A module with a single predicate, `holds`, that holds if all of the tuples in the current tuple
   * set satisfy the given property `prop`.
   *
   * Sibling predicate of `ContainedBy` which takes a "tuple predicate" instead of a "property."
   */
  module AllHoldsFor<PropType1<A>::prop/1 prop> {
    predicate holds() { forall(A a | base(a) | prop(a)) }
  }

  /**
   * A module with a single predicate, `holds`, that holds if all of the tuples in the current tuple
   * set satisfy the given property `prop`.
   *
   * Sibling predicate of `AllHoldsFor`, which takes a "property" instead of a "tuple predicate."
   */
  module ContainedBy<TpType1<A>::tp/1 tp2> {
    predicate holds() { forall(A a | base(a) | tp2(a)) }
  }

  /**
   * A basic, but very flexible join operation, taking a new tuple predicate to join as well as a
   * function for each that maps it to a value of type J.
   *
   * For instance, given sets of tuples `(a, b, c)` and `(d, e)` and join functions `(a, b, c) -> a`
   * and `(d, e) -> e`, this module will join both tuple sets on `a = e`.
   */
  module Join2ByFns<
    InfiniteStringableType J, InfiniteStringableType A0, InfiniteStringableType B0,
    TpType2<A0, B0>::tp/2 tp2, FnType2<J, A0, B0>::fn/2 tp2j, FnType1<J, A>::fn/1 tpj>
  {
    predicate tp(A a, A0 a0, B0 b0) {
      base(a) and
      tp2(a0, b0) and
      tpj(a) = tp2j(a0, b0)
    }
  }

  /**
   * A basic, but very flexible join operation, taking a new tuple predicate to join as well as a
   * function for each that maps it to a value of type J.
   *
   * For instance, given sets of tuples `(a, b, c)` and `(d, e)` and join functions `(a, b, c) -> a`
   * and `(d, e) -> e`, this module will join both tuple sets on `a = e`.
   */
  module Join3ByFns<
    InfiniteStringableType J, InfiniteStringableType A0, InfiniteStringableType B0,
    InfiniteStringableType C0, TpType3<A0, B0, C0>::tp/3 tp2, FnType3<J, A0, B0, C0>::fn/3 tp2j,
    FnType1<J, A>::fn/1 tpj>
  {
    predicate tp(A a, A0 a0, B0 b0, C0 c0) {
      base(a) and
      tp2(a0, b0, c0) and
      tpj(a) = tp2j(a0, b0, c0)
    }
  }

  /**
   * A basic, but very flexible join operation, taking a new tuple predicate to join as well as a
   * function for each that maps it to a value of type J.
   *
   * For instance, given sets of tuples `(a, b, c)` and `(d, e)` and join functions `(a, b, c) -> a`
   * and `(d, e) -> e`, this module will join both tuple sets on `a = e`.
   */
  module Join4ByFns<
    InfiniteStringableType J, InfiniteStringableType A0, InfiniteStringableType B0,
    InfiniteStringableType C0, InfiniteStringableType D0, TpType4<A0, B0, C0, D0>::tp/4 tp2,
    FnType4<J, A0, B0, C0, D0>::fn/4 tp2j, FnType1<J, A>::fn/1 tpj>
  {
    predicate tp(A a, A0 a0, B0 b0, C0 c0, D0 d0) {
      base(a) and
      tp2(a0, b0, c0, d0) and
      tpj(a) = tp2j(a0, b0, c0, d0)
    }
  }

  /**
   * A basic, but very flexible join operation, taking a new tuple predicate to join as well as a
   * function for each that maps it to a value of type J.
   *
   * For instance, given sets of tuples `(a, b, c)` and `(d, e)` and join functions `(a, b, c) -> a`
   * and `(d, e) -> e`, this module will join both tuple sets on `a = e`.
   */
  module Join5ByFns<
    InfiniteStringableType J, InfiniteStringableType A0, InfiniteStringableType B0,
    InfiniteStringableType C0, InfiniteStringableType D0, InfiniteStringableType E0,
    TpType5<A0, B0, C0, D0, E0>::tp/5 tp2, FnType5<J, A0, B0, C0, D0, E0>::fn/5 tp2j,
    FnType1<J, A>::fn/1 tpj>
  {
    predicate tp(A a, A0 a0, B0 b0, C0 c0, D0 d0, E0 e0) {
      base(a) and
      tp2(a0, b0, c0, d0, e0) and
      tpj(a) = tp2j(a0, b0, c0, d0, e0)
    }
  }

  /**
   * Count the number of tuples in this tuple set.
   */
  int doCount() { result = count(A a | base(a)) }

  /**
   * Query for the contents of this tuple, by defining a query predicate `tpQuery` to import.
   */
  module Query {
    query predicate tpQuery(A a) { base(a) }
  }
}

/**
 * A module for transforming a "Tuple predicate" with 2 arguments.
 *
 * In qtil speak:
 *  - a "Function" (FnX) is a predicate with a bindingset[] on all of its arguments, and a result
 *  - a "TuplePredicate " (TpX) is a predicate with finite arguments and no result
 *  - a "Relation" (RelX) is a predicate with finite arguments and a finite result
 *  - a "Property" (PropX) is a predicate with a bindingset[] on all arguments no result
 *
 * Essentially, a tuple predicate `Tp<A, B, C>` represents a finite set of tuples `(a, b, c)`. This
 * module accepts a tuple predicate (`predicate p(A, B, C)`) as an input, and offers functional
 * programming features on top of it such as `map` and `filter`, as well as some relational algebra
 * features such as projection and joins.
 *
 * Example:
 * ```ql
 * predicate livesIn(Person p, City c) { c = p.getCity() }
 * string describe(Person p, City c) { result = p.getName() + " lives in " + c.getName() }
 *
 * // selects "Peter lives in New York", "Wanda lives in London", ...
 * select Tp2<Person, City, livesIn/2>::Map<string, describe/2>::find()
 * ```
 */
module Tp2<InfiniteStringableType A, InfiniteStringableType B, TpType2<A, B>::tp/2 base> {
  /**
   * Get the set of first values in the set of tuples that satisfy the given predicate.
   */
  A first() { base(result, _) }

  /**
   * Get the set of first values in the set of tuples that satisfy the given predicate.
   */
  module First {
    import Tp2<A, B, first/0>
  }

  /**
   * Get the set of second values in the set of tuples that satisfy the given predicate.
   */
  B second() { base(_, result) }

  /**
   * Get the set of second values in the set of tuples that satisfy the given predicate.
   */
  module Second {
    import Tp2<A, B, second/0>
  }

  /**
   * Map a function over the tuples in this tuple set, and get a new tuple predicate back
   * representing the set of tuples after being transformed by that function.
   *
   * Sibling module of `Relate` (which takes a "relation" instead of a "function").
   *
   * Note that this implicitly performs a "flatMap," as the mapping function may return zero or
   * more than one result per tuple.
   *
   * Example:
   * ```ql
   * predicate livesIn(Person p, City c) { c = p.getCity() }
   * string describe(Person p, City c) { result = p.getName() + " lives in " + c.getName() }
   *
   * // selects "Peter lives in New York", "Wanda lives in London", ...
   * select Tp2<Person, City, livesIn/2>::Map<string, describe/2>::find()
   * ```
   */
  module Map<InfiniteStringableType R, FnType2<R, A, B>::fn/2 map> {
    /**
     * Get the result of mapping the function `map` over the set of tuples represented by this
     * tuple predicate.
     *
     * For mapping a "relation" (as opposed to a "function") over this tuple set, see `MapRelate`.
     */
    R find() {
      exists(A a, B b |
        base(a, b) and
        result = map(a, b)
      )
    }
    // TODO: import ResultSet<R, find/0>
  }

  /**
   * Maps a relation over the tuples in this tuple set, and get a new tuple predicate back
   * representing the related values to the tuples in this set.
   *
   * Sibling module of `Map` (which takes a "function" instead of a "relation").
   *
   * Note that this implicitly performs an intersection with the domain tuple set of the given
   * relation.
   *
   * Example:
   * ```ql
   * predicate livesIn(Person p, City c) { c = p.getCity() }
   * Address hasMailingAddress(Person p, City c) { ... }
   *
   * // Selects the mailing addresses that correspond to the people, city in `livesIn`.
   * select Tp2<Person, City, livesIn/2>::Relate<Address, hasMailingAddress/2>::find()
   * ```
   *
   * To preserve `Person`, `City`, see `ExtendRelate`.
   */
  module Relate<InfiniteStringableType R, RelType2<R, A, B>::rel/2 r> {
    /**
     * Get the result of mapping the relation `r` over the set of tuples represented by this tuple
     * predicate.
     *
     * For mapping a "function" (as opposed to a "relation") over this tuple set, see `MapRelate`.
     */
    R find() {
      exists(A a, B b |
        base(a, b) and
        result = r(a, b)
      )
    }
    // TODO: import ResultSet<R, find/0>
  }

  /**
   * An alias for `Map`, but the result is a "tuple set" (a predicate(A a) with one parameter and no
   * result) instead of a `ResultSet` (a predicate `R pred()` with no parameters and result `R`).
   *
   * Sibling module of `ProjectRelate1` (which takes a "relation" instead of a "function").
   *
   * See `Map` for more details.
   */
  module Project1<InfiniteStringableType R, FnType2<R, A, B>::fn/2 map> {
    /**
     * A predicate tuple that represents the result of a projection, from the input tuple
     * predicate, to a new tuple predicate with a single column derived from applying a tuple to the
     * given function `map`.
     *
     * For projecting this tuple by a "relation" (as opposed to a "function"), see `ProjectRelate`.
     */
    predicate tp(R related) {
      exists(A a, B b |
        base(a, b) and
        related = map(a, b)
      )
    }
    // TODO: import Tp1<R, tp/1> ?
  }

  /**
   * An alias for `Relate`, but the result is a "tuple set" (a predicate(A a) with one parameter and no
   * result) instead of a `ResultSet` (a predicate `R pred()` with no parameters and result `R`).
   *
   * Sibling module of `Project1` (which takes a "function" instead of a "relation").
   *
   * See `Relate` for more details.
   */
  module ProjectRelate1<InfiniteStringableType R, RelType2<R, A, B>::rel/2 r> {
    /**
     * A predicate tuple that represents the result of a projection, from the input tuple
     * predicate, to a new tuple predicate with a single column derived from the given relation
     * `r`.
     *
     * For projecting this tuple by a "function" (as opposed to a "relation"), see `Project`.
     */
    predicate tp(R related) {
      exists(A a, B b |
        base(a, b) and
        related = r(a, b)
      )
    }
    // TODO: import Tp1<R, tp/1> ?
  }

  /**
   * Project this tuple set to a new tuple set of 2 values per row, by using a set of
   * projection functions.
   *
   * Sibling module of `ProjectRelate2` (which takes a set of "relations" instead of "functions").
   *
   * Each project function accepts the values of a tuple from this tuple set, and returns a new
   * value, where the value returned by the nth function will become the nth column in the new tuple
   * set.
   *
   * For example, the following projection switches (first, last) names to (last, first) names.
   * ```ql
   * predicate firstLast(string first, string last) { exists(Person p | ... ) }
   *
   * import Tp2<string, string, firstLast/2>
   *   ::Project2<string, string,
   *       Tuples2<string, string>::getFirst/2,
   *       Tuples2<string, string>::getSecond/2>
   *   as LastFirst
   *
   * // Selects ("Curie", "Maria"), ("Einstein", "Albert"), etc.
   * from string a, string b where LastFirst::tp(a, b) select a, b
   * ```
   */
  module Project2<
    InfiniteStringableType A0, InfiniteStringableType B0, FnType2<A0, A, B>::fn/2 pja0,
    FnType2<B0, A, B>::fn/2 pjb0>
  {
    predicate tp(A0 a0, B0 b0) {
      exists(A a, B b |
        base(a, b) and
        a0 = pja0(a, b) and
        b0 = pjb0(a, b)
      )
    }
  }

  /**
   * Project this tuple set to a new tuple set of 2 values per row, by using a set of
   * relations.
   *
   * Sibling module of `Project2` (which takes a set of "functions" instead of "relations").
   *
   * Each projection relation accepts the values of a tuple from this tuple set, and returns a new
   * value, where the value held by the nth relation will become the nth column in the new tuple
   * set.
   *
   * For example, the following projection switches (first, last) names to (last, first) names.
   * ```ql
   * predicate siblings(Person a, Person b) { ... }
   * Person motherOf(Person a, Person b) { ... }
   * Person fatherOf(Person a, Person b) { ... }
   *
   * import Tp2<Person, Person, siblings/2>
   *     ::Project2<Person, Person, motherOf/2, fatherOf/2>
   *   as SiblingParents
   *
   * // Selects (mother, father) that have a pair of children
   * from Person mother, Person father where SiblingParents::tp(mother, father)
   * select mother, father
   * ```
   */
  module ProjectRelate2<
    InfiniteStringableType A0, InfiniteStringableType B0, RelType2<A0, A, B>::rel/2 pja0,
    RelType2<B0, A, B>::rel/2 pjb0>
  {
    predicate tp(A0 a0, B0 b0) {
      exists(A a, B b |
        base(a, b) and
        a0 = pja0(a, b) and
        b0 = pjb0(a, b)
      )
    }
  }

  /**
   * Project this tuple set to a new tuple set of 3 values per row, by using a set of
   * projection functions.
   *
   * Sibling module of `ProjectRelate3` (which takes a set of "relations" instead of "functions").
   *
   * Each project function accepts the values of a tuple from this tuple set, and returns a new
   * value, where the value returned by the nth function will become the nth column in the new tuple
   * set.
   *
   * For example, the following projection switches (first, last) names to (last, first) names.
   * ```ql
   * predicate firstLast(string first, string last) { exists(Person p | ... ) }
   *
   * import Tp2<string, string, firstLast/2>
   *   ::Project2<string, string,
   *       Tuples2<string, string>::getFirst/2,
   *       Tuples2<string, string>::getSecond/2>
   *   as LastFirst
   *
   * // Selects ("Curie", "Maria"), ("Einstein", "Albert"), etc.
   * from string a, string b where LastFirst::tp(a, b) select a, b
   * ```
   */
  module Project3<
    InfiniteStringableType A0, InfiniteStringableType B0, InfiniteStringableType C0,
    FnType2<A0, A, B>::fn/2 pja0, FnType2<B0, A, B>::fn/2 pjb0, FnType2<C0, A, B>::fn/2 pjc0>
  {
    predicate tp(A0 a0, B0 b0, C0 c0) {
      exists(A a, B b |
        base(a, b) and
        a0 = pja0(a, b) and
        b0 = pjb0(a, b) and
        c0 = pjc0(a, b)
      )
    }
  }

  /**
   * Project this tuple set to a new tuple set of 3 values per row, by using a set of
   * relations.
   *
   * Sibling module of `Project3` (which takes a set of "functions" instead of "relations").
   *
   * Each projection relation accepts the values of a tuple from this tuple set, and returns a new
   * value, where the value held by the nth relation will become the nth column in the new tuple
   * set.
   *
   * For example, the following projection switches (first, last) names to (last, first) names.
   * ```ql
   * predicate siblings(Person a, Person b) { ... }
   * Person motherOf(Person a, Person b) { ... }
   * Person fatherOf(Person a, Person b) { ... }
   *
   * import Tp2<Person, Person, siblings/2>
   *     ::Project2<Person, Person, motherOf/2, fatherOf/2>
   *   as SiblingParents
   *
   * // Selects (mother, father) that have a pair of children
   * from Person mother, Person father where SiblingParents::tp(mother, father)
   * select mother, father
   * ```
   */
  module ProjectRelate3<
    InfiniteStringableType A0, InfiniteStringableType B0, InfiniteStringableType C0,
    RelType2<A0, A, B>::rel/2 pja0, RelType2<B0, A, B>::rel/2 pjb0, RelType2<C0, A, B>::rel/2 pjc0>
  {
    predicate tp(A0 a0, B0 b0, C0 c0) {
      exists(A a, B b |
        base(a, b) and
        a0 = pja0(a, b) and
        b0 = pjb0(a, b) and
        c0 = pjc0(a, b)
      )
    }
  }

  /**
   * Project this tuple set to a new tuple set of 4 values per row, by using a set of
   * projection functions.
   *
   * Sibling module of `ProjectRelate4` (which takes a set of "relations" instead of "functions").
   *
   * Each project function accepts the values of a tuple from this tuple set, and returns a new
   * value, where the value returned by the nth function will become the nth column in the new tuple
   * set.
   *
   * For example, the following projection switches (first, last) names to (last, first) names.
   * ```ql
   * predicate firstLast(string first, string last) { exists(Person p | ... ) }
   *
   * import Tp2<string, string, firstLast/2>
   *   ::Project2<string, string,
   *       Tuples2<string, string>::getFirst/2,
   *       Tuples2<string, string>::getSecond/2>
   *   as LastFirst
   *
   * // Selects ("Curie", "Maria"), ("Einstein", "Albert"), etc.
   * from string a, string b where LastFirst::tp(a, b) select a, b
   * ```
   */
  module Project4<
    InfiniteStringableType A0, InfiniteStringableType B0, InfiniteStringableType C0,
    InfiniteStringableType D0, FnType2<A0, A, B>::fn/2 pja0, FnType2<B0, A, B>::fn/2 pjb0,
    FnType2<C0, A, B>::fn/2 pjc0, FnType2<D0, A, B>::fn/2 pjd0>
  {
    predicate tp(A0 a0, B0 b0, C0 c0, D0 d0) {
      exists(A a, B b |
        base(a, b) and
        a0 = pja0(a, b) and
        b0 = pjb0(a, b) and
        c0 = pjc0(a, b) and
        d0 = pjd0(a, b)
      )
    }
  }

  /**
   * Project this tuple set to a new tuple set of 4 values per row, by using a set of
   * relations.
   *
   * Sibling module of `Project4` (which takes a set of "functions" instead of "relations").
   *
   * Each projection relation accepts the values of a tuple from this tuple set, and returns a new
   * value, where the value held by the nth relation will become the nth column in the new tuple
   * set.
   *
   * For example, the following projection switches (first, last) names to (last, first) names.
   * ```ql
   * predicate siblings(Person a, Person b) { ... }
   * Person motherOf(Person a, Person b) { ... }
   * Person fatherOf(Person a, Person b) { ... }
   *
   * import Tp2<Person, Person, siblings/2>
   *     ::Project2<Person, Person, motherOf/2, fatherOf/2>
   *   as SiblingParents
   *
   * // Selects (mother, father) that have a pair of children
   * from Person mother, Person father where SiblingParents::tp(mother, father)
   * select mother, father
   * ```
   */
  module ProjectRelate4<
    InfiniteStringableType A0, InfiniteStringableType B0, InfiniteStringableType C0,
    InfiniteStringableType D0, RelType2<A0, A, B>::rel/2 pja0, RelType2<B0, A, B>::rel/2 pjb0,
    RelType2<C0, A, B>::rel/2 pjc0, RelType2<D0, A, B>::rel/2 pjd0>
  {
    predicate tp(A0 a0, B0 b0, C0 c0, D0 d0) {
      exists(A a, B b |
        base(a, b) and
        a0 = pja0(a, b) and
        b0 = pjb0(a, b) and
        c0 = pjc0(a, b) and
        d0 = pjd0(a, b)
      )
    }
  }

  /**
   * Project this tuple set to a new tuple set of 5 values per row, by using a set of
   * projection functions.
   *
   * Sibling module of `ProjectRelate5` (which takes a set of "relations" instead of "functions").
   *
   * Each project function accepts the values of a tuple from this tuple set, and returns a new
   * value, where the value returned by the nth function will become the nth column in the new tuple
   * set.
   *
   * For example, the following projection switches (first, last) names to (last, first) names.
   * ```ql
   * predicate firstLast(string first, string last) { exists(Person p | ... ) }
   *
   * import Tp2<string, string, firstLast/2>
   *   ::Project2<string, string,
   *       Tuples2<string, string>::getFirst/2,
   *       Tuples2<string, string>::getSecond/2>
   *   as LastFirst
   *
   * // Selects ("Curie", "Maria"), ("Einstein", "Albert"), etc.
   * from string a, string b where LastFirst::tp(a, b) select a, b
   * ```
   */
  module Project5<
    InfiniteStringableType A0, InfiniteStringableType B0, InfiniteStringableType C0,
    InfiniteStringableType D0, InfiniteStringableType E0, FnType2<A0, A, B>::fn/2 pja0,
    FnType2<B0, A, B>::fn/2 pjb0, FnType2<C0, A, B>::fn/2 pjc0, FnType2<D0, A, B>::fn/2 pjd0,
    FnType2<E0, A, B>::fn/2 pje0>
  {
    predicate tp(A0 a0, B0 b0, C0 c0, D0 d0, E0 e0) {
      exists(A a, B b |
        base(a, b) and
        a0 = pja0(a, b) and
        b0 = pjb0(a, b) and
        c0 = pjc0(a, b) and
        d0 = pjd0(a, b) and
        e0 = pje0(a, b)
      )
    }
  }

  /**
   * Project this tuple set to a new tuple set of 5 values per row, by using a set of
   * relations.
   *
   * Sibling module of `Project5` (which takes a set of "functions" instead of "relations").
   *
   * Each projection relation accepts the values of a tuple from this tuple set, and returns a new
   * value, where the value held by the nth relation will become the nth column in the new tuple
   * set.
   *
   * For example, the following projection switches (first, last) names to (last, first) names.
   * ```ql
   * predicate siblings(Person a, Person b) { ... }
   * Person motherOf(Person a, Person b) { ... }
   * Person fatherOf(Person a, Person b) { ... }
   *
   * import Tp2<Person, Person, siblings/2>
   *     ::Project2<Person, Person, motherOf/2, fatherOf/2>
   *   as SiblingParents
   *
   * // Selects (mother, father) that have a pair of children
   * from Person mother, Person father where SiblingParents::tp(mother, father)
   * select mother, father
   * ```
   */
  module ProjectRelate5<
    InfiniteStringableType A0, InfiniteStringableType B0, InfiniteStringableType C0,
    InfiniteStringableType D0, InfiniteStringableType E0, RelType2<A0, A, B>::rel/2 pja0,
    RelType2<B0, A, B>::rel/2 pjb0, RelType2<C0, A, B>::rel/2 pjc0, RelType2<D0, A, B>::rel/2 pjd0,
    RelType2<E0, A, B>::rel/2 pje0>
  {
    predicate tp(A0 a0, B0 b0, C0 c0, D0 d0, E0 e0) {
      exists(A a, B b |
        base(a, b) and
        a0 = pja0(a, b) and
        b0 = pjb0(a, b) and
        c0 = pjc0(a, b) and
        d0 = pjd0(a, b) and
        e0 = pje0(a, b)
      )
    }
  }

  /**
   * Project this tuple set to a new tuple set of 6 values per row, by using a set of
   * projection functions.
   *
   * Sibling module of `ProjectRelate6` (which takes a set of "relations" instead of "functions").
   *
   * Each project function accepts the values of a tuple from this tuple set, and returns a new
   * value, where the value returned by the nth function will become the nth column in the new tuple
   * set.
   *
   * For example, the following projection switches (first, last) names to (last, first) names.
   * ```ql
   * predicate firstLast(string first, string last) { exists(Person p | ... ) }
   *
   * import Tp2<string, string, firstLast/2>
   *   ::Project2<string, string,
   *       Tuples2<string, string>::getFirst/2,
   *       Tuples2<string, string>::getSecond/2>
   *   as LastFirst
   *
   * // Selects ("Curie", "Maria"), ("Einstein", "Albert"), etc.
   * from string a, string b where LastFirst::tp(a, b) select a, b
   * ```
   */
  module Project6<
    InfiniteStringableType A0, InfiniteStringableType B0, InfiniteStringableType C0,
    InfiniteStringableType D0, InfiniteStringableType E0, InfiniteStringableType F0,
    FnType2<A0, A, B>::fn/2 pja0, FnType2<B0, A, B>::fn/2 pjb0, FnType2<C0, A, B>::fn/2 pjc0,
    FnType2<D0, A, B>::fn/2 pjd0, FnType2<E0, A, B>::fn/2 pje0, FnType2<F0, A, B>::fn/2 pjf0>
  {
    predicate tp(A0 a0, B0 b0, C0 c0, D0 d0, E0 e0, F0 f0) {
      exists(A a, B b |
        base(a, b) and
        a0 = pja0(a, b) and
        b0 = pjb0(a, b) and
        c0 = pjc0(a, b) and
        d0 = pjd0(a, b) and
        e0 = pje0(a, b) and
        f0 = pjf0(a, b)
      )
    }
  }

  /**
   * Project this tuple set to a new tuple set of 6 values per row, by using a set of
   * relations.
   *
   * Sibling module of `Project6` (which takes a set of "functions" instead of "relations").
   *
   * Each projection relation accepts the values of a tuple from this tuple set, and returns a new
   * value, where the value held by the nth relation will become the nth column in the new tuple
   * set.
   *
   * For example, the following projection switches (first, last) names to (last, first) names.
   * ```ql
   * predicate siblings(Person a, Person b) { ... }
   * Person motherOf(Person a, Person b) { ... }
   * Person fatherOf(Person a, Person b) { ... }
   *
   * import Tp2<Person, Person, siblings/2>
   *     ::Project2<Person, Person, motherOf/2, fatherOf/2>
   *   as SiblingParents
   *
   * // Selects (mother, father) that have a pair of children
   * from Person mother, Person father where SiblingParents::tp(mother, father)
   * select mother, father
   * ```
   */
  module ProjectRelate6<
    InfiniteStringableType A0, InfiniteStringableType B0, InfiniteStringableType C0,
    InfiniteStringableType D0, InfiniteStringableType E0, InfiniteStringableType F0,
    RelType2<A0, A, B>::rel/2 pja0, RelType2<B0, A, B>::rel/2 pjb0, RelType2<C0, A, B>::rel/2 pjc0,
    RelType2<D0, A, B>::rel/2 pjd0, RelType2<E0, A, B>::rel/2 pje0, RelType2<F0, A, B>::rel/2 pjf0>
  {
    predicate tp(A0 a0, B0 b0, C0 c0, D0 d0, E0 e0, F0 f0) {
      exists(A a, B b |
        base(a, b) and
        a0 = pja0(a, b) and
        b0 = pjb0(a, b) and
        c0 = pjc0(a, b) and
        d0 = pjd0(a, b) and
        e0 = pje0(a, b) and
        f0 = pjf0(a, b)
      )
    }
  }

  /**
   * Maps the set of first values in the set of tuples that satisfy the given predicate,
   * against a mapper function.
   *
   * Sibling function of `MapRelateFirst`, which operates on "relations" instead of
   * "functions."
   *
   * Example:
   * ```ql
   * predicate employs(Company company, Person person) { ... }
   *
   * // Selects the ages of employed People.
   * select Tp2<Company, Person, employs/2>
   *   ::MapSecond<int, getAge/1>
   *   ::find()
   * ```
   */
  module MapFirst<InfiniteStringableType R, FnType1<R, A>::fn/1 map> {
    R find() {
      exists(A a |
        base(a, _) and
        result = map(a)
      )
    }
  }

  /**
   * Maps the set of first values in the set of tuples that satisfy the given predicate,
   * against a mapper relation.
   *
   * Sibling function of `MapFirst`, which operates on "functions" instead of
   * "relations."
   *
   * Example:
   * ```ql
   * predicate employs(Company company, Person person) { ... }
   * Pet getPets(Person p) { ... }
   *
   * // Selects the pets of employed People.
   * select Tp2<Company, Person, employs/2>
   *   ::MapRelateSecond<Pet, getPets/1>
   *   ::find()
   * ```
   */
  module MapRelateFirst<InfiniteStringableType R, RelType1<R, A>::rel/1 map> {
    R find() {
      exists(A a |
        base(a, _) and
        result = map(a)
      )
    }
  }

  /**
   * Maps the set of second values in the set of tuples that satisfy the given predicate,
   * against a mapper function.
   *
   * Sibling function of `MapRelateSecond`, which operates on "relations" instead of
   * "functions."
   *
   * Example:
   * ```ql
   * predicate employs(Company company, Person person) { ... }
   *
   * // Selects the ages of employed People.
   * select Tp2<Company, Person, employs/2>
   *   ::MapSecond<int, getAge/1>
   *   ::find()
   * ```
   */
  module MapSecond<InfiniteStringableType R, FnType1<R, B>::fn/1 map> {
    R find() {
      exists(B b |
        base(_, b) and
        result = map(b)
      )
    }
  }

  /**
   * Maps the set of second values in the set of tuples that satisfy the given predicate,
   * against a mapper relation.
   *
   * Sibling function of `MapSecond`, which operates on "functions" instead of
   * "relations."
   *
   * Example:
   * ```ql
   * predicate employs(Company company, Person person) { ... }
   * Pet getPets(Person p) { ... }
   *
   * // Selects the pets of employed People.
   * select Tp2<Company, Person, employs/2>
   *   ::MapRelateSecond<Pet, getPets/1>
   *   ::find()
   * ```
   */
  module MapRelateSecond<InfiniteStringableType R, RelType1<R, B>::rel/1 map> {
    R find() {
      exists(B b |
        base(_, b) and
        result = map(b)
      )
    }
  }

  /**
   * Extend this tuple predicate to have an additional column, by intersecting it with a tuple
   * predicate with one additional parameter and all existing matching.
   */
  module ExtendIntersect<InfiniteStringableType Z, TpType3<A, B, Z>::tp/3 tp2> {
    predicate tp(A a, B b, Z z) {
      base(a, b) and
      tp2(a, b, z)
    }
  }

  /**
   * Extend this tuple predicate to have an additional column, by running a provided function over
   * each tuple in this predicate's tuple set, and using the result of that function as the new
   * column.
   *
   * Sibling module of `ExtendByRelation`, which takes a "relation" instead of a "function."
   */
  module ExtendByFn<InfiniteStringableType R, FnType2<R, A, B>::fn/2 ext> {
    predicate tp(A a, B b, R r) {
      base(a, b) and
      r = ext(a, b)
    }
  }

  /**
   * Extend this tuple predicate to have an additional column, by running a provided relation over
   * each tuple in this predicate's tuple set, and using the result of that relation as the new
   * column.
   *
   * Sibling module of `ExtendByFn`, which takes a "function" instead of a "relation."
   */
  module ExtendByRelation<InfiniteStringableType R, RelType2<R, A, B>::rel/2 ext> {
    predicate tp(A a, B b, R r) {
      base(a, b) and
      r = ext(a, b)
    }
  }

  /**
   * Maps the set of first values in the set of tuples that satisfy the given predicate,
   * against a mapper function, and use the result to add a column to this tuple set.
   *
   * Sibling function of `ExtendRelateFirst`, which operates on "relations" instead of
   * "functions."
   *
   * Example:
   * ```ql
   * predicate hasName(Person person, string name) { ... }
   * string getInitials(string name) { ... }
   *
   * // Selects (person, name, initials)
   * import Tp2<Person, string, hasName/2>
   *   ::ExtendMapSecond<string, getInitials/1>
   *   ::Query
   * ```
   */
  module ExtendMapFirst<InfiniteStringableType R, FnType1<R, A>::fn/1 map> {
    predicate tp(A a, B b, R r) {
      base(a, b) and
      r = map(a)
    }
  }

  /**
   * Maps the set of first values in the set of tuples that satisfy the given predicate,
   * against a mapper function, and use the result to add a column to this tuple set.
   *
   * Sibling function of `ExtendRelateFirst`, which operates on "relations" instead of
   * "functions."
   *
   * Example:
   * ```ql
   * predicate employs(Company company, Person person) { ... }
   * Address hasAddress(Person p) { ... }
   *
   * // Selects (company, person, age) for all employed people.
   * import Tp2<Company, Person, employs/2>
   *   ::ExtendRelateSecond<getAge/1>
   *   ::Query
   * ```
   */
  module ExtendRelateFirst<InfiniteStringableType R, RelType1<R, A>::rel/1 map> {
    predicate tp(A a, B b, R r) {
      base(a, b) and
      r = map(a)
    }
  }

  /**
   * Maps the set of second values in the set of tuples that satisfy the given predicate,
   * against a mapper function, and use the result to add a column to this tuple set.
   *
   * Sibling function of `ExtendRelateSecond`, which operates on "relations" instead of
   * "functions."
   *
   * Example:
   * ```ql
   * predicate hasName(Person person, string name) { ... }
   * string getInitials(string name) { ... }
   *
   * // Selects (person, name, initials)
   * import Tp2<Person, string, hasName/2>
   *   ::ExtendMapSecond<string, getInitials/1>
   *   ::Query
   * ```
   */
  module ExtendMapSecond<InfiniteStringableType R, FnType1<R, B>::fn/1 map> {
    predicate tp(A a, B b, R r) {
      base(a, b) and
      r = map(b)
    }
  }

  /**
   * Maps the set of second values in the set of tuples that satisfy the given predicate,
   * against a mapper function, and use the result to add a column to this tuple set.
   *
   * Sibling function of `ExtendRelateSecond`, which operates on "relations" instead of
   * "functions."
   *
   * Example:
   * ```ql
   * predicate employs(Company company, Person person) { ... }
   * Address hasAddress(Person p) { ... }
   *
   * // Selects (company, person, age) for all employed people.
   * import Tp2<Company, Person, employs/2>
   *   ::ExtendRelateSecond<getAge/1>
   *   ::Query
   * ```
   */
  module ExtendRelateSecond<InfiniteStringableType R, RelType1<R, B>::rel/1 map> {
    predicate tp(A a, B b, R r) {
      base(a, b) and
      r = map(b)
    }
  }

  /**
   * Takes a property which filters the contents of the current tuple set and produces a new one.
   *
   * Sibling predicate of `intersect`, which takes a "tuple predicate" instead of a "property."
   */
  module Filter<PropType2<A, B>::prop/2 flt> {
    predicate tp(A a, B b) {
      flt(a, b) and
      base(a, b)
    }
  }

  /**
   * Takes a tuple set and intersects it with the current tuple set to produce a new one.
   *
   * Sibling predicate of `filter`, which takes a "property" instead of a "tuple set."
   */
  module Intersect<TpType2<A, B>::tp/2 tp2> {
    predicate tp(A a, B b) {
      tp2(a, b) and
      base(a, b)
    }
  }

  /**
   * Creates a new tuple predicate that is a union of the current tuple set and the given one.
   */
  module Union<TpType2<A, B>::tp/2 tp2> {
    predicate tp(A a, B b) {
      tp2(a, b) or
      base(a, b)
    }
  }

  /**
   * Creates a new tuple predicate that holds the elements only in the current tuple set, not the
   * given one.
   */
  module Difference<TpType2<A, B>::tp/2 tp2> {
    predicate tp(A a, B b) {
      base(a, b) and
      not tp2(a, b)
    }
  }

  /**
   * Checks if (a, b, c, ...) is a member of the tuple set represented by this "tuple predicate."
   */
  predicate contains(A a, B b) { base(a, b) }

  /**
   * A module with a single predicate, `holds`, that holds if the current tuple set contains all
   * of the tuples of the given tuple predicate `tp2`.
   */
  module ContainsAll<TpType2<A, B>::tp/2 tp2> {
    predicate holds() { forall(A a, B b | tp2(a, b) | base(a, b)) }
  }

  /**
   * A module with a single predicate, `holds`, that holds if the current tuple set contains any
   * of the tuples of the given tuple predicate `tp2`.
   *
   * Sibling predicate of `AnyHoldsFor`, which takes a "property" instead of a "tuple predicate."
   */
  module ContainsAny<TpType2<A, B>::tp/2 tp2> {
    predicate holds() {
      exists(A a, B b |
        tp2(a, b) and
        base(a, b)
      )
    }
  }

  /**
   * A module with a single predicate, `holds`, that holds if any of the tuples in the current tuple
   * satisfy the given property `prop`.
   *
   * Sibling predicate of `ContainsAny`, which takes a "tuple predicate" instead of a "property."
   */
  module AnyHoldsFor<PropType2<A, B>::prop/2 prop> {
    predicate holds() {
      exists(A a, B b |
        base(a, b) and
        prop(a, b)
      )
    }
  }

  /**
   * A module with a single predicate, `holds`, that holds if all of the tuples in the current tuple
   * set satisfy the given property `prop`.
   *
   * Sibling predicate of `ContainedBy` which takes a "tuple predicate" instead of a "property."
   */
  module AllHoldsFor<PropType2<A, B>::prop/2 prop> {
    predicate holds() { forall(A a, B b | base(a, b) | prop(a, b)) }
  }

  /**
   * A module with a single predicate, `holds`, that holds if all of the tuples in the current tuple
   * set satisfy the given property `prop`.
   *
   * Sibling predicate of `AllHoldsFor`, which takes a "property" instead of a "tuple predicate."
   */
  module ContainedBy<TpType2<A, B>::tp/2 tp2> {
    predicate holds() { forall(A a, B b | base(a, b) | tp2(a, b)) }
  }

  /**
   * Drop the first column in the set of tuples that satisfy the given predicate, and get
   * a new tuple set after that column has been dropped.
   */
  predicate dropFirst(B b) { base(_, b) }

  /**
   * Drop the second column in the set of tuples that satisfy the given predicate, and get
   * a new tuple set after that column has been dropped.
   */
  predicate dropSecond(A a) { base(a, _) }

  /**
   * A basic, but very flexible join operation, taking a new tuple predicate to join as well as a
   * function for each that maps it to a value of type J.
   *
   * For instance, given sets of tuples `(a, b, c)` and `(d, e)` and join functions `(a, b, c) -> a`
   * and `(d, e) -> e`, this module will join both tuple sets on `a = e`.
   */
  module Join2ByFns<
    InfiniteStringableType J, InfiniteStringableType A0, InfiniteStringableType B0,
    TpType2<A0, B0>::tp/2 tp2, FnType2<J, A0, B0>::fn/2 tp2j, FnType2<J, A, B>::fn/2 tpj>
  {
    predicate tp(A a, B b, A0 a0, B0 b0) {
      base(a, b) and
      tp2(a0, b0) and
      tpj(a, b) = tp2j(a0, b0)
    }
  }

  /**
   * A basic, but very flexible join operation, taking a new tuple predicate to join as well as a
   * function for each that maps it to a value of type J.
   *
   * For instance, given sets of tuples `(a, b, c)` and `(d, e)` and join functions `(a, b, c) -> a`
   * and `(d, e) -> e`, this module will join both tuple sets on `a = e`.
   */
  module Join3ByFns<
    InfiniteStringableType J, InfiniteStringableType A0, InfiniteStringableType B0,
    InfiniteStringableType C0, TpType3<A0, B0, C0>::tp/3 tp2, FnType3<J, A0, B0, C0>::fn/3 tp2j,
    FnType2<J, A, B>::fn/2 tpj>
  {
    predicate tp(A a, B b, A0 a0, B0 b0, C0 c0) {
      base(a, b) and
      tp2(a0, b0, c0) and
      tpj(a, b) = tp2j(a0, b0, c0)
    }
  }

  /**
   * A basic, but very flexible join operation, taking a new tuple predicate to join as well as a
   * function for each that maps it to a value of type J.
   *
   * For instance, given sets of tuples `(a, b, c)` and `(d, e)` and join functions `(a, b, c) -> a`
   * and `(d, e) -> e`, this module will join both tuple sets on `a = e`.
   */
  module Join4ByFns<
    InfiniteStringableType J, InfiniteStringableType A0, InfiniteStringableType B0,
    InfiniteStringableType C0, InfiniteStringableType D0, TpType4<A0, B0, C0, D0>::tp/4 tp2,
    FnType4<J, A0, B0, C0, D0>::fn/4 tp2j, FnType2<J, A, B>::fn/2 tpj>
  {
    predicate tp(A a, B b, A0 a0, B0 b0, C0 c0, D0 d0) {
      base(a, b) and
      tp2(a0, b0, c0, d0) and
      tpj(a, b) = tp2j(a0, b0, c0, d0)
    }
  }

  /**
   * Count the number of tuples in this tuple set.
   */
  int doCount() { result = count(A a, B b | base(a, b)) }

  /**
   * Query for the contents of this tuple, by defining a query predicate `tpQuery` to import.
   */
  module Query {
    query predicate tpQuery(A a, B b) { base(a, b) }
  }
}

/**
 * A module for transforming a "Tuple predicate" with 3 arguments.
 *
 * In qtil speak:
 *  - a "Function" (FnX) is a predicate with a bindingset[] on all of its arguments, and a result
 *  - a "TuplePredicate " (TpX) is a predicate with finite arguments and no result
 *  - a "Relation" (RelX) is a predicate with finite arguments and a finite result
 *  - a "Property" (PropX) is a predicate with a bindingset[] on all arguments no result
 *
 * Essentially, a tuple predicate `Tp<A, B, C>` represents a finite set of tuples `(a, b, c)`. This
 * module accepts a tuple predicate (`predicate p(A, B, C)`) as an input, and offers functional
 * programming features on top of it such as `map` and `filter`, as well as some relational algebra
 * features such as projection and joins.
 *
 * Example:
 * ```ql
 * predicate livesIn(Person p, City c) { c = p.getCity() }
 * string describe(Person p, City c) { result = p.getName() + " lives in " + c.getName() }
 *
 * // selects "Peter lives in New York", "Wanda lives in London", ...
 * select Tp2<Person, City, livesIn/2>::Map<string, describe/2>::find()
 * ```
 */
module Tp3<
  InfiniteStringableType A, InfiniteStringableType B, InfiniteStringableType C,
  TpType3<A, B, C>::tp/3 base>
{
  /**
   * Get the set of first values in the set of tuples that satisfy the given predicate.
   */
  A first() { base(result, _, _) }

  /**
   * Get the set of first values in the set of tuples that satisfy the given predicate.
   */
  module First {
    import Tp3<A, B, C, first/0>
  }

  /**
   * Get the set of second values in the set of tuples that satisfy the given predicate.
   */
  B second() { base(_, result, _) }

  /**
   * Get the set of second values in the set of tuples that satisfy the given predicate.
   */
  module Second {
    import Tp3<A, B, C, second/0>
  }

  /**
   * Get the set of third values in the set of tuples that satisfy the given predicate.
   */
  C third() { base(_, _, result) }

  /**
   * Get the set of third values in the set of tuples that satisfy the given predicate.
   */
  module Third {
    import Tp3<A, B, C, third/0>
  }

  /**
   * Map a function over the tuples in this tuple set, and get a new tuple predicate back
   * representing the set of tuples after being transformed by that function.
   *
   * Sibling module of `Relate` (which takes a "relation" instead of a "function").
   *
   * Note that this implicitly performs a "flatMap," as the mapping function may return zero or
   * more than one result per tuple.
   *
   * Example:
   * ```ql
   * predicate livesIn(Person p, City c) { c = p.getCity() }
   * string describe(Person p, City c) { result = p.getName() + " lives in " + c.getName() }
   *
   * // selects "Peter lives in New York", "Wanda lives in London", ...
   * select Tp2<Person, City, livesIn/2>::Map<string, describe/2>::find()
   * ```
   */
  module Map<InfiniteStringableType R, FnType3<R, A, B, C>::fn/3 map> {
    /**
     * Get the result of mapping the function `map` over the set of tuples represented by this
     * tuple predicate.
     *
     * For mapping a "relation" (as opposed to a "function") over this tuple set, see `MapRelate`.
     */
    R find() {
      exists(A a, B b, C c |
        base(a, b, c) and
        result = map(a, b, c)
      )
    }
    // TODO: import ResultSet<R, find/0>
  }

  /**
   * Maps a relation over the tuples in this tuple set, and get a new tuple predicate back
   * representing the related values to the tuples in this set.
   *
   * Sibling module of `Map` (which takes a "function" instead of a "relation").
   *
   * Note that this implicitly performs an intersection with the domain tuple set of the given
   * relation.
   *
   * Example:
   * ```ql
   * predicate livesIn(Person p, City c) { c = p.getCity() }
   * Address hasMailingAddress(Person p, City c) { ... }
   *
   * // Selects the mailing addresses that correspond to the people, city in `livesIn`.
   * select Tp2<Person, City, livesIn/2>::Relate<Address, hasMailingAddress/2>::find()
   * ```
   *
   * To preserve `Person`, `City`, see `ExtendRelate`.
   */
  module Relate<InfiniteStringableType R, RelType3<R, A, B, C>::rel/3 r> {
    /**
     * Get the result of mapping the relation `r` over the set of tuples represented by this tuple
     * predicate.
     *
     * For mapping a "function" (as opposed to a "relation") over this tuple set, see `MapRelate`.
     */
    R find() {
      exists(A a, B b, C c |
        base(a, b, c) and
        result = r(a, b, c)
      )
    }
    // TODO: import ResultSet<R, find/0>
  }

  /**
   * An alias for `Map`, but the result is a "tuple set" (a predicate(A a) with one parameter and no
   * result) instead of a `ResultSet` (a predicate `R pred()` with no parameters and result `R`).
   *
   * Sibling module of `ProjectRelate1` (which takes a "relation" instead of a "function").
   *
   * See `Map` for more details.
   */
  module Project1<InfiniteStringableType R, FnType3<R, A, B, C>::fn/3 map> {
    /**
     * A predicate tuple that represents the result of a projection, from the input tuple
     * predicate, to a new tuple predicate with a single column derived from applying a tuple to the
     * given function `map`.
     *
     * For projecting this tuple by a "relation" (as opposed to a "function"), see `ProjectRelate`.
     */
    predicate tp(R related) {
      exists(A a, B b, C c |
        base(a, b, c) and
        related = map(a, b, c)
      )
    }
    // TODO: import Tp1<R, tp/1> ?
  }

  /**
   * An alias for `Relate`, but the result is a "tuple set" (a predicate(A a) with one parameter and no
   * result) instead of a `ResultSet` (a predicate `R pred()` with no parameters and result `R`).
   *
   * Sibling module of `Project1` (which takes a "function" instead of a "relation").
   *
   * See `Relate` for more details.
   */
  module ProjectRelate1<InfiniteStringableType R, RelType3<R, A, B, C>::rel/3 r> {
    /**
     * A predicate tuple that represents the result of a projection, from the input tuple
     * predicate, to a new tuple predicate with a single column derived from the given relation
     * `r`.
     *
     * For projecting this tuple by a "function" (as opposed to a "relation"), see `Project`.
     */
    predicate tp(R related) {
      exists(A a, B b, C c |
        base(a, b, c) and
        related = r(a, b, c)
      )
    }
    // TODO: import Tp1<R, tp/1> ?
  }

  /**
   * Project this tuple set to a new tuple set of 2 values per row, by using a set of
   * projection functions.
   *
   * Sibling module of `ProjectRelate2` (which takes a set of "relations" instead of "functions").
   *
   * Each project function accepts the values of a tuple from this tuple set, and returns a new
   * value, where the value returned by the nth function will become the nth column in the new tuple
   * set.
   *
   * For example, the following projection switches (first, last) names to (last, first) names.
   * ```ql
   * predicate firstLast(string first, string last) { exists(Person p | ... ) }
   *
   * import Tp2<string, string, firstLast/2>
   *   ::Project2<string, string,
   *       Tuples2<string, string>::getFirst/2,
   *       Tuples2<string, string>::getSecond/2>
   *   as LastFirst
   *
   * // Selects ("Curie", "Maria"), ("Einstein", "Albert"), etc.
   * from string a, string b where LastFirst::tp(a, b) select a, b
   * ```
   */
  module Project2<
    InfiniteStringableType A0, InfiniteStringableType B0, FnType3<A0, A, B, C>::fn/3 pja0,
    FnType3<B0, A, B, C>::fn/3 pjb0>
  {
    predicate tp(A0 a0, B0 b0) {
      exists(A a, B b, C c |
        base(a, b, c) and
        a0 = pja0(a, b, c) and
        b0 = pjb0(a, b, c)
      )
    }
  }

  /**
   * Project this tuple set to a new tuple set of 2 values per row, by using a set of
   * relations.
   *
   * Sibling module of `Project2` (which takes a set of "functions" instead of "relations").
   *
   * Each projection relation accepts the values of a tuple from this tuple set, and returns a new
   * value, where the value held by the nth relation will become the nth column in the new tuple
   * set.
   *
   * For example, the following projection switches (first, last) names to (last, first) names.
   * ```ql
   * predicate siblings(Person a, Person b) { ... }
   * Person motherOf(Person a, Person b) { ... }
   * Person fatherOf(Person a, Person b) { ... }
   *
   * import Tp2<Person, Person, siblings/2>
   *     ::Project2<Person, Person, motherOf/2, fatherOf/2>
   *   as SiblingParents
   *
   * // Selects (mother, father) that have a pair of children
   * from Person mother, Person father where SiblingParents::tp(mother, father)
   * select mother, father
   * ```
   */
  module ProjectRelate2<
    InfiniteStringableType A0, InfiniteStringableType B0, RelType3<A0, A, B, C>::rel/3 pja0,
    RelType3<B0, A, B, C>::rel/3 pjb0>
  {
    predicate tp(A0 a0, B0 b0) {
      exists(A a, B b, C c |
        base(a, b, c) and
        a0 = pja0(a, b, c) and
        b0 = pjb0(a, b, c)
      )
    }
  }

  /**
   * Project this tuple set to a new tuple set of 3 values per row, by using a set of
   * projection functions.
   *
   * Sibling module of `ProjectRelate3` (which takes a set of "relations" instead of "functions").
   *
   * Each project function accepts the values of a tuple from this tuple set, and returns a new
   * value, where the value returned by the nth function will become the nth column in the new tuple
   * set.
   *
   * For example, the following projection switches (first, last) names to (last, first) names.
   * ```ql
   * predicate firstLast(string first, string last) { exists(Person p | ... ) }
   *
   * import Tp2<string, string, firstLast/2>
   *   ::Project2<string, string,
   *       Tuples2<string, string>::getFirst/2,
   *       Tuples2<string, string>::getSecond/2>
   *   as LastFirst
   *
   * // Selects ("Curie", "Maria"), ("Einstein", "Albert"), etc.
   * from string a, string b where LastFirst::tp(a, b) select a, b
   * ```
   */
  module Project3<
    InfiniteStringableType A0, InfiniteStringableType B0, InfiniteStringableType C0,
    FnType3<A0, A, B, C>::fn/3 pja0, FnType3<B0, A, B, C>::fn/3 pjb0,
    FnType3<C0, A, B, C>::fn/3 pjc0>
  {
    predicate tp(A0 a0, B0 b0, C0 c0) {
      exists(A a, B b, C c |
        base(a, b, c) and
        a0 = pja0(a, b, c) and
        b0 = pjb0(a, b, c) and
        c0 = pjc0(a, b, c)
      )
    }
  }

  /**
   * Project this tuple set to a new tuple set of 3 values per row, by using a set of
   * relations.
   *
   * Sibling module of `Project3` (which takes a set of "functions" instead of "relations").
   *
   * Each projection relation accepts the values of a tuple from this tuple set, and returns a new
   * value, where the value held by the nth relation will become the nth column in the new tuple
   * set.
   *
   * For example, the following projection switches (first, last) names to (last, first) names.
   * ```ql
   * predicate siblings(Person a, Person b) { ... }
   * Person motherOf(Person a, Person b) { ... }
   * Person fatherOf(Person a, Person b) { ... }
   *
   * import Tp2<Person, Person, siblings/2>
   *     ::Project2<Person, Person, motherOf/2, fatherOf/2>
   *   as SiblingParents
   *
   * // Selects (mother, father) that have a pair of children
   * from Person mother, Person father where SiblingParents::tp(mother, father)
   * select mother, father
   * ```
   */
  module ProjectRelate3<
    InfiniteStringableType A0, InfiniteStringableType B0, InfiniteStringableType C0,
    RelType3<A0, A, B, C>::rel/3 pja0, RelType3<B0, A, B, C>::rel/3 pjb0,
    RelType3<C0, A, B, C>::rel/3 pjc0>
  {
    predicate tp(A0 a0, B0 b0, C0 c0) {
      exists(A a, B b, C c |
        base(a, b, c) and
        a0 = pja0(a, b, c) and
        b0 = pjb0(a, b, c) and
        c0 = pjc0(a, b, c)
      )
    }
  }

  /**
   * Project this tuple set to a new tuple set of 4 values per row, by using a set of
   * projection functions.
   *
   * Sibling module of `ProjectRelate4` (which takes a set of "relations" instead of "functions").
   *
   * Each project function accepts the values of a tuple from this tuple set, and returns a new
   * value, where the value returned by the nth function will become the nth column in the new tuple
   * set.
   *
   * For example, the following projection switches (first, last) names to (last, first) names.
   * ```ql
   * predicate firstLast(string first, string last) { exists(Person p | ... ) }
   *
   * import Tp2<string, string, firstLast/2>
   *   ::Project2<string, string,
   *       Tuples2<string, string>::getFirst/2,
   *       Tuples2<string, string>::getSecond/2>
   *   as LastFirst
   *
   * // Selects ("Curie", "Maria"), ("Einstein", "Albert"), etc.
   * from string a, string b where LastFirst::tp(a, b) select a, b
   * ```
   */
  module Project4<
    InfiniteStringableType A0, InfiniteStringableType B0, InfiniteStringableType C0,
    InfiniteStringableType D0, FnType3<A0, A, B, C>::fn/3 pja0, FnType3<B0, A, B, C>::fn/3 pjb0,
    FnType3<C0, A, B, C>::fn/3 pjc0, FnType3<D0, A, B, C>::fn/3 pjd0>
  {
    predicate tp(A0 a0, B0 b0, C0 c0, D0 d0) {
      exists(A a, B b, C c |
        base(a, b, c) and
        a0 = pja0(a, b, c) and
        b0 = pjb0(a, b, c) and
        c0 = pjc0(a, b, c) and
        d0 = pjd0(a, b, c)
      )
    }
  }

  /**
   * Project this tuple set to a new tuple set of 4 values per row, by using a set of
   * relations.
   *
   * Sibling module of `Project4` (which takes a set of "functions" instead of "relations").
   *
   * Each projection relation accepts the values of a tuple from this tuple set, and returns a new
   * value, where the value held by the nth relation will become the nth column in the new tuple
   * set.
   *
   * For example, the following projection switches (first, last) names to (last, first) names.
   * ```ql
   * predicate siblings(Person a, Person b) { ... }
   * Person motherOf(Person a, Person b) { ... }
   * Person fatherOf(Person a, Person b) { ... }
   *
   * import Tp2<Person, Person, siblings/2>
   *     ::Project2<Person, Person, motherOf/2, fatherOf/2>
   *   as SiblingParents
   *
   * // Selects (mother, father) that have a pair of children
   * from Person mother, Person father where SiblingParents::tp(mother, father)
   * select mother, father
   * ```
   */
  module ProjectRelate4<
    InfiniteStringableType A0, InfiniteStringableType B0, InfiniteStringableType C0,
    InfiniteStringableType D0, RelType3<A0, A, B, C>::rel/3 pja0, RelType3<B0, A, B, C>::rel/3 pjb0,
    RelType3<C0, A, B, C>::rel/3 pjc0, RelType3<D0, A, B, C>::rel/3 pjd0>
  {
    predicate tp(A0 a0, B0 b0, C0 c0, D0 d0) {
      exists(A a, B b, C c |
        base(a, b, c) and
        a0 = pja0(a, b, c) and
        b0 = pjb0(a, b, c) and
        c0 = pjc0(a, b, c) and
        d0 = pjd0(a, b, c)
      )
    }
  }

  /**
   * Project this tuple set to a new tuple set of 5 values per row, by using a set of
   * projection functions.
   *
   * Sibling module of `ProjectRelate5` (which takes a set of "relations" instead of "functions").
   *
   * Each project function accepts the values of a tuple from this tuple set, and returns a new
   * value, where the value returned by the nth function will become the nth column in the new tuple
   * set.
   *
   * For example, the following projection switches (first, last) names to (last, first) names.
   * ```ql
   * predicate firstLast(string first, string last) { exists(Person p | ... ) }
   *
   * import Tp2<string, string, firstLast/2>
   *   ::Project2<string, string,
   *       Tuples2<string, string>::getFirst/2,
   *       Tuples2<string, string>::getSecond/2>
   *   as LastFirst
   *
   * // Selects ("Curie", "Maria"), ("Einstein", "Albert"), etc.
   * from string a, string b where LastFirst::tp(a, b) select a, b
   * ```
   */
  module Project5<
    InfiniteStringableType A0, InfiniteStringableType B0, InfiniteStringableType C0,
    InfiniteStringableType D0, InfiniteStringableType E0, FnType3<A0, A, B, C>::fn/3 pja0,
    FnType3<B0, A, B, C>::fn/3 pjb0, FnType3<C0, A, B, C>::fn/3 pjc0,
    FnType3<D0, A, B, C>::fn/3 pjd0, FnType3<E0, A, B, C>::fn/3 pje0>
  {
    predicate tp(A0 a0, B0 b0, C0 c0, D0 d0, E0 e0) {
      exists(A a, B b, C c |
        base(a, b, c) and
        a0 = pja0(a, b, c) and
        b0 = pjb0(a, b, c) and
        c0 = pjc0(a, b, c) and
        d0 = pjd0(a, b, c) and
        e0 = pje0(a, b, c)
      )
    }
  }

  /**
   * Project this tuple set to a new tuple set of 5 values per row, by using a set of
   * relations.
   *
   * Sibling module of `Project5` (which takes a set of "functions" instead of "relations").
   *
   * Each projection relation accepts the values of a tuple from this tuple set, and returns a new
   * value, where the value held by the nth relation will become the nth column in the new tuple
   * set.
   *
   * For example, the following projection switches (first, last) names to (last, first) names.
   * ```ql
   * predicate siblings(Person a, Person b) { ... }
   * Person motherOf(Person a, Person b) { ... }
   * Person fatherOf(Person a, Person b) { ... }
   *
   * import Tp2<Person, Person, siblings/2>
   *     ::Project2<Person, Person, motherOf/2, fatherOf/2>
   *   as SiblingParents
   *
   * // Selects (mother, father) that have a pair of children
   * from Person mother, Person father where SiblingParents::tp(mother, father)
   * select mother, father
   * ```
   */
  module ProjectRelate5<
    InfiniteStringableType A0, InfiniteStringableType B0, InfiniteStringableType C0,
    InfiniteStringableType D0, InfiniteStringableType E0, RelType3<A0, A, B, C>::rel/3 pja0,
    RelType3<B0, A, B, C>::rel/3 pjb0, RelType3<C0, A, B, C>::rel/3 pjc0,
    RelType3<D0, A, B, C>::rel/3 pjd0, RelType3<E0, A, B, C>::rel/3 pje0>
  {
    predicate tp(A0 a0, B0 b0, C0 c0, D0 d0, E0 e0) {
      exists(A a, B b, C c |
        base(a, b, c) and
        a0 = pja0(a, b, c) and
        b0 = pjb0(a, b, c) and
        c0 = pjc0(a, b, c) and
        d0 = pjd0(a, b, c) and
        e0 = pje0(a, b, c)
      )
    }
  }

  /**
   * Project this tuple set to a new tuple set of 6 values per row, by using a set of
   * projection functions.
   *
   * Sibling module of `ProjectRelate6` (which takes a set of "relations" instead of "functions").
   *
   * Each project function accepts the values of a tuple from this tuple set, and returns a new
   * value, where the value returned by the nth function will become the nth column in the new tuple
   * set.
   *
   * For example, the following projection switches (first, last) names to (last, first) names.
   * ```ql
   * predicate firstLast(string first, string last) { exists(Person p | ... ) }
   *
   * import Tp2<string, string, firstLast/2>
   *   ::Project2<string, string,
   *       Tuples2<string, string>::getFirst/2,
   *       Tuples2<string, string>::getSecond/2>
   *   as LastFirst
   *
   * // Selects ("Curie", "Maria"), ("Einstein", "Albert"), etc.
   * from string a, string b where LastFirst::tp(a, b) select a, b
   * ```
   */
  module Project6<
    InfiniteStringableType A0, InfiniteStringableType B0, InfiniteStringableType C0,
    InfiniteStringableType D0, InfiniteStringableType E0, InfiniteStringableType F0,
    FnType3<A0, A, B, C>::fn/3 pja0, FnType3<B0, A, B, C>::fn/3 pjb0,
    FnType3<C0, A, B, C>::fn/3 pjc0, FnType3<D0, A, B, C>::fn/3 pjd0,
    FnType3<E0, A, B, C>::fn/3 pje0, FnType3<F0, A, B, C>::fn/3 pjf0>
  {
    predicate tp(A0 a0, B0 b0, C0 c0, D0 d0, E0 e0, F0 f0) {
      exists(A a, B b, C c |
        base(a, b, c) and
        a0 = pja0(a, b, c) and
        b0 = pjb0(a, b, c) and
        c0 = pjc0(a, b, c) and
        d0 = pjd0(a, b, c) and
        e0 = pje0(a, b, c) and
        f0 = pjf0(a, b, c)
      )
    }
  }

  /**
   * Project this tuple set to a new tuple set of 6 values per row, by using a set of
   * relations.
   *
   * Sibling module of `Project6` (which takes a set of "functions" instead of "relations").
   *
   * Each projection relation accepts the values of a tuple from this tuple set, and returns a new
   * value, where the value held by the nth relation will become the nth column in the new tuple
   * set.
   *
   * For example, the following projection switches (first, last) names to (last, first) names.
   * ```ql
   * predicate siblings(Person a, Person b) { ... }
   * Person motherOf(Person a, Person b) { ... }
   * Person fatherOf(Person a, Person b) { ... }
   *
   * import Tp2<Person, Person, siblings/2>
   *     ::Project2<Person, Person, motherOf/2, fatherOf/2>
   *   as SiblingParents
   *
   * // Selects (mother, father) that have a pair of children
   * from Person mother, Person father where SiblingParents::tp(mother, father)
   * select mother, father
   * ```
   */
  module ProjectRelate6<
    InfiniteStringableType A0, InfiniteStringableType B0, InfiniteStringableType C0,
    InfiniteStringableType D0, InfiniteStringableType E0, InfiniteStringableType F0,
    RelType3<A0, A, B, C>::rel/3 pja0, RelType3<B0, A, B, C>::rel/3 pjb0,
    RelType3<C0, A, B, C>::rel/3 pjc0, RelType3<D0, A, B, C>::rel/3 pjd0,
    RelType3<E0, A, B, C>::rel/3 pje0, RelType3<F0, A, B, C>::rel/3 pjf0>
  {
    predicate tp(A0 a0, B0 b0, C0 c0, D0 d0, E0 e0, F0 f0) {
      exists(A a, B b, C c |
        base(a, b, c) and
        a0 = pja0(a, b, c) and
        b0 = pjb0(a, b, c) and
        c0 = pjc0(a, b, c) and
        d0 = pjd0(a, b, c) and
        e0 = pje0(a, b, c) and
        f0 = pjf0(a, b, c)
      )
    }
  }

  /**
   * Maps the set of first values in the set of tuples that satisfy the given predicate,
   * against a mapper function.
   *
   * Sibling function of `MapRelateFirst`, which operates on "relations" instead of
   * "functions."
   *
   * Example:
   * ```ql
   * predicate employs(Company company, Person person) { ... }
   *
   * // Selects the ages of employed People.
   * select Tp2<Company, Person, employs/2>
   *   ::MapSecond<int, getAge/1>
   *   ::find()
   * ```
   */
  module MapFirst<InfiniteStringableType R, FnType1<R, A>::fn/1 map> {
    R find() {
      exists(A a |
        base(a, _, _) and
        result = map(a)
      )
    }
  }

  /**
   * Maps the set of first values in the set of tuples that satisfy the given predicate,
   * against a mapper relation.
   *
   * Sibling function of `MapFirst`, which operates on "functions" instead of
   * "relations."
   *
   * Example:
   * ```ql
   * predicate employs(Company company, Person person) { ... }
   * Pet getPets(Person p) { ... }
   *
   * // Selects the pets of employed People.
   * select Tp2<Company, Person, employs/2>
   *   ::MapRelateSecond<Pet, getPets/1>
   *   ::find()
   * ```
   */
  module MapRelateFirst<InfiniteStringableType R, RelType1<R, A>::rel/1 map> {
    R find() {
      exists(A a |
        base(a, _, _) and
        result = map(a)
      )
    }
  }

  /**
   * Maps the set of second values in the set of tuples that satisfy the given predicate,
   * against a mapper function.
   *
   * Sibling function of `MapRelateSecond`, which operates on "relations" instead of
   * "functions."
   *
   * Example:
   * ```ql
   * predicate employs(Company company, Person person) { ... }
   *
   * // Selects the ages of employed People.
   * select Tp2<Company, Person, employs/2>
   *   ::MapSecond<int, getAge/1>
   *   ::find()
   * ```
   */
  module MapSecond<InfiniteStringableType R, FnType1<R, B>::fn/1 map> {
    R find() {
      exists(B b |
        base(_, b, _) and
        result = map(b)
      )
    }
  }

  /**
   * Maps the set of second values in the set of tuples that satisfy the given predicate,
   * against a mapper relation.
   *
   * Sibling function of `MapSecond`, which operates on "functions" instead of
   * "relations."
   *
   * Example:
   * ```ql
   * predicate employs(Company company, Person person) { ... }
   * Pet getPets(Person p) { ... }
   *
   * // Selects the pets of employed People.
   * select Tp2<Company, Person, employs/2>
   *   ::MapRelateSecond<Pet, getPets/1>
   *   ::find()
   * ```
   */
  module MapRelateSecond<InfiniteStringableType R, RelType1<R, B>::rel/1 map> {
    R find() {
      exists(B b |
        base(_, b, _) and
        result = map(b)
      )
    }
  }

  /**
   * Maps the set of third values in the set of tuples that satisfy the given predicate,
   * against a mapper function.
   *
   * Sibling function of `MapRelateThird`, which operates on "relations" instead of
   * "functions."
   *
   * Example:
   * ```ql
   * predicate employs(Company company, Person person) { ... }
   *
   * // Selects the ages of employed People.
   * select Tp2<Company, Person, employs/2>
   *   ::MapSecond<int, getAge/1>
   *   ::find()
   * ```
   */
  module MapThird<InfiniteStringableType R, FnType1<R, C>::fn/1 map> {
    R find() {
      exists(C c |
        base(_, _, c) and
        result = map(c)
      )
    }
  }

  /**
   * Maps the set of third values in the set of tuples that satisfy the given predicate,
   * against a mapper relation.
   *
   * Sibling function of `MapThird`, which operates on "functions" instead of
   * "relations."
   *
   * Example:
   * ```ql
   * predicate employs(Company company, Person person) { ... }
   * Pet getPets(Person p) { ... }
   *
   * // Selects the pets of employed People.
   * select Tp2<Company, Person, employs/2>
   *   ::MapRelateSecond<Pet, getPets/1>
   *   ::find()
   * ```
   */
  module MapRelateThird<InfiniteStringableType R, RelType1<R, C>::rel/1 map> {
    R find() {
      exists(C c |
        base(_, _, c) and
        result = map(c)
      )
    }
  }

  /**
   * Extend this tuple predicate to have an additional column, by intersecting it with a tuple
   * predicate with one additional parameter and all existing matching.
   */
  module ExtendIntersect<InfiniteStringableType Z, TpType4<A, B, C, Z>::tp/4 tp2> {
    predicate tp(A a, B b, C c, Z z) {
      base(a, b, c) and
      tp2(a, b, c, z)
    }
  }

  /**
   * Extend this tuple predicate to have an additional column, by running a provided function over
   * each tuple in this predicate's tuple set, and using the result of that function as the new
   * column.
   *
   * Sibling module of `ExtendByRelation`, which takes a "relation" instead of a "function."
   */
  module ExtendByFn<InfiniteStringableType R, FnType3<R, A, B, C>::fn/3 ext> {
    predicate tp(A a, B b, C c, R r) {
      base(a, b, c) and
      r = ext(a, b, c)
    }
  }

  /**
   * Extend this tuple predicate to have an additional column, by running a provided relation over
   * each tuple in this predicate's tuple set, and using the result of that relation as the new
   * column.
   *
   * Sibling module of `ExtendByFn`, which takes a "function" instead of a "relation."
   */
  module ExtendByRelation<InfiniteStringableType R, RelType3<R, A, B, C>::rel/3 ext> {
    predicate tp(A a, B b, C c, R r) {
      base(a, b, c) and
      r = ext(a, b, c)
    }
  }

  /**
   * Maps the set of first values in the set of tuples that satisfy the given predicate,
   * against a mapper function, and use the result to add a column to this tuple set.
   *
   * Sibling function of `ExtendRelateFirst`, which operates on "relations" instead of
   * "functions."
   *
   * Example:
   * ```ql
   * predicate hasName(Person person, string name) { ... }
   * string getInitials(string name) { ... }
   *
   * // Selects (person, name, initials)
   * import Tp2<Person, string, hasName/2>
   *   ::ExtendMapSecond<string, getInitials/1>
   *   ::Query
   * ```
   */
  module ExtendMapFirst<InfiniteStringableType R, FnType1<R, A>::fn/1 map> {
    predicate tp(A a, B b, C c, R r) {
      base(a, b, c) and
      r = map(a)
    }
  }

  /**
   * Maps the set of first values in the set of tuples that satisfy the given predicate,
   * against a mapper function, and use the result to add a column to this tuple set.
   *
   * Sibling function of `ExtendRelateFirst`, which operates on "relations" instead of
   * "functions."
   *
   * Example:
   * ```ql
   * predicate employs(Company company, Person person) { ... }
   * Address hasAddress(Person p) { ... }
   *
   * // Selects (company, person, age) for all employed people.
   * import Tp2<Company, Person, employs/2>
   *   ::ExtendRelateSecond<getAge/1>
   *   ::Query
   * ```
   */
  module ExtendRelateFirst<InfiniteStringableType R, RelType1<R, A>::rel/1 map> {
    predicate tp(A a, B b, C c, R r) {
      base(a, b, c) and
      r = map(a)
    }
  }

  /**
   * Maps the set of second values in the set of tuples that satisfy the given predicate,
   * against a mapper function, and use the result to add a column to this tuple set.
   *
   * Sibling function of `ExtendRelateSecond`, which operates on "relations" instead of
   * "functions."
   *
   * Example:
   * ```ql
   * predicate hasName(Person person, string name) { ... }
   * string getInitials(string name) { ... }
   *
   * // Selects (person, name, initials)
   * import Tp2<Person, string, hasName/2>
   *   ::ExtendMapSecond<string, getInitials/1>
   *   ::Query
   * ```
   */
  module ExtendMapSecond<InfiniteStringableType R, FnType1<R, B>::fn/1 map> {
    predicate tp(A a, B b, C c, R r) {
      base(a, b, c) and
      r = map(b)
    }
  }

  /**
   * Maps the set of second values in the set of tuples that satisfy the given predicate,
   * against a mapper function, and use the result to add a column to this tuple set.
   *
   * Sibling function of `ExtendRelateSecond`, which operates on "relations" instead of
   * "functions."
   *
   * Example:
   * ```ql
   * predicate employs(Company company, Person person) { ... }
   * Address hasAddress(Person p) { ... }
   *
   * // Selects (company, person, age) for all employed people.
   * import Tp2<Company, Person, employs/2>
   *   ::ExtendRelateSecond<getAge/1>
   *   ::Query
   * ```
   */
  module ExtendRelateSecond<InfiniteStringableType R, RelType1<R, B>::rel/1 map> {
    predicate tp(A a, B b, C c, R r) {
      base(a, b, c) and
      r = map(b)
    }
  }

  /**
   * Maps the set of third values in the set of tuples that satisfy the given predicate,
   * against a mapper function, and use the result to add a column to this tuple set.
   *
   * Sibling function of `ExtendRelateThird`, which operates on "relations" instead of
   * "functions."
   *
   * Example:
   * ```ql
   * predicate hasName(Person person, string name) { ... }
   * string getInitials(string name) { ... }
   *
   * // Selects (person, name, initials)
   * import Tp2<Person, string, hasName/2>
   *   ::ExtendMapSecond<string, getInitials/1>
   *   ::Query
   * ```
   */
  module ExtendMapThird<InfiniteStringableType R, FnType1<R, C>::fn/1 map> {
    predicate tp(A a, B b, C c, R r) {
      base(a, b, c) and
      r = map(c)
    }
  }

  /**
   * Maps the set of third values in the set of tuples that satisfy the given predicate,
   * against a mapper function, and use the result to add a column to this tuple set.
   *
   * Sibling function of `ExtendRelateThird`, which operates on "relations" instead of
   * "functions."
   *
   * Example:
   * ```ql
   * predicate employs(Company company, Person person) { ... }
   * Address hasAddress(Person p) { ... }
   *
   * // Selects (company, person, age) for all employed people.
   * import Tp2<Company, Person, employs/2>
   *   ::ExtendRelateSecond<getAge/1>
   *   ::Query
   * ```
   */
  module ExtendRelateThird<InfiniteStringableType R, RelType1<R, C>::rel/1 map> {
    predicate tp(A a, B b, C c, R r) {
      base(a, b, c) and
      r = map(c)
    }
  }

  /**
   * Takes a property which filters the contents of the current tuple set and produces a new one.
   *
   * Sibling predicate of `intersect`, which takes a "tuple predicate" instead of a "property."
   */
  module Filter<PropType3<A, B, C>::prop/3 flt> {
    predicate tp(A a, B b, C c) {
      flt(a, b, c) and
      base(a, b, c)
    }
  }

  /**
   * Takes a tuple set and intersects it with the current tuple set to produce a new one.
   *
   * Sibling predicate of `filter`, which takes a "property" instead of a "tuple set."
   */
  module Intersect<TpType3<A, B, C>::tp/3 tp2> {
    predicate tp(A a, B b, C c) {
      tp2(a, b, c) and
      base(a, b, c)
    }
  }

  /**
   * Creates a new tuple predicate that is a union of the current tuple set and the given one.
   */
  module Union<TpType3<A, B, C>::tp/3 tp2> {
    predicate tp(A a, B b, C c) {
      tp2(a, b, c) or
      base(a, b, c)
    }
  }

  /**
   * Creates a new tuple predicate that holds the elements only in the current tuple set, not the
   * given one.
   */
  module Difference<TpType3<A, B, C>::tp/3 tp2> {
    predicate tp(A a, B b, C c) {
      base(a, b, c) and
      not tp2(a, b, c)
    }
  }

  /**
   * Checks if (a, b, c, ...) is a member of the tuple set represented by this "tuple predicate."
   */
  predicate contains(A a, B b, C c) { base(a, b, c) }

  /**
   * A module with a single predicate, `holds`, that holds if the current tuple set contains all
   * of the tuples of the given tuple predicate `tp2`.
   */
  module ContainsAll<TpType3<A, B, C>::tp/3 tp2> {
    predicate holds() { forall(A a, B b, C c | tp2(a, b, c) | base(a, b, c)) }
  }

  /**
   * A module with a single predicate, `holds`, that holds if the current tuple set contains any
   * of the tuples of the given tuple predicate `tp2`.
   *
   * Sibling predicate of `AnyHoldsFor`, which takes a "property" instead of a "tuple predicate."
   */
  module ContainsAny<TpType3<A, B, C>::tp/3 tp2> {
    predicate holds() {
      exists(A a, B b, C c |
        tp2(a, b, c) and
        base(a, b, c)
      )
    }
  }

  /**
   * A module with a single predicate, `holds`, that holds if any of the tuples in the current tuple
   * satisfy the given property `prop`.
   *
   * Sibling predicate of `ContainsAny`, which takes a "tuple predicate" instead of a "property."
   */
  module AnyHoldsFor<PropType3<A, B, C>::prop/3 prop> {
    predicate holds() {
      exists(A a, B b, C c |
        base(a, b, c) and
        prop(a, b, c)
      )
    }
  }

  /**
   * A module with a single predicate, `holds`, that holds if all of the tuples in the current tuple
   * set satisfy the given property `prop`.
   *
   * Sibling predicate of `ContainedBy` which takes a "tuple predicate" instead of a "property."
   */
  module AllHoldsFor<PropType3<A, B, C>::prop/3 prop> {
    predicate holds() { forall(A a, B b, C c | base(a, b, c) | prop(a, b, c)) }
  }

  /**
   * A module with a single predicate, `holds`, that holds if all of the tuples in the current tuple
   * set satisfy the given property `prop`.
   *
   * Sibling predicate of `AllHoldsFor`, which takes a "property" instead of a "tuple predicate."
   */
  module ContainedBy<TpType3<A, B, C>::tp/3 tp2> {
    predicate holds() { forall(A a, B b, C c | base(a, b, c) | tp2(a, b, c)) }
  }

  /**
   * Drop the first column in the set of tuples that satisfy the given predicate, and get
   * a new tuple set after that column has been dropped.
   */
  predicate dropFirst(B b, C c) { base(_, b, c) }

  /**
   * Drop the second column in the set of tuples that satisfy the given predicate, and get
   * a new tuple set after that column has been dropped.
   */
  predicate dropSecond(A a, C c) { base(a, _, c) }

  /**
   * Drop the third column in the set of tuples that satisfy the given predicate, and get
   * a new tuple set after that column has been dropped.
   */
  predicate dropThird(A a, B b) { base(a, b, _) }

  /**
   * A basic, but very flexible join operation, taking a new tuple predicate to join as well as a
   * function for each that maps it to a value of type J.
   *
   * For instance, given sets of tuples `(a, b, c)` and `(d, e)` and join functions `(a, b, c) -> a`
   * and `(d, e) -> e`, this module will join both tuple sets on `a = e`.
   */
  module Join2ByFns<
    InfiniteStringableType J, InfiniteStringableType A0, InfiniteStringableType B0,
    TpType2<A0, B0>::tp/2 tp2, FnType2<J, A0, B0>::fn/2 tp2j, FnType3<J, A, B, C>::fn/3 tpj>
  {
    predicate tp(A a, B b, C c, A0 a0, B0 b0) {
      base(a, b, c) and
      tp2(a0, b0) and
      tpj(a, b, c) = tp2j(a0, b0)
    }
  }

  /**
   * A basic, but very flexible join operation, taking a new tuple predicate to join as well as a
   * function for each that maps it to a value of type J.
   *
   * For instance, given sets of tuples `(a, b, c)` and `(d, e)` and join functions `(a, b, c) -> a`
   * and `(d, e) -> e`, this module will join both tuple sets on `a = e`.
   */
  module Join3ByFns<
    InfiniteStringableType J, InfiniteStringableType A0, InfiniteStringableType B0,
    InfiniteStringableType C0, TpType3<A0, B0, C0>::tp/3 tp2, FnType3<J, A0, B0, C0>::fn/3 tp2j,
    FnType3<J, A, B, C>::fn/3 tpj>
  {
    predicate tp(A a, B b, C c, A0 a0, B0 b0, C0 c0) {
      base(a, b, c) and
      tp2(a0, b0, c0) and
      tpj(a, b, c) = tp2j(a0, b0, c0)
    }
  }

  /**
   * Count the number of tuples in this tuple set.
   */
  int doCount() { result = count(A a, B b, C c | base(a, b, c)) }

  /**
   * Query for the contents of this tuple, by defining a query predicate `tpQuery` to import.
   */
  module Query {
    query predicate tpQuery(A a, B b, C c) { base(a, b, c) }
  }
}

/**
 * A module for transforming a "Tuple predicate" with 4 arguments.
 *
 * In qtil speak:
 *  - a "Function" (FnX) is a predicate with a bindingset[] on all of its arguments, and a result
 *  - a "TuplePredicate " (TpX) is a predicate with finite arguments and no result
 *  - a "Relation" (RelX) is a predicate with finite arguments and a finite result
 *  - a "Property" (PropX) is a predicate with a bindingset[] on all arguments no result
 *
 * Essentially, a tuple predicate `Tp<A, B, C>` represents a finite set of tuples `(a, b, c)`. This
 * module accepts a tuple predicate (`predicate p(A, B, C)`) as an input, and offers functional
 * programming features on top of it such as `map` and `filter`, as well as some relational algebra
 * features such as projection and joins.
 *
 * Example:
 * ```ql
 * predicate livesIn(Person p, City c) { c = p.getCity() }
 * string describe(Person p, City c) { result = p.getName() + " lives in " + c.getName() }
 *
 * // selects "Peter lives in New York", "Wanda lives in London", ...
 * select Tp2<Person, City, livesIn/2>::Map<string, describe/2>::find()
 * ```
 */
module Tp4<
  InfiniteStringableType A, InfiniteStringableType B, InfiniteStringableType C,
  InfiniteStringableType D, TpType4<A, B, C, D>::tp/4 base>
{
  /**
   * Get the set of first values in the set of tuples that satisfy the given predicate.
   */
  A first() { base(result, _, _, _) }

  /**
   * Get the set of first values in the set of tuples that satisfy the given predicate.
   */
  module First {
    import Tp4<A, B, C, D, first/0>
  }

  /**
   * Get the set of second values in the set of tuples that satisfy the given predicate.
   */
  B second() { base(_, result, _, _) }

  /**
   * Get the set of second values in the set of tuples that satisfy the given predicate.
   */
  module Second {
    import Tp4<A, B, C, D, second/0>
  }

  /**
   * Get the set of third values in the set of tuples that satisfy the given predicate.
   */
  C third() { base(_, _, result, _) }

  /**
   * Get the set of third values in the set of tuples that satisfy the given predicate.
   */
  module Third {
    import Tp4<A, B, C, D, third/0>
  }

  /**
   * Get the set of fourth values in the set of tuples that satisfy the given predicate.
   */
  D fourth() { base(_, _, _, result) }

  /**
   * Get the set of fourth values in the set of tuples that satisfy the given predicate.
   */
  module Fourth {
    import Tp4<A, B, C, D, fourth/0>
  }

  /**
   * Map a function over the tuples in this tuple set, and get a new tuple predicate back
   * representing the set of tuples after being transformed by that function.
   *
   * Sibling module of `Relate` (which takes a "relation" instead of a "function").
   *
   * Note that this implicitly performs a "flatMap," as the mapping function may return zero or
   * more than one result per tuple.
   *
   * Example:
   * ```ql
   * predicate livesIn(Person p, City c) { c = p.getCity() }
   * string describe(Person p, City c) { result = p.getName() + " lives in " + c.getName() }
   *
   * // selects "Peter lives in New York", "Wanda lives in London", ...
   * select Tp2<Person, City, livesIn/2>::Map<string, describe/2>::find()
   * ```
   */
  module Map<InfiniteStringableType R, FnType4<R, A, B, C, D>::fn/4 map> {
    /**
     * Get the result of mapping the function `map` over the set of tuples represented by this
     * tuple predicate.
     *
     * For mapping a "relation" (as opposed to a "function") over this tuple set, see `MapRelate`.
     */
    R find() {
      exists(A a, B b, C c, D d |
        base(a, b, c, d) and
        result = map(a, b, c, d)
      )
    }
    // TODO: import ResultSet<R, find/0>
  }

  /**
   * Maps a relation over the tuples in this tuple set, and get a new tuple predicate back
   * representing the related values to the tuples in this set.
   *
   * Sibling module of `Map` (which takes a "function" instead of a "relation").
   *
   * Note that this implicitly performs an intersection with the domain tuple set of the given
   * relation.
   *
   * Example:
   * ```ql
   * predicate livesIn(Person p, City c) { c = p.getCity() }
   * Address hasMailingAddress(Person p, City c) { ... }
   *
   * // Selects the mailing addresses that correspond to the people, city in `livesIn`.
   * select Tp2<Person, City, livesIn/2>::Relate<Address, hasMailingAddress/2>::find()
   * ```
   *
   * To preserve `Person`, `City`, see `ExtendRelate`.
   */
  module Relate<InfiniteStringableType R, RelType4<R, A, B, C, D>::rel/4 r> {
    /**
     * Get the result of mapping the relation `r` over the set of tuples represented by this tuple
     * predicate.
     *
     * For mapping a "function" (as opposed to a "relation") over this tuple set, see `MapRelate`.
     */
    R find() {
      exists(A a, B b, C c, D d |
        base(a, b, c, d) and
        result = r(a, b, c, d)
      )
    }
    // TODO: import ResultSet<R, find/0>
  }

  /**
   * An alias for `Map`, but the result is a "tuple set" (a predicate(A a) with one parameter and no
   * result) instead of a `ResultSet` (a predicate `R pred()` with no parameters and result `R`).
   *
   * Sibling module of `ProjectRelate1` (which takes a "relation" instead of a "function").
   *
   * See `Map` for more details.
   */
  module Project1<InfiniteStringableType R, FnType4<R, A, B, C, D>::fn/4 map> {
    /**
     * A predicate tuple that represents the result of a projection, from the input tuple
     * predicate, to a new tuple predicate with a single column derived from applying a tuple to the
     * given function `map`.
     *
     * For projecting this tuple by a "relation" (as opposed to a "function"), see `ProjectRelate`.
     */
    predicate tp(R related) {
      exists(A a, B b, C c, D d |
        base(a, b, c, d) and
        related = map(a, b, c, d)
      )
    }
    // TODO: import Tp1<R, tp/1> ?
  }

  /**
   * An alias for `Relate`, but the result is a "tuple set" (a predicate(A a) with one parameter and no
   * result) instead of a `ResultSet` (a predicate `R pred()` with no parameters and result `R`).
   *
   * Sibling module of `Project1` (which takes a "function" instead of a "relation").
   *
   * See `Relate` for more details.
   */
  module ProjectRelate1<InfiniteStringableType R, RelType4<R, A, B, C, D>::rel/4 r> {
    /**
     * A predicate tuple that represents the result of a projection, from the input tuple
     * predicate, to a new tuple predicate with a single column derived from the given relation
     * `r`.
     *
     * For projecting this tuple by a "function" (as opposed to a "relation"), see `Project`.
     */
    predicate tp(R related) {
      exists(A a, B b, C c, D d |
        base(a, b, c, d) and
        related = r(a, b, c, d)
      )
    }
    // TODO: import Tp1<R, tp/1> ?
  }

  /**
   * Project this tuple set to a new tuple set of 2 values per row, by using a set of
   * projection functions.
   *
   * Sibling module of `ProjectRelate2` (which takes a set of "relations" instead of "functions").
   *
   * Each project function accepts the values of a tuple from this tuple set, and returns a new
   * value, where the value returned by the nth function will become the nth column in the new tuple
   * set.
   *
   * For example, the following projection switches (first, last) names to (last, first) names.
   * ```ql
   * predicate firstLast(string first, string last) { exists(Person p | ... ) }
   *
   * import Tp2<string, string, firstLast/2>
   *   ::Project2<string, string,
   *       Tuples2<string, string>::getFirst/2,
   *       Tuples2<string, string>::getSecond/2>
   *   as LastFirst
   *
   * // Selects ("Curie", "Maria"), ("Einstein", "Albert"), etc.
   * from string a, string b where LastFirst::tp(a, b) select a, b
   * ```
   */
  module Project2<
    InfiniteStringableType A0, InfiniteStringableType B0, FnType4<A0, A, B, C, D>::fn/4 pja0,
    FnType4<B0, A, B, C, D>::fn/4 pjb0>
  {
    predicate tp(A0 a0, B0 b0) {
      exists(A a, B b, C c, D d |
        base(a, b, c, d) and
        a0 = pja0(a, b, c, d) and
        b0 = pjb0(a, b, c, d)
      )
    }
  }

  /**
   * Project this tuple set to a new tuple set of 2 values per row, by using a set of
   * relations.
   *
   * Sibling module of `Project2` (which takes a set of "functions" instead of "relations").
   *
   * Each projection relation accepts the values of a tuple from this tuple set, and returns a new
   * value, where the value held by the nth relation will become the nth column in the new tuple
   * set.
   *
   * For example, the following projection switches (first, last) names to (last, first) names.
   * ```ql
   * predicate siblings(Person a, Person b) { ... }
   * Person motherOf(Person a, Person b) { ... }
   * Person fatherOf(Person a, Person b) { ... }
   *
   * import Tp2<Person, Person, siblings/2>
   *     ::Project2<Person, Person, motherOf/2, fatherOf/2>
   *   as SiblingParents
   *
   * // Selects (mother, father) that have a pair of children
   * from Person mother, Person father where SiblingParents::tp(mother, father)
   * select mother, father
   * ```
   */
  module ProjectRelate2<
    InfiniteStringableType A0, InfiniteStringableType B0, RelType4<A0, A, B, C, D>::rel/4 pja0,
    RelType4<B0, A, B, C, D>::rel/4 pjb0>
  {
    predicate tp(A0 a0, B0 b0) {
      exists(A a, B b, C c, D d |
        base(a, b, c, d) and
        a0 = pja0(a, b, c, d) and
        b0 = pjb0(a, b, c, d)
      )
    }
  }

  /**
   * Project this tuple set to a new tuple set of 3 values per row, by using a set of
   * projection functions.
   *
   * Sibling module of `ProjectRelate3` (which takes a set of "relations" instead of "functions").
   *
   * Each project function accepts the values of a tuple from this tuple set, and returns a new
   * value, where the value returned by the nth function will become the nth column in the new tuple
   * set.
   *
   * For example, the following projection switches (first, last) names to (last, first) names.
   * ```ql
   * predicate firstLast(string first, string last) { exists(Person p | ... ) }
   *
   * import Tp2<string, string, firstLast/2>
   *   ::Project2<string, string,
   *       Tuples2<string, string>::getFirst/2,
   *       Tuples2<string, string>::getSecond/2>
   *   as LastFirst
   *
   * // Selects ("Curie", "Maria"), ("Einstein", "Albert"), etc.
   * from string a, string b where LastFirst::tp(a, b) select a, b
   * ```
   */
  module Project3<
    InfiniteStringableType A0, InfiniteStringableType B0, InfiniteStringableType C0,
    FnType4<A0, A, B, C, D>::fn/4 pja0, FnType4<B0, A, B, C, D>::fn/4 pjb0,
    FnType4<C0, A, B, C, D>::fn/4 pjc0>
  {
    predicate tp(A0 a0, B0 b0, C0 c0) {
      exists(A a, B b, C c, D d |
        base(a, b, c, d) and
        a0 = pja0(a, b, c, d) and
        b0 = pjb0(a, b, c, d) and
        c0 = pjc0(a, b, c, d)
      )
    }
  }

  /**
   * Project this tuple set to a new tuple set of 3 values per row, by using a set of
   * relations.
   *
   * Sibling module of `Project3` (which takes a set of "functions" instead of "relations").
   *
   * Each projection relation accepts the values of a tuple from this tuple set, and returns a new
   * value, where the value held by the nth relation will become the nth column in the new tuple
   * set.
   *
   * For example, the following projection switches (first, last) names to (last, first) names.
   * ```ql
   * predicate siblings(Person a, Person b) { ... }
   * Person motherOf(Person a, Person b) { ... }
   * Person fatherOf(Person a, Person b) { ... }
   *
   * import Tp2<Person, Person, siblings/2>
   *     ::Project2<Person, Person, motherOf/2, fatherOf/2>
   *   as SiblingParents
   *
   * // Selects (mother, father) that have a pair of children
   * from Person mother, Person father where SiblingParents::tp(mother, father)
   * select mother, father
   * ```
   */
  module ProjectRelate3<
    InfiniteStringableType A0, InfiniteStringableType B0, InfiniteStringableType C0,
    RelType4<A0, A, B, C, D>::rel/4 pja0, RelType4<B0, A, B, C, D>::rel/4 pjb0,
    RelType4<C0, A, B, C, D>::rel/4 pjc0>
  {
    predicate tp(A0 a0, B0 b0, C0 c0) {
      exists(A a, B b, C c, D d |
        base(a, b, c, d) and
        a0 = pja0(a, b, c, d) and
        b0 = pjb0(a, b, c, d) and
        c0 = pjc0(a, b, c, d)
      )
    }
  }

  /**
   * Project this tuple set to a new tuple set of 4 values per row, by using a set of
   * projection functions.
   *
   * Sibling module of `ProjectRelate4` (which takes a set of "relations" instead of "functions").
   *
   * Each project function accepts the values of a tuple from this tuple set, and returns a new
   * value, where the value returned by the nth function will become the nth column in the new tuple
   * set.
   *
   * For example, the following projection switches (first, last) names to (last, first) names.
   * ```ql
   * predicate firstLast(string first, string last) { exists(Person p | ... ) }
   *
   * import Tp2<string, string, firstLast/2>
   *   ::Project2<string, string,
   *       Tuples2<string, string>::getFirst/2,
   *       Tuples2<string, string>::getSecond/2>
   *   as LastFirst
   *
   * // Selects ("Curie", "Maria"), ("Einstein", "Albert"), etc.
   * from string a, string b where LastFirst::tp(a, b) select a, b
   * ```
   */
  module Project4<
    InfiniteStringableType A0, InfiniteStringableType B0, InfiniteStringableType C0,
    InfiniteStringableType D0, FnType4<A0, A, B, C, D>::fn/4 pja0,
    FnType4<B0, A, B, C, D>::fn/4 pjb0, FnType4<C0, A, B, C, D>::fn/4 pjc0,
    FnType4<D0, A, B, C, D>::fn/4 pjd0>
  {
    predicate tp(A0 a0, B0 b0, C0 c0, D0 d0) {
      exists(A a, B b, C c, D d |
        base(a, b, c, d) and
        a0 = pja0(a, b, c, d) and
        b0 = pjb0(a, b, c, d) and
        c0 = pjc0(a, b, c, d) and
        d0 = pjd0(a, b, c, d)
      )
    }
  }

  /**
   * Project this tuple set to a new tuple set of 4 values per row, by using a set of
   * relations.
   *
   * Sibling module of `Project4` (which takes a set of "functions" instead of "relations").
   *
   * Each projection relation accepts the values of a tuple from this tuple set, and returns a new
   * value, where the value held by the nth relation will become the nth column in the new tuple
   * set.
   *
   * For example, the following projection switches (first, last) names to (last, first) names.
   * ```ql
   * predicate siblings(Person a, Person b) { ... }
   * Person motherOf(Person a, Person b) { ... }
   * Person fatherOf(Person a, Person b) { ... }
   *
   * import Tp2<Person, Person, siblings/2>
   *     ::Project2<Person, Person, motherOf/2, fatherOf/2>
   *   as SiblingParents
   *
   * // Selects (mother, father) that have a pair of children
   * from Person mother, Person father where SiblingParents::tp(mother, father)
   * select mother, father
   * ```
   */
  module ProjectRelate4<
    InfiniteStringableType A0, InfiniteStringableType B0, InfiniteStringableType C0,
    InfiniteStringableType D0, RelType4<A0, A, B, C, D>::rel/4 pja0,
    RelType4<B0, A, B, C, D>::rel/4 pjb0, RelType4<C0, A, B, C, D>::rel/4 pjc0,
    RelType4<D0, A, B, C, D>::rel/4 pjd0>
  {
    predicate tp(A0 a0, B0 b0, C0 c0, D0 d0) {
      exists(A a, B b, C c, D d |
        base(a, b, c, d) and
        a0 = pja0(a, b, c, d) and
        b0 = pjb0(a, b, c, d) and
        c0 = pjc0(a, b, c, d) and
        d0 = pjd0(a, b, c, d)
      )
    }
  }

  /**
   * Project this tuple set to a new tuple set of 5 values per row, by using a set of
   * projection functions.
   *
   * Sibling module of `ProjectRelate5` (which takes a set of "relations" instead of "functions").
   *
   * Each project function accepts the values of a tuple from this tuple set, and returns a new
   * value, where the value returned by the nth function will become the nth column in the new tuple
   * set.
   *
   * For example, the following projection switches (first, last) names to (last, first) names.
   * ```ql
   * predicate firstLast(string first, string last) { exists(Person p | ... ) }
   *
   * import Tp2<string, string, firstLast/2>
   *   ::Project2<string, string,
   *       Tuples2<string, string>::getFirst/2,
   *       Tuples2<string, string>::getSecond/2>
   *   as LastFirst
   *
   * // Selects ("Curie", "Maria"), ("Einstein", "Albert"), etc.
   * from string a, string b where LastFirst::tp(a, b) select a, b
   * ```
   */
  module Project5<
    InfiniteStringableType A0, InfiniteStringableType B0, InfiniteStringableType C0,
    InfiniteStringableType D0, InfiniteStringableType E0, FnType4<A0, A, B, C, D>::fn/4 pja0,
    FnType4<B0, A, B, C, D>::fn/4 pjb0, FnType4<C0, A, B, C, D>::fn/4 pjc0,
    FnType4<D0, A, B, C, D>::fn/4 pjd0, FnType4<E0, A, B, C, D>::fn/4 pje0>
  {
    predicate tp(A0 a0, B0 b0, C0 c0, D0 d0, E0 e0) {
      exists(A a, B b, C c, D d |
        base(a, b, c, d) and
        a0 = pja0(a, b, c, d) and
        b0 = pjb0(a, b, c, d) and
        c0 = pjc0(a, b, c, d) and
        d0 = pjd0(a, b, c, d) and
        e0 = pje0(a, b, c, d)
      )
    }
  }

  /**
   * Project this tuple set to a new tuple set of 5 values per row, by using a set of
   * relations.
   *
   * Sibling module of `Project5` (which takes a set of "functions" instead of "relations").
   *
   * Each projection relation accepts the values of a tuple from this tuple set, and returns a new
   * value, where the value held by the nth relation will become the nth column in the new tuple
   * set.
   *
   * For example, the following projection switches (first, last) names to (last, first) names.
   * ```ql
   * predicate siblings(Person a, Person b) { ... }
   * Person motherOf(Person a, Person b) { ... }
   * Person fatherOf(Person a, Person b) { ... }
   *
   * import Tp2<Person, Person, siblings/2>
   *     ::Project2<Person, Person, motherOf/2, fatherOf/2>
   *   as SiblingParents
   *
   * // Selects (mother, father) that have a pair of children
   * from Person mother, Person father where SiblingParents::tp(mother, father)
   * select mother, father
   * ```
   */
  module ProjectRelate5<
    InfiniteStringableType A0, InfiniteStringableType B0, InfiniteStringableType C0,
    InfiniteStringableType D0, InfiniteStringableType E0, RelType4<A0, A, B, C, D>::rel/4 pja0,
    RelType4<B0, A, B, C, D>::rel/4 pjb0, RelType4<C0, A, B, C, D>::rel/4 pjc0,
    RelType4<D0, A, B, C, D>::rel/4 pjd0, RelType4<E0, A, B, C, D>::rel/4 pje0>
  {
    predicate tp(A0 a0, B0 b0, C0 c0, D0 d0, E0 e0) {
      exists(A a, B b, C c, D d |
        base(a, b, c, d) and
        a0 = pja0(a, b, c, d) and
        b0 = pjb0(a, b, c, d) and
        c0 = pjc0(a, b, c, d) and
        d0 = pjd0(a, b, c, d) and
        e0 = pje0(a, b, c, d)
      )
    }
  }

  /**
   * Project this tuple set to a new tuple set of 6 values per row, by using a set of
   * projection functions.
   *
   * Sibling module of `ProjectRelate6` (which takes a set of "relations" instead of "functions").
   *
   * Each project function accepts the values of a tuple from this tuple set, and returns a new
   * value, where the value returned by the nth function will become the nth column in the new tuple
   * set.
   *
   * For example, the following projection switches (first, last) names to (last, first) names.
   * ```ql
   * predicate firstLast(string first, string last) { exists(Person p | ... ) }
   *
   * import Tp2<string, string, firstLast/2>
   *   ::Project2<string, string,
   *       Tuples2<string, string>::getFirst/2,
   *       Tuples2<string, string>::getSecond/2>
   *   as LastFirst
   *
   * // Selects ("Curie", "Maria"), ("Einstein", "Albert"), etc.
   * from string a, string b where LastFirst::tp(a, b) select a, b
   * ```
   */
  module Project6<
    InfiniteStringableType A0, InfiniteStringableType B0, InfiniteStringableType C0,
    InfiniteStringableType D0, InfiniteStringableType E0, InfiniteStringableType F0,
    FnType4<A0, A, B, C, D>::fn/4 pja0, FnType4<B0, A, B, C, D>::fn/4 pjb0,
    FnType4<C0, A, B, C, D>::fn/4 pjc0, FnType4<D0, A, B, C, D>::fn/4 pjd0,
    FnType4<E0, A, B, C, D>::fn/4 pje0, FnType4<F0, A, B, C, D>::fn/4 pjf0>
  {
    predicate tp(A0 a0, B0 b0, C0 c0, D0 d0, E0 e0, F0 f0) {
      exists(A a, B b, C c, D d |
        base(a, b, c, d) and
        a0 = pja0(a, b, c, d) and
        b0 = pjb0(a, b, c, d) and
        c0 = pjc0(a, b, c, d) and
        d0 = pjd0(a, b, c, d) and
        e0 = pje0(a, b, c, d) and
        f0 = pjf0(a, b, c, d)
      )
    }
  }

  /**
   * Project this tuple set to a new tuple set of 6 values per row, by using a set of
   * relations.
   *
   * Sibling module of `Project6` (which takes a set of "functions" instead of "relations").
   *
   * Each projection relation accepts the values of a tuple from this tuple set, and returns a new
   * value, where the value held by the nth relation will become the nth column in the new tuple
   * set.
   *
   * For example, the following projection switches (first, last) names to (last, first) names.
   * ```ql
   * predicate siblings(Person a, Person b) { ... }
   * Person motherOf(Person a, Person b) { ... }
   * Person fatherOf(Person a, Person b) { ... }
   *
   * import Tp2<Person, Person, siblings/2>
   *     ::Project2<Person, Person, motherOf/2, fatherOf/2>
   *   as SiblingParents
   *
   * // Selects (mother, father) that have a pair of children
   * from Person mother, Person father where SiblingParents::tp(mother, father)
   * select mother, father
   * ```
   */
  module ProjectRelate6<
    InfiniteStringableType A0, InfiniteStringableType B0, InfiniteStringableType C0,
    InfiniteStringableType D0, InfiniteStringableType E0, InfiniteStringableType F0,
    RelType4<A0, A, B, C, D>::rel/4 pja0, RelType4<B0, A, B, C, D>::rel/4 pjb0,
    RelType4<C0, A, B, C, D>::rel/4 pjc0, RelType4<D0, A, B, C, D>::rel/4 pjd0,
    RelType4<E0, A, B, C, D>::rel/4 pje0, RelType4<F0, A, B, C, D>::rel/4 pjf0>
  {
    predicate tp(A0 a0, B0 b0, C0 c0, D0 d0, E0 e0, F0 f0) {
      exists(A a, B b, C c, D d |
        base(a, b, c, d) and
        a0 = pja0(a, b, c, d) and
        b0 = pjb0(a, b, c, d) and
        c0 = pjc0(a, b, c, d) and
        d0 = pjd0(a, b, c, d) and
        e0 = pje0(a, b, c, d) and
        f0 = pjf0(a, b, c, d)
      )
    }
  }

  /**
   * Maps the set of first values in the set of tuples that satisfy the given predicate,
   * against a mapper function.
   *
   * Sibling function of `MapRelateFirst`, which operates on "relations" instead of
   * "functions."
   *
   * Example:
   * ```ql
   * predicate employs(Company company, Person person) { ... }
   *
   * // Selects the ages of employed People.
   * select Tp2<Company, Person, employs/2>
   *   ::MapSecond<int, getAge/1>
   *   ::find()
   * ```
   */
  module MapFirst<InfiniteStringableType R, FnType1<R, A>::fn/1 map> {
    R find() {
      exists(A a |
        base(a, _, _, _) and
        result = map(a)
      )
    }
  }

  /**
   * Maps the set of first values in the set of tuples that satisfy the given predicate,
   * against a mapper relation.
   *
   * Sibling function of `MapFirst`, which operates on "functions" instead of
   * "relations."
   *
   * Example:
   * ```ql
   * predicate employs(Company company, Person person) { ... }
   * Pet getPets(Person p) { ... }
   *
   * // Selects the pets of employed People.
   * select Tp2<Company, Person, employs/2>
   *   ::MapRelateSecond<Pet, getPets/1>
   *   ::find()
   * ```
   */
  module MapRelateFirst<InfiniteStringableType R, RelType1<R, A>::rel/1 map> {
    R find() {
      exists(A a |
        base(a, _, _, _) and
        result = map(a)
      )
    }
  }

  /**
   * Maps the set of second values in the set of tuples that satisfy the given predicate,
   * against a mapper function.
   *
   * Sibling function of `MapRelateSecond`, which operates on "relations" instead of
   * "functions."
   *
   * Example:
   * ```ql
   * predicate employs(Company company, Person person) { ... }
   *
   * // Selects the ages of employed People.
   * select Tp2<Company, Person, employs/2>
   *   ::MapSecond<int, getAge/1>
   *   ::find()
   * ```
   */
  module MapSecond<InfiniteStringableType R, FnType1<R, B>::fn/1 map> {
    R find() {
      exists(B b |
        base(_, b, _, _) and
        result = map(b)
      )
    }
  }

  /**
   * Maps the set of second values in the set of tuples that satisfy the given predicate,
   * against a mapper relation.
   *
   * Sibling function of `MapSecond`, which operates on "functions" instead of
   * "relations."
   *
   * Example:
   * ```ql
   * predicate employs(Company company, Person person) { ... }
   * Pet getPets(Person p) { ... }
   *
   * // Selects the pets of employed People.
   * select Tp2<Company, Person, employs/2>
   *   ::MapRelateSecond<Pet, getPets/1>
   *   ::find()
   * ```
   */
  module MapRelateSecond<InfiniteStringableType R, RelType1<R, B>::rel/1 map> {
    R find() {
      exists(B b |
        base(_, b, _, _) and
        result = map(b)
      )
    }
  }

  /**
   * Maps the set of third values in the set of tuples that satisfy the given predicate,
   * against a mapper function.
   *
   * Sibling function of `MapRelateThird`, which operates on "relations" instead of
   * "functions."
   *
   * Example:
   * ```ql
   * predicate employs(Company company, Person person) { ... }
   *
   * // Selects the ages of employed People.
   * select Tp2<Company, Person, employs/2>
   *   ::MapSecond<int, getAge/1>
   *   ::find()
   * ```
   */
  module MapThird<InfiniteStringableType R, FnType1<R, C>::fn/1 map> {
    R find() {
      exists(C c |
        base(_, _, c, _) and
        result = map(c)
      )
    }
  }

  /**
   * Maps the set of third values in the set of tuples that satisfy the given predicate,
   * against a mapper relation.
   *
   * Sibling function of `MapThird`, which operates on "functions" instead of
   * "relations."
   *
   * Example:
   * ```ql
   * predicate employs(Company company, Person person) { ... }
   * Pet getPets(Person p) { ... }
   *
   * // Selects the pets of employed People.
   * select Tp2<Company, Person, employs/2>
   *   ::MapRelateSecond<Pet, getPets/1>
   *   ::find()
   * ```
   */
  module MapRelateThird<InfiniteStringableType R, RelType1<R, C>::rel/1 map> {
    R find() {
      exists(C c |
        base(_, _, c, _) and
        result = map(c)
      )
    }
  }

  /**
   * Maps the set of fourth values in the set of tuples that satisfy the given predicate,
   * against a mapper function.
   *
   * Sibling function of `MapRelateFourth`, which operates on "relations" instead of
   * "functions."
   *
   * Example:
   * ```ql
   * predicate employs(Company company, Person person) { ... }
   *
   * // Selects the ages of employed People.
   * select Tp2<Company, Person, employs/2>
   *   ::MapSecond<int, getAge/1>
   *   ::find()
   * ```
   */
  module MapFourth<InfiniteStringableType R, FnType1<R, D>::fn/1 map> {
    R find() {
      exists(D d |
        base(_, _, _, d) and
        result = map(d)
      )
    }
  }

  /**
   * Maps the set of fourth values in the set of tuples that satisfy the given predicate,
   * against a mapper relation.
   *
   * Sibling function of `MapFourth`, which operates on "functions" instead of
   * "relations."
   *
   * Example:
   * ```ql
   * predicate employs(Company company, Person person) { ... }
   * Pet getPets(Person p) { ... }
   *
   * // Selects the pets of employed People.
   * select Tp2<Company, Person, employs/2>
   *   ::MapRelateSecond<Pet, getPets/1>
   *   ::find()
   * ```
   */
  module MapRelateFourth<InfiniteStringableType R, RelType1<R, D>::rel/1 map> {
    R find() {
      exists(D d |
        base(_, _, _, d) and
        result = map(d)
      )
    }
  }

  /**
   * Extend this tuple predicate to have an additional column, by intersecting it with a tuple
   * predicate with one additional parameter and all existing matching.
   */
  module ExtendIntersect<InfiniteStringableType Z, TpType5<A, B, C, D, Z>::tp/5 tp2> {
    predicate tp(A a, B b, C c, D d, Z z) {
      base(a, b, c, d) and
      tp2(a, b, c, d, z)
    }
  }

  /**
   * Extend this tuple predicate to have an additional column, by running a provided function over
   * each tuple in this predicate's tuple set, and using the result of that function as the new
   * column.
   *
   * Sibling module of `ExtendByRelation`, which takes a "relation" instead of a "function."
   */
  module ExtendByFn<InfiniteStringableType R, FnType4<R, A, B, C, D>::fn/4 ext> {
    predicate tp(A a, B b, C c, D d, R r) {
      base(a, b, c, d) and
      r = ext(a, b, c, d)
    }
  }

  /**
   * Extend this tuple predicate to have an additional column, by running a provided relation over
   * each tuple in this predicate's tuple set, and using the result of that relation as the new
   * column.
   *
   * Sibling module of `ExtendByFn`, which takes a "function" instead of a "relation."
   */
  module ExtendByRelation<InfiniteStringableType R, RelType4<R, A, B, C, D>::rel/4 ext> {
    predicate tp(A a, B b, C c, D d, R r) {
      base(a, b, c, d) and
      r = ext(a, b, c, d)
    }
  }

  /**
   * Maps the set of first values in the set of tuples that satisfy the given predicate,
   * against a mapper function, and use the result to add a column to this tuple set.
   *
   * Sibling function of `ExtendRelateFirst`, which operates on "relations" instead of
   * "functions."
   *
   * Example:
   * ```ql
   * predicate hasName(Person person, string name) { ... }
   * string getInitials(string name) { ... }
   *
   * // Selects (person, name, initials)
   * import Tp2<Person, string, hasName/2>
   *   ::ExtendMapSecond<string, getInitials/1>
   *   ::Query
   * ```
   */
  module ExtendMapFirst<InfiniteStringableType R, FnType1<R, A>::fn/1 map> {
    predicate tp(A a, B b, C c, D d, R r) {
      base(a, b, c, d) and
      r = map(a)
    }
  }

  /**
   * Maps the set of first values in the set of tuples that satisfy the given predicate,
   * against a mapper function, and use the result to add a column to this tuple set.
   *
   * Sibling function of `ExtendRelateFirst`, which operates on "relations" instead of
   * "functions."
   *
   * Example:
   * ```ql
   * predicate employs(Company company, Person person) { ... }
   * Address hasAddress(Person p) { ... }
   *
   * // Selects (company, person, age) for all employed people.
   * import Tp2<Company, Person, employs/2>
   *   ::ExtendRelateSecond<getAge/1>
   *   ::Query
   * ```
   */
  module ExtendRelateFirst<InfiniteStringableType R, RelType1<R, A>::rel/1 map> {
    predicate tp(A a, B b, C c, D d, R r) {
      base(a, b, c, d) and
      r = map(a)
    }
  }

  /**
   * Maps the set of second values in the set of tuples that satisfy the given predicate,
   * against a mapper function, and use the result to add a column to this tuple set.
   *
   * Sibling function of `ExtendRelateSecond`, which operates on "relations" instead of
   * "functions."
   *
   * Example:
   * ```ql
   * predicate hasName(Person person, string name) { ... }
   * string getInitials(string name) { ... }
   *
   * // Selects (person, name, initials)
   * import Tp2<Person, string, hasName/2>
   *   ::ExtendMapSecond<string, getInitials/1>
   *   ::Query
   * ```
   */
  module ExtendMapSecond<InfiniteStringableType R, FnType1<R, B>::fn/1 map> {
    predicate tp(A a, B b, C c, D d, R r) {
      base(a, b, c, d) and
      r = map(b)
    }
  }

  /**
   * Maps the set of second values in the set of tuples that satisfy the given predicate,
   * against a mapper function, and use the result to add a column to this tuple set.
   *
   * Sibling function of `ExtendRelateSecond`, which operates on "relations" instead of
   * "functions."
   *
   * Example:
   * ```ql
   * predicate employs(Company company, Person person) { ... }
   * Address hasAddress(Person p) { ... }
   *
   * // Selects (company, person, age) for all employed people.
   * import Tp2<Company, Person, employs/2>
   *   ::ExtendRelateSecond<getAge/1>
   *   ::Query
   * ```
   */
  module ExtendRelateSecond<InfiniteStringableType R, RelType1<R, B>::rel/1 map> {
    predicate tp(A a, B b, C c, D d, R r) {
      base(a, b, c, d) and
      r = map(b)
    }
  }

  /**
   * Maps the set of third values in the set of tuples that satisfy the given predicate,
   * against a mapper function, and use the result to add a column to this tuple set.
   *
   * Sibling function of `ExtendRelateThird`, which operates on "relations" instead of
   * "functions."
   *
   * Example:
   * ```ql
   * predicate hasName(Person person, string name) { ... }
   * string getInitials(string name) { ... }
   *
   * // Selects (person, name, initials)
   * import Tp2<Person, string, hasName/2>
   *   ::ExtendMapSecond<string, getInitials/1>
   *   ::Query
   * ```
   */
  module ExtendMapThird<InfiniteStringableType R, FnType1<R, C>::fn/1 map> {
    predicate tp(A a, B b, C c, D d, R r) {
      base(a, b, c, d) and
      r = map(c)
    }
  }

  /**
   * Maps the set of third values in the set of tuples that satisfy the given predicate,
   * against a mapper function, and use the result to add a column to this tuple set.
   *
   * Sibling function of `ExtendRelateThird`, which operates on "relations" instead of
   * "functions."
   *
   * Example:
   * ```ql
   * predicate employs(Company company, Person person) { ... }
   * Address hasAddress(Person p) { ... }
   *
   * // Selects (company, person, age) for all employed people.
   * import Tp2<Company, Person, employs/2>
   *   ::ExtendRelateSecond<getAge/1>
   *   ::Query
   * ```
   */
  module ExtendRelateThird<InfiniteStringableType R, RelType1<R, C>::rel/1 map> {
    predicate tp(A a, B b, C c, D d, R r) {
      base(a, b, c, d) and
      r = map(c)
    }
  }

  /**
   * Maps the set of fourth values in the set of tuples that satisfy the given predicate,
   * against a mapper function, and use the result to add a column to this tuple set.
   *
   * Sibling function of `ExtendRelateFourth`, which operates on "relations" instead of
   * "functions."
   *
   * Example:
   * ```ql
   * predicate hasName(Person person, string name) { ... }
   * string getInitials(string name) { ... }
   *
   * // Selects (person, name, initials)
   * import Tp2<Person, string, hasName/2>
   *   ::ExtendMapSecond<string, getInitials/1>
   *   ::Query
   * ```
   */
  module ExtendMapFourth<InfiniteStringableType R, FnType1<R, D>::fn/1 map> {
    predicate tp(A a, B b, C c, D d, R r) {
      base(a, b, c, d) and
      r = map(d)
    }
  }

  /**
   * Maps the set of fourth values in the set of tuples that satisfy the given predicate,
   * against a mapper function, and use the result to add a column to this tuple set.
   *
   * Sibling function of `ExtendRelateFourth`, which operates on "relations" instead of
   * "functions."
   *
   * Example:
   * ```ql
   * predicate employs(Company company, Person person) { ... }
   * Address hasAddress(Person p) { ... }
   *
   * // Selects (company, person, age) for all employed people.
   * import Tp2<Company, Person, employs/2>
   *   ::ExtendRelateSecond<getAge/1>
   *   ::Query
   * ```
   */
  module ExtendRelateFourth<InfiniteStringableType R, RelType1<R, D>::rel/1 map> {
    predicate tp(A a, B b, C c, D d, R r) {
      base(a, b, c, d) and
      r = map(d)
    }
  }

  /**
   * Takes a property which filters the contents of the current tuple set and produces a new one.
   *
   * Sibling predicate of `intersect`, which takes a "tuple predicate" instead of a "property."
   */
  module Filter<PropType4<A, B, C, D>::prop/4 flt> {
    predicate tp(A a, B b, C c, D d) {
      flt(a, b, c, d) and
      base(a, b, c, d)
    }
  }

  /**
   * Takes a tuple set and intersects it with the current tuple set to produce a new one.
   *
   * Sibling predicate of `filter`, which takes a "property" instead of a "tuple set."
   */
  module Intersect<TpType4<A, B, C, D>::tp/4 tp2> {
    predicate tp(A a, B b, C c, D d) {
      tp2(a, b, c, d) and
      base(a, b, c, d)
    }
  }

  /**
   * Creates a new tuple predicate that is a union of the current tuple set and the given one.
   */
  module Union<TpType4<A, B, C, D>::tp/4 tp2> {
    predicate tp(A a, B b, C c, D d) {
      tp2(a, b, c, d) or
      base(a, b, c, d)
    }
  }

  /**
   * Creates a new tuple predicate that holds the elements only in the current tuple set, not the
   * given one.
   */
  module Difference<TpType4<A, B, C, D>::tp/4 tp2> {
    predicate tp(A a, B b, C c, D d) {
      base(a, b, c, d) and
      not tp2(a, b, c, d)
    }
  }

  /**
   * Checks if (a, b, c, ...) is a member of the tuple set represented by this "tuple predicate."
   */
  predicate contains(A a, B b, C c, D d) { base(a, b, c, d) }

  /**
   * A module with a single predicate, `holds`, that holds if the current tuple set contains all
   * of the tuples of the given tuple predicate `tp2`.
   */
  module ContainsAll<TpType4<A, B, C, D>::tp/4 tp2> {
    predicate holds() { forall(A a, B b, C c, D d | tp2(a, b, c, d) | base(a, b, c, d)) }
  }

  /**
   * A module with a single predicate, `holds`, that holds if the current tuple set contains any
   * of the tuples of the given tuple predicate `tp2`.
   *
   * Sibling predicate of `AnyHoldsFor`, which takes a "property" instead of a "tuple predicate."
   */
  module ContainsAny<TpType4<A, B, C, D>::tp/4 tp2> {
    predicate holds() {
      exists(A a, B b, C c, D d |
        tp2(a, b, c, d) and
        base(a, b, c, d)
      )
    }
  }

  /**
   * A module with a single predicate, `holds`, that holds if any of the tuples in the current tuple
   * satisfy the given property `prop`.
   *
   * Sibling predicate of `ContainsAny`, which takes a "tuple predicate" instead of a "property."
   */
  module AnyHoldsFor<PropType4<A, B, C, D>::prop/4 prop> {
    predicate holds() {
      exists(A a, B b, C c, D d |
        base(a, b, c, d) and
        prop(a, b, c, d)
      )
    }
  }

  /**
   * A module with a single predicate, `holds`, that holds if all of the tuples in the current tuple
   * set satisfy the given property `prop`.
   *
   * Sibling predicate of `ContainedBy` which takes a "tuple predicate" instead of a "property."
   */
  module AllHoldsFor<PropType4<A, B, C, D>::prop/4 prop> {
    predicate holds() { forall(A a, B b, C c, D d | base(a, b, c, d) | prop(a, b, c, d)) }
  }

  /**
   * A module with a single predicate, `holds`, that holds if all of the tuples in the current tuple
   * set satisfy the given property `prop`.
   *
   * Sibling predicate of `AllHoldsFor`, which takes a "property" instead of a "tuple predicate."
   */
  module ContainedBy<TpType4<A, B, C, D>::tp/4 tp2> {
    predicate holds() { forall(A a, B b, C c, D d | base(a, b, c, d) | tp2(a, b, c, d)) }
  }

  /**
   * Drop the first column in the set of tuples that satisfy the given predicate, and get
   * a new tuple set after that column has been dropped.
   */
  predicate dropFirst(B b, C c, D d) { base(_, b, c, d) }

  /**
   * Drop the second column in the set of tuples that satisfy the given predicate, and get
   * a new tuple set after that column has been dropped.
   */
  predicate dropSecond(A a, C c, D d) { base(a, _, c, d) }

  /**
   * Drop the third column in the set of tuples that satisfy the given predicate, and get
   * a new tuple set after that column has been dropped.
   */
  predicate dropThird(A a, B b, D d) { base(a, b, _, d) }

  /**
   * Drop the fourth column in the set of tuples that satisfy the given predicate, and get
   * a new tuple set after that column has been dropped.
   */
  predicate dropFourth(A a, B b, C c) { base(a, b, c, _) }

  /**
   * A basic, but very flexible join operation, taking a new tuple predicate to join as well as a
   * function for each that maps it to a value of type J.
   *
   * For instance, given sets of tuples `(a, b, c)` and `(d, e)` and join functions `(a, b, c) -> a`
   * and `(d, e) -> e`, this module will join both tuple sets on `a = e`.
   */
  module Join2ByFns<
    InfiniteStringableType J, InfiniteStringableType A0, InfiniteStringableType B0,
    TpType2<A0, B0>::tp/2 tp2, FnType2<J, A0, B0>::fn/2 tp2j, FnType4<J, A, B, C, D>::fn/4 tpj>
  {
    predicate tp(A a, B b, C c, D d, A0 a0, B0 b0) {
      base(a, b, c, d) and
      tp2(a0, b0) and
      tpj(a, b, c, d) = tp2j(a0, b0)
    }
  }

  /**
   * Count the number of tuples in this tuple set.
   */
  int doCount() { result = count(A a, B b, C c, D d | base(a, b, c, d)) }

  /**
   * Query for the contents of this tuple, by defining a query predicate `tpQuery` to import.
   */
  module Query {
    query predicate tpQuery(A a, B b, C c, D d) { base(a, b, c, d) }
  }
}

/**
 * A module for transforming a "Tuple predicate" with 5 arguments.
 *
 * In qtil speak:
 *  - a "Function" (FnX) is a predicate with a bindingset[] on all of its arguments, and a result
 *  - a "TuplePredicate " (TpX) is a predicate with finite arguments and no result
 *  - a "Relation" (RelX) is a predicate with finite arguments and a finite result
 *  - a "Property" (PropX) is a predicate with a bindingset[] on all arguments no result
 *
 * Essentially, a tuple predicate `Tp<A, B, C>` represents a finite set of tuples `(a, b, c)`. This
 * module accepts a tuple predicate (`predicate p(A, B, C)`) as an input, and offers functional
 * programming features on top of it such as `map` and `filter`, as well as some relational algebra
 * features such as projection and joins.
 *
 * Example:
 * ```ql
 * predicate livesIn(Person p, City c) { c = p.getCity() }
 * string describe(Person p, City c) { result = p.getName() + " lives in " + c.getName() }
 *
 * // selects "Peter lives in New York", "Wanda lives in London", ...
 * select Tp2<Person, City, livesIn/2>::Map<string, describe/2>::find()
 * ```
 */
module Tp5<
  InfiniteStringableType A, InfiniteStringableType B, InfiniteStringableType C,
  InfiniteStringableType D, InfiniteStringableType E, TpType5<A, B, C, D, E>::tp/5 base>
{
  /**
   * Get the set of first values in the set of tuples that satisfy the given predicate.
   */
  A first() { base(result, _, _, _, _) }

  /**
   * Get the set of first values in the set of tuples that satisfy the given predicate.
   */
  module First {
    import Tp5<A, B, C, D, E, first/0>
  }

  /**
   * Get the set of second values in the set of tuples that satisfy the given predicate.
   */
  B second() { base(_, result, _, _, _) }

  /**
   * Get the set of second values in the set of tuples that satisfy the given predicate.
   */
  module Second {
    import Tp5<A, B, C, D, E, second/0>
  }

  /**
   * Get the set of third values in the set of tuples that satisfy the given predicate.
   */
  C third() { base(_, _, result, _, _) }

  /**
   * Get the set of third values in the set of tuples that satisfy the given predicate.
   */
  module Third {
    import Tp5<A, B, C, D, E, third/0>
  }

  /**
   * Get the set of fourth values in the set of tuples that satisfy the given predicate.
   */
  D fourth() { base(_, _, _, result, _) }

  /**
   * Get the set of fourth values in the set of tuples that satisfy the given predicate.
   */
  module Fourth {
    import Tp5<A, B, C, D, E, fourth/0>
  }

  /**
   * Get the set of fifth values in the set of tuples that satisfy the given predicate.
   */
  E fifth() { base(_, _, _, _, result) }

  /**
   * Get the set of fifth values in the set of tuples that satisfy the given predicate.
   */
  module Fifth {
    import Tp5<A, B, C, D, E, fifth/0>
  }

  /**
   * Map a function over the tuples in this tuple set, and get a new tuple predicate back
   * representing the set of tuples after being transformed by that function.
   *
   * Sibling module of `Relate` (which takes a "relation" instead of a "function").
   *
   * Note that this implicitly performs a "flatMap," as the mapping function may return zero or
   * more than one result per tuple.
   *
   * Example:
   * ```ql
   * predicate livesIn(Person p, City c) { c = p.getCity() }
   * string describe(Person p, City c) { result = p.getName() + " lives in " + c.getName() }
   *
   * // selects "Peter lives in New York", "Wanda lives in London", ...
   * select Tp2<Person, City, livesIn/2>::Map<string, describe/2>::find()
   * ```
   */
  module Map<InfiniteStringableType R, FnType5<R, A, B, C, D, E>::fn/5 map> {
    /**
     * Get the result of mapping the function `map` over the set of tuples represented by this
     * tuple predicate.
     *
     * For mapping a "relation" (as opposed to a "function") over this tuple set, see `MapRelate`.
     */
    R find() {
      exists(A a, B b, C c, D d, E e |
        base(a, b, c, d, e) and
        result = map(a, b, c, d, e)
      )
    }
    // TODO: import ResultSet<R, find/0>
  }

  /**
   * Maps a relation over the tuples in this tuple set, and get a new tuple predicate back
   * representing the related values to the tuples in this set.
   *
   * Sibling module of `Map` (which takes a "function" instead of a "relation").
   *
   * Note that this implicitly performs an intersection with the domain tuple set of the given
   * relation.
   *
   * Example:
   * ```ql
   * predicate livesIn(Person p, City c) { c = p.getCity() }
   * Address hasMailingAddress(Person p, City c) { ... }
   *
   * // Selects the mailing addresses that correspond to the people, city in `livesIn`.
   * select Tp2<Person, City, livesIn/2>::Relate<Address, hasMailingAddress/2>::find()
   * ```
   *
   * To preserve `Person`, `City`, see `ExtendRelate`.
   */
  module Relate<InfiniteStringableType R, RelType5<R, A, B, C, D, E>::rel/5 r> {
    /**
     * Get the result of mapping the relation `r` over the set of tuples represented by this tuple
     * predicate.
     *
     * For mapping a "function" (as opposed to a "relation") over this tuple set, see `MapRelate`.
     */
    R find() {
      exists(A a, B b, C c, D d, E e |
        base(a, b, c, d, e) and
        result = r(a, b, c, d, e)
      )
    }
    // TODO: import ResultSet<R, find/0>
  }

  /**
   * An alias for `Map`, but the result is a "tuple set" (a predicate(A a) with one parameter and no
   * result) instead of a `ResultSet` (a predicate `R pred()` with no parameters and result `R`).
   *
   * Sibling module of `ProjectRelate1` (which takes a "relation" instead of a "function").
   *
   * See `Map` for more details.
   */
  module Project1<InfiniteStringableType R, FnType5<R, A, B, C, D, E>::fn/5 map> {
    /**
     * A predicate tuple that represents the result of a projection, from the input tuple
     * predicate, to a new tuple predicate with a single column derived from applying a tuple to the
     * given function `map`.
     *
     * For projecting this tuple by a "relation" (as opposed to a "function"), see `ProjectRelate`.
     */
    predicate tp(R related) {
      exists(A a, B b, C c, D d, E e |
        base(a, b, c, d, e) and
        related = map(a, b, c, d, e)
      )
    }
    // TODO: import Tp1<R, tp/1> ?
  }

  /**
   * An alias for `Relate`, but the result is a "tuple set" (a predicate(A a) with one parameter and no
   * result) instead of a `ResultSet` (a predicate `R pred()` with no parameters and result `R`).
   *
   * Sibling module of `Project1` (which takes a "function" instead of a "relation").
   *
   * See `Relate` for more details.
   */
  module ProjectRelate1<InfiniteStringableType R, RelType5<R, A, B, C, D, E>::rel/5 r> {
    /**
     * A predicate tuple that represents the result of a projection, from the input tuple
     * predicate, to a new tuple predicate with a single column derived from the given relation
     * `r`.
     *
     * For projecting this tuple by a "function" (as opposed to a "relation"), see `Project`.
     */
    predicate tp(R related) {
      exists(A a, B b, C c, D d, E e |
        base(a, b, c, d, e) and
        related = r(a, b, c, d, e)
      )
    }
    // TODO: import Tp1<R, tp/1> ?
  }

  /**
   * Project this tuple set to a new tuple set of 2 values per row, by using a set of
   * projection functions.
   *
   * Sibling module of `ProjectRelate2` (which takes a set of "relations" instead of "functions").
   *
   * Each project function accepts the values of a tuple from this tuple set, and returns a new
   * value, where the value returned by the nth function will become the nth column in the new tuple
   * set.
   *
   * For example, the following projection switches (first, last) names to (last, first) names.
   * ```ql
   * predicate firstLast(string first, string last) { exists(Person p | ... ) }
   *
   * import Tp2<string, string, firstLast/2>
   *   ::Project2<string, string,
   *       Tuples2<string, string>::getFirst/2,
   *       Tuples2<string, string>::getSecond/2>
   *   as LastFirst
   *
   * // Selects ("Curie", "Maria"), ("Einstein", "Albert"), etc.
   * from string a, string b where LastFirst::tp(a, b) select a, b
   * ```
   */
  module Project2<
    InfiniteStringableType A0, InfiniteStringableType B0, FnType5<A0, A, B, C, D, E>::fn/5 pja0,
    FnType5<B0, A, B, C, D, E>::fn/5 pjb0>
  {
    predicate tp(A0 a0, B0 b0) {
      exists(A a, B b, C c, D d, E e |
        base(a, b, c, d, e) and
        a0 = pja0(a, b, c, d, e) and
        b0 = pjb0(a, b, c, d, e)
      )
    }
  }

  /**
   * Project this tuple set to a new tuple set of 2 values per row, by using a set of
   * relations.
   *
   * Sibling module of `Project2` (which takes a set of "functions" instead of "relations").
   *
   * Each projection relation accepts the values of a tuple from this tuple set, and returns a new
   * value, where the value held by the nth relation will become the nth column in the new tuple
   * set.
   *
   * For example, the following projection switches (first, last) names to (last, first) names.
   * ```ql
   * predicate siblings(Person a, Person b) { ... }
   * Person motherOf(Person a, Person b) { ... }
   * Person fatherOf(Person a, Person b) { ... }
   *
   * import Tp2<Person, Person, siblings/2>
   *     ::Project2<Person, Person, motherOf/2, fatherOf/2>
   *   as SiblingParents
   *
   * // Selects (mother, father) that have a pair of children
   * from Person mother, Person father where SiblingParents::tp(mother, father)
   * select mother, father
   * ```
   */
  module ProjectRelate2<
    InfiniteStringableType A0, InfiniteStringableType B0, RelType5<A0, A, B, C, D, E>::rel/5 pja0,
    RelType5<B0, A, B, C, D, E>::rel/5 pjb0>
  {
    predicate tp(A0 a0, B0 b0) {
      exists(A a, B b, C c, D d, E e |
        base(a, b, c, d, e) and
        a0 = pja0(a, b, c, d, e) and
        b0 = pjb0(a, b, c, d, e)
      )
    }
  }

  /**
   * Project this tuple set to a new tuple set of 3 values per row, by using a set of
   * projection functions.
   *
   * Sibling module of `ProjectRelate3` (which takes a set of "relations" instead of "functions").
   *
   * Each project function accepts the values of a tuple from this tuple set, and returns a new
   * value, where the value returned by the nth function will become the nth column in the new tuple
   * set.
   *
   * For example, the following projection switches (first, last) names to (last, first) names.
   * ```ql
   * predicate firstLast(string first, string last) { exists(Person p | ... ) }
   *
   * import Tp2<string, string, firstLast/2>
   *   ::Project2<string, string,
   *       Tuples2<string, string>::getFirst/2,
   *       Tuples2<string, string>::getSecond/2>
   *   as LastFirst
   *
   * // Selects ("Curie", "Maria"), ("Einstein", "Albert"), etc.
   * from string a, string b where LastFirst::tp(a, b) select a, b
   * ```
   */
  module Project3<
    InfiniteStringableType A0, InfiniteStringableType B0, InfiniteStringableType C0,
    FnType5<A0, A, B, C, D, E>::fn/5 pja0, FnType5<B0, A, B, C, D, E>::fn/5 pjb0,
    FnType5<C0, A, B, C, D, E>::fn/5 pjc0>
  {
    predicate tp(A0 a0, B0 b0, C0 c0) {
      exists(A a, B b, C c, D d, E e |
        base(a, b, c, d, e) and
        a0 = pja0(a, b, c, d, e) and
        b0 = pjb0(a, b, c, d, e) and
        c0 = pjc0(a, b, c, d, e)
      )
    }
  }

  /**
   * Project this tuple set to a new tuple set of 3 values per row, by using a set of
   * relations.
   *
   * Sibling module of `Project3` (which takes a set of "functions" instead of "relations").
   *
   * Each projection relation accepts the values of a tuple from this tuple set, and returns a new
   * value, where the value held by the nth relation will become the nth column in the new tuple
   * set.
   *
   * For example, the following projection switches (first, last) names to (last, first) names.
   * ```ql
   * predicate siblings(Person a, Person b) { ... }
   * Person motherOf(Person a, Person b) { ... }
   * Person fatherOf(Person a, Person b) { ... }
   *
   * import Tp2<Person, Person, siblings/2>
   *     ::Project2<Person, Person, motherOf/2, fatherOf/2>
   *   as SiblingParents
   *
   * // Selects (mother, father) that have a pair of children
   * from Person mother, Person father where SiblingParents::tp(mother, father)
   * select mother, father
   * ```
   */
  module ProjectRelate3<
    InfiniteStringableType A0, InfiniteStringableType B0, InfiniteStringableType C0,
    RelType5<A0, A, B, C, D, E>::rel/5 pja0, RelType5<B0, A, B, C, D, E>::rel/5 pjb0,
    RelType5<C0, A, B, C, D, E>::rel/5 pjc0>
  {
    predicate tp(A0 a0, B0 b0, C0 c0) {
      exists(A a, B b, C c, D d, E e |
        base(a, b, c, d, e) and
        a0 = pja0(a, b, c, d, e) and
        b0 = pjb0(a, b, c, d, e) and
        c0 = pjc0(a, b, c, d, e)
      )
    }
  }

  /**
   * Project this tuple set to a new tuple set of 4 values per row, by using a set of
   * projection functions.
   *
   * Sibling module of `ProjectRelate4` (which takes a set of "relations" instead of "functions").
   *
   * Each project function accepts the values of a tuple from this tuple set, and returns a new
   * value, where the value returned by the nth function will become the nth column in the new tuple
   * set.
   *
   * For example, the following projection switches (first, last) names to (last, first) names.
   * ```ql
   * predicate firstLast(string first, string last) { exists(Person p | ... ) }
   *
   * import Tp2<string, string, firstLast/2>
   *   ::Project2<string, string,
   *       Tuples2<string, string>::getFirst/2,
   *       Tuples2<string, string>::getSecond/2>
   *   as LastFirst
   *
   * // Selects ("Curie", "Maria"), ("Einstein", "Albert"), etc.
   * from string a, string b where LastFirst::tp(a, b) select a, b
   * ```
   */
  module Project4<
    InfiniteStringableType A0, InfiniteStringableType B0, InfiniteStringableType C0,
    InfiniteStringableType D0, FnType5<A0, A, B, C, D, E>::fn/5 pja0,
    FnType5<B0, A, B, C, D, E>::fn/5 pjb0, FnType5<C0, A, B, C, D, E>::fn/5 pjc0,
    FnType5<D0, A, B, C, D, E>::fn/5 pjd0>
  {
    predicate tp(A0 a0, B0 b0, C0 c0, D0 d0) {
      exists(A a, B b, C c, D d, E e |
        base(a, b, c, d, e) and
        a0 = pja0(a, b, c, d, e) and
        b0 = pjb0(a, b, c, d, e) and
        c0 = pjc0(a, b, c, d, e) and
        d0 = pjd0(a, b, c, d, e)
      )
    }
  }

  /**
   * Project this tuple set to a new tuple set of 4 values per row, by using a set of
   * relations.
   *
   * Sibling module of `Project4` (which takes a set of "functions" instead of "relations").
   *
   * Each projection relation accepts the values of a tuple from this tuple set, and returns a new
   * value, where the value held by the nth relation will become the nth column in the new tuple
   * set.
   *
   * For example, the following projection switches (first, last) names to (last, first) names.
   * ```ql
   * predicate siblings(Person a, Person b) { ... }
   * Person motherOf(Person a, Person b) { ... }
   * Person fatherOf(Person a, Person b) { ... }
   *
   * import Tp2<Person, Person, siblings/2>
   *     ::Project2<Person, Person, motherOf/2, fatherOf/2>
   *   as SiblingParents
   *
   * // Selects (mother, father) that have a pair of children
   * from Person mother, Person father where SiblingParents::tp(mother, father)
   * select mother, father
   * ```
   */
  module ProjectRelate4<
    InfiniteStringableType A0, InfiniteStringableType B0, InfiniteStringableType C0,
    InfiniteStringableType D0, RelType5<A0, A, B, C, D, E>::rel/5 pja0,
    RelType5<B0, A, B, C, D, E>::rel/5 pjb0, RelType5<C0, A, B, C, D, E>::rel/5 pjc0,
    RelType5<D0, A, B, C, D, E>::rel/5 pjd0>
  {
    predicate tp(A0 a0, B0 b0, C0 c0, D0 d0) {
      exists(A a, B b, C c, D d, E e |
        base(a, b, c, d, e) and
        a0 = pja0(a, b, c, d, e) and
        b0 = pjb0(a, b, c, d, e) and
        c0 = pjc0(a, b, c, d, e) and
        d0 = pjd0(a, b, c, d, e)
      )
    }
  }

  /**
   * Project this tuple set to a new tuple set of 5 values per row, by using a set of
   * projection functions.
   *
   * Sibling module of `ProjectRelate5` (which takes a set of "relations" instead of "functions").
   *
   * Each project function accepts the values of a tuple from this tuple set, and returns a new
   * value, where the value returned by the nth function will become the nth column in the new tuple
   * set.
   *
   * For example, the following projection switches (first, last) names to (last, first) names.
   * ```ql
   * predicate firstLast(string first, string last) { exists(Person p | ... ) }
   *
   * import Tp2<string, string, firstLast/2>
   *   ::Project2<string, string,
   *       Tuples2<string, string>::getFirst/2,
   *       Tuples2<string, string>::getSecond/2>
   *   as LastFirst
   *
   * // Selects ("Curie", "Maria"), ("Einstein", "Albert"), etc.
   * from string a, string b where LastFirst::tp(a, b) select a, b
   * ```
   */
  module Project5<
    InfiniteStringableType A0, InfiniteStringableType B0, InfiniteStringableType C0,
    InfiniteStringableType D0, InfiniteStringableType E0, FnType5<A0, A, B, C, D, E>::fn/5 pja0,
    FnType5<B0, A, B, C, D, E>::fn/5 pjb0, FnType5<C0, A, B, C, D, E>::fn/5 pjc0,
    FnType5<D0, A, B, C, D, E>::fn/5 pjd0, FnType5<E0, A, B, C, D, E>::fn/5 pje0>
  {
    predicate tp(A0 a0, B0 b0, C0 c0, D0 d0, E0 e0) {
      exists(A a, B b, C c, D d, E e |
        base(a, b, c, d, e) and
        a0 = pja0(a, b, c, d, e) and
        b0 = pjb0(a, b, c, d, e) and
        c0 = pjc0(a, b, c, d, e) and
        d0 = pjd0(a, b, c, d, e) and
        e0 = pje0(a, b, c, d, e)
      )
    }
  }

  /**
   * Project this tuple set to a new tuple set of 5 values per row, by using a set of
   * relations.
   *
   * Sibling module of `Project5` (which takes a set of "functions" instead of "relations").
   *
   * Each projection relation accepts the values of a tuple from this tuple set, and returns a new
   * value, where the value held by the nth relation will become the nth column in the new tuple
   * set.
   *
   * For example, the following projection switches (first, last) names to (last, first) names.
   * ```ql
   * predicate siblings(Person a, Person b) { ... }
   * Person motherOf(Person a, Person b) { ... }
   * Person fatherOf(Person a, Person b) { ... }
   *
   * import Tp2<Person, Person, siblings/2>
   *     ::Project2<Person, Person, motherOf/2, fatherOf/2>
   *   as SiblingParents
   *
   * // Selects (mother, father) that have a pair of children
   * from Person mother, Person father where SiblingParents::tp(mother, father)
   * select mother, father
   * ```
   */
  module ProjectRelate5<
    InfiniteStringableType A0, InfiniteStringableType B0, InfiniteStringableType C0,
    InfiniteStringableType D0, InfiniteStringableType E0, RelType5<A0, A, B, C, D, E>::rel/5 pja0,
    RelType5<B0, A, B, C, D, E>::rel/5 pjb0, RelType5<C0, A, B, C, D, E>::rel/5 pjc0,
    RelType5<D0, A, B, C, D, E>::rel/5 pjd0, RelType5<E0, A, B, C, D, E>::rel/5 pje0>
  {
    predicate tp(A0 a0, B0 b0, C0 c0, D0 d0, E0 e0) {
      exists(A a, B b, C c, D d, E e |
        base(a, b, c, d, e) and
        a0 = pja0(a, b, c, d, e) and
        b0 = pjb0(a, b, c, d, e) and
        c0 = pjc0(a, b, c, d, e) and
        d0 = pjd0(a, b, c, d, e) and
        e0 = pje0(a, b, c, d, e)
      )
    }
  }

  /**
   * Project this tuple set to a new tuple set of 6 values per row, by using a set of
   * projection functions.
   *
   * Sibling module of `ProjectRelate6` (which takes a set of "relations" instead of "functions").
   *
   * Each project function accepts the values of a tuple from this tuple set, and returns a new
   * value, where the value returned by the nth function will become the nth column in the new tuple
   * set.
   *
   * For example, the following projection switches (first, last) names to (last, first) names.
   * ```ql
   * predicate firstLast(string first, string last) { exists(Person p | ... ) }
   *
   * import Tp2<string, string, firstLast/2>
   *   ::Project2<string, string,
   *       Tuples2<string, string>::getFirst/2,
   *       Tuples2<string, string>::getSecond/2>
   *   as LastFirst
   *
   * // Selects ("Curie", "Maria"), ("Einstein", "Albert"), etc.
   * from string a, string b where LastFirst::tp(a, b) select a, b
   * ```
   */
  module Project6<
    InfiniteStringableType A0, InfiniteStringableType B0, InfiniteStringableType C0,
    InfiniteStringableType D0, InfiniteStringableType E0, InfiniteStringableType F0,
    FnType5<A0, A, B, C, D, E>::fn/5 pja0, FnType5<B0, A, B, C, D, E>::fn/5 pjb0,
    FnType5<C0, A, B, C, D, E>::fn/5 pjc0, FnType5<D0, A, B, C, D, E>::fn/5 pjd0,
    FnType5<E0, A, B, C, D, E>::fn/5 pje0, FnType5<F0, A, B, C, D, E>::fn/5 pjf0>
  {
    predicate tp(A0 a0, B0 b0, C0 c0, D0 d0, E0 e0, F0 f0) {
      exists(A a, B b, C c, D d, E e |
        base(a, b, c, d, e) and
        a0 = pja0(a, b, c, d, e) and
        b0 = pjb0(a, b, c, d, e) and
        c0 = pjc0(a, b, c, d, e) and
        d0 = pjd0(a, b, c, d, e) and
        e0 = pje0(a, b, c, d, e) and
        f0 = pjf0(a, b, c, d, e)
      )
    }
  }

  /**
   * Project this tuple set to a new tuple set of 6 values per row, by using a set of
   * relations.
   *
   * Sibling module of `Project6` (which takes a set of "functions" instead of "relations").
   *
   * Each projection relation accepts the values of a tuple from this tuple set, and returns a new
   * value, where the value held by the nth relation will become the nth column in the new tuple
   * set.
   *
   * For example, the following projection switches (first, last) names to (last, first) names.
   * ```ql
   * predicate siblings(Person a, Person b) { ... }
   * Person motherOf(Person a, Person b) { ... }
   * Person fatherOf(Person a, Person b) { ... }
   *
   * import Tp2<Person, Person, siblings/2>
   *     ::Project2<Person, Person, motherOf/2, fatherOf/2>
   *   as SiblingParents
   *
   * // Selects (mother, father) that have a pair of children
   * from Person mother, Person father where SiblingParents::tp(mother, father)
   * select mother, father
   * ```
   */
  module ProjectRelate6<
    InfiniteStringableType A0, InfiniteStringableType B0, InfiniteStringableType C0,
    InfiniteStringableType D0, InfiniteStringableType E0, InfiniteStringableType F0,
    RelType5<A0, A, B, C, D, E>::rel/5 pja0, RelType5<B0, A, B, C, D, E>::rel/5 pjb0,
    RelType5<C0, A, B, C, D, E>::rel/5 pjc0, RelType5<D0, A, B, C, D, E>::rel/5 pjd0,
    RelType5<E0, A, B, C, D, E>::rel/5 pje0, RelType5<F0, A, B, C, D, E>::rel/5 pjf0>
  {
    predicate tp(A0 a0, B0 b0, C0 c0, D0 d0, E0 e0, F0 f0) {
      exists(A a, B b, C c, D d, E e |
        base(a, b, c, d, e) and
        a0 = pja0(a, b, c, d, e) and
        b0 = pjb0(a, b, c, d, e) and
        c0 = pjc0(a, b, c, d, e) and
        d0 = pjd0(a, b, c, d, e) and
        e0 = pje0(a, b, c, d, e) and
        f0 = pjf0(a, b, c, d, e)
      )
    }
  }

  /**
   * Maps the set of first values in the set of tuples that satisfy the given predicate,
   * against a mapper function.
   *
   * Sibling function of `MapRelateFirst`, which operates on "relations" instead of
   * "functions."
   *
   * Example:
   * ```ql
   * predicate employs(Company company, Person person) { ... }
   *
   * // Selects the ages of employed People.
   * select Tp2<Company, Person, employs/2>
   *   ::MapSecond<int, getAge/1>
   *   ::find()
   * ```
   */
  module MapFirst<InfiniteStringableType R, FnType1<R, A>::fn/1 map> {
    R find() {
      exists(A a |
        base(a, _, _, _, _) and
        result = map(a)
      )
    }
  }

  /**
   * Maps the set of first values in the set of tuples that satisfy the given predicate,
   * against a mapper relation.
   *
   * Sibling function of `MapFirst`, which operates on "functions" instead of
   * "relations."
   *
   * Example:
   * ```ql
   * predicate employs(Company company, Person person) { ... }
   * Pet getPets(Person p) { ... }
   *
   * // Selects the pets of employed People.
   * select Tp2<Company, Person, employs/2>
   *   ::MapRelateSecond<Pet, getPets/1>
   *   ::find()
   * ```
   */
  module MapRelateFirst<InfiniteStringableType R, RelType1<R, A>::rel/1 map> {
    R find() {
      exists(A a |
        base(a, _, _, _, _) and
        result = map(a)
      )
    }
  }

  /**
   * Maps the set of second values in the set of tuples that satisfy the given predicate,
   * against a mapper function.
   *
   * Sibling function of `MapRelateSecond`, which operates on "relations" instead of
   * "functions."
   *
   * Example:
   * ```ql
   * predicate employs(Company company, Person person) { ... }
   *
   * // Selects the ages of employed People.
   * select Tp2<Company, Person, employs/2>
   *   ::MapSecond<int, getAge/1>
   *   ::find()
   * ```
   */
  module MapSecond<InfiniteStringableType R, FnType1<R, B>::fn/1 map> {
    R find() {
      exists(B b |
        base(_, b, _, _, _) and
        result = map(b)
      )
    }
  }

  /**
   * Maps the set of second values in the set of tuples that satisfy the given predicate,
   * against a mapper relation.
   *
   * Sibling function of `MapSecond`, which operates on "functions" instead of
   * "relations."
   *
   * Example:
   * ```ql
   * predicate employs(Company company, Person person) { ... }
   * Pet getPets(Person p) { ... }
   *
   * // Selects the pets of employed People.
   * select Tp2<Company, Person, employs/2>
   *   ::MapRelateSecond<Pet, getPets/1>
   *   ::find()
   * ```
   */
  module MapRelateSecond<InfiniteStringableType R, RelType1<R, B>::rel/1 map> {
    R find() {
      exists(B b |
        base(_, b, _, _, _) and
        result = map(b)
      )
    }
  }

  /**
   * Maps the set of third values in the set of tuples that satisfy the given predicate,
   * against a mapper function.
   *
   * Sibling function of `MapRelateThird`, which operates on "relations" instead of
   * "functions."
   *
   * Example:
   * ```ql
   * predicate employs(Company company, Person person) { ... }
   *
   * // Selects the ages of employed People.
   * select Tp2<Company, Person, employs/2>
   *   ::MapSecond<int, getAge/1>
   *   ::find()
   * ```
   */
  module MapThird<InfiniteStringableType R, FnType1<R, C>::fn/1 map> {
    R find() {
      exists(C c |
        base(_, _, c, _, _) and
        result = map(c)
      )
    }
  }

  /**
   * Maps the set of third values in the set of tuples that satisfy the given predicate,
   * against a mapper relation.
   *
   * Sibling function of `MapThird`, which operates on "functions" instead of
   * "relations."
   *
   * Example:
   * ```ql
   * predicate employs(Company company, Person person) { ... }
   * Pet getPets(Person p) { ... }
   *
   * // Selects the pets of employed People.
   * select Tp2<Company, Person, employs/2>
   *   ::MapRelateSecond<Pet, getPets/1>
   *   ::find()
   * ```
   */
  module MapRelateThird<InfiniteStringableType R, RelType1<R, C>::rel/1 map> {
    R find() {
      exists(C c |
        base(_, _, c, _, _) and
        result = map(c)
      )
    }
  }

  /**
   * Maps the set of fourth values in the set of tuples that satisfy the given predicate,
   * against a mapper function.
   *
   * Sibling function of `MapRelateFourth`, which operates on "relations" instead of
   * "functions."
   *
   * Example:
   * ```ql
   * predicate employs(Company company, Person person) { ... }
   *
   * // Selects the ages of employed People.
   * select Tp2<Company, Person, employs/2>
   *   ::MapSecond<int, getAge/1>
   *   ::find()
   * ```
   */
  module MapFourth<InfiniteStringableType R, FnType1<R, D>::fn/1 map> {
    R find() {
      exists(D d |
        base(_, _, _, d, _) and
        result = map(d)
      )
    }
  }

  /**
   * Maps the set of fourth values in the set of tuples that satisfy the given predicate,
   * against a mapper relation.
   *
   * Sibling function of `MapFourth`, which operates on "functions" instead of
   * "relations."
   *
   * Example:
   * ```ql
   * predicate employs(Company company, Person person) { ... }
   * Pet getPets(Person p) { ... }
   *
   * // Selects the pets of employed People.
   * select Tp2<Company, Person, employs/2>
   *   ::MapRelateSecond<Pet, getPets/1>
   *   ::find()
   * ```
   */
  module MapRelateFourth<InfiniteStringableType R, RelType1<R, D>::rel/1 map> {
    R find() {
      exists(D d |
        base(_, _, _, d, _) and
        result = map(d)
      )
    }
  }

  /**
   * Maps the set of fifth values in the set of tuples that satisfy the given predicate,
   * against a mapper function.
   *
   * Sibling function of `MapRelateFifth`, which operates on "relations" instead of
   * "functions."
   *
   * Example:
   * ```ql
   * predicate employs(Company company, Person person) { ... }
   *
   * // Selects the ages of employed People.
   * select Tp2<Company, Person, employs/2>
   *   ::MapSecond<int, getAge/1>
   *   ::find()
   * ```
   */
  module MapFifth<InfiniteStringableType R, FnType1<R, E>::fn/1 map> {
    R find() {
      exists(E e |
        base(_, _, _, _, e) and
        result = map(e)
      )
    }
  }

  /**
   * Maps the set of fifth values in the set of tuples that satisfy the given predicate,
   * against a mapper relation.
   *
   * Sibling function of `MapFifth`, which operates on "functions" instead of
   * "relations."
   *
   * Example:
   * ```ql
   * predicate employs(Company company, Person person) { ... }
   * Pet getPets(Person p) { ... }
   *
   * // Selects the pets of employed People.
   * select Tp2<Company, Person, employs/2>
   *   ::MapRelateSecond<Pet, getPets/1>
   *   ::find()
   * ```
   */
  module MapRelateFifth<InfiniteStringableType R, RelType1<R, E>::rel/1 map> {
    R find() {
      exists(E e |
        base(_, _, _, _, e) and
        result = map(e)
      )
    }
  }

  /**
   * Maps the set of first values in the set of tuples that satisfy the given predicate,
   * against a mapper function, and use the result to add a column to this tuple set.
   *
   * Sibling function of `ExtendRelateFirst`, which operates on "relations" instead of
   * "functions."
   *
   * Example:
   * ```ql
   * predicate hasName(Person person, string name) { ... }
   * string getInitials(string name) { ... }
   *
   * // Selects (person, name, initials)
   * import Tp2<Person, string, hasName/2>
   *   ::ExtendMapSecond<string, getInitials/1>
   *   ::Query
   * ```
   */
  module ExtendMapFirst<InfiniteStringableType R, FnType1<R, A>::fn/1 map> {
    predicate tp(A a, B b, C c, D d, E e, R r) {
      base(a, b, c, d, e) and
      r = map(a)
    }
  }

  /**
   * Maps the set of first values in the set of tuples that satisfy the given predicate,
   * against a mapper function, and use the result to add a column to this tuple set.
   *
   * Sibling function of `ExtendRelateFirst`, which operates on "relations" instead of
   * "functions."
   *
   * Example:
   * ```ql
   * predicate employs(Company company, Person person) { ... }
   * Address hasAddress(Person p) { ... }
   *
   * // Selects (company, person, age) for all employed people.
   * import Tp2<Company, Person, employs/2>
   *   ::ExtendRelateSecond<getAge/1>
   *   ::Query
   * ```
   */
  module ExtendRelateFirst<InfiniteStringableType R, RelType1<R, A>::rel/1 map> {
    predicate tp(A a, B b, C c, D d, E e, R r) {
      base(a, b, c, d, e) and
      r = map(a)
    }
  }

  /**
   * Maps the set of second values in the set of tuples that satisfy the given predicate,
   * against a mapper function, and use the result to add a column to this tuple set.
   *
   * Sibling function of `ExtendRelateSecond`, which operates on "relations" instead of
   * "functions."
   *
   * Example:
   * ```ql
   * predicate hasName(Person person, string name) { ... }
   * string getInitials(string name) { ... }
   *
   * // Selects (person, name, initials)
   * import Tp2<Person, string, hasName/2>
   *   ::ExtendMapSecond<string, getInitials/1>
   *   ::Query
   * ```
   */
  module ExtendMapSecond<InfiniteStringableType R, FnType1<R, B>::fn/1 map> {
    predicate tp(A a, B b, C c, D d, E e, R r) {
      base(a, b, c, d, e) and
      r = map(b)
    }
  }

  /**
   * Maps the set of second values in the set of tuples that satisfy the given predicate,
   * against a mapper function, and use the result to add a column to this tuple set.
   *
   * Sibling function of `ExtendRelateSecond`, which operates on "relations" instead of
   * "functions."
   *
   * Example:
   * ```ql
   * predicate employs(Company company, Person person) { ... }
   * Address hasAddress(Person p) { ... }
   *
   * // Selects (company, person, age) for all employed people.
   * import Tp2<Company, Person, employs/2>
   *   ::ExtendRelateSecond<getAge/1>
   *   ::Query
   * ```
   */
  module ExtendRelateSecond<InfiniteStringableType R, RelType1<R, B>::rel/1 map> {
    predicate tp(A a, B b, C c, D d, E e, R r) {
      base(a, b, c, d, e) and
      r = map(b)
    }
  }

  /**
   * Maps the set of third values in the set of tuples that satisfy the given predicate,
   * against a mapper function, and use the result to add a column to this tuple set.
   *
   * Sibling function of `ExtendRelateThird`, which operates on "relations" instead of
   * "functions."
   *
   * Example:
   * ```ql
   * predicate hasName(Person person, string name) { ... }
   * string getInitials(string name) { ... }
   *
   * // Selects (person, name, initials)
   * import Tp2<Person, string, hasName/2>
   *   ::ExtendMapSecond<string, getInitials/1>
   *   ::Query
   * ```
   */
  module ExtendMapThird<InfiniteStringableType R, FnType1<R, C>::fn/1 map> {
    predicate tp(A a, B b, C c, D d, E e, R r) {
      base(a, b, c, d, e) and
      r = map(c)
    }
  }

  /**
   * Maps the set of third values in the set of tuples that satisfy the given predicate,
   * against a mapper function, and use the result to add a column to this tuple set.
   *
   * Sibling function of `ExtendRelateThird`, which operates on "relations" instead of
   * "functions."
   *
   * Example:
   * ```ql
   * predicate employs(Company company, Person person) { ... }
   * Address hasAddress(Person p) { ... }
   *
   * // Selects (company, person, age) for all employed people.
   * import Tp2<Company, Person, employs/2>
   *   ::ExtendRelateSecond<getAge/1>
   *   ::Query
   * ```
   */
  module ExtendRelateThird<InfiniteStringableType R, RelType1<R, C>::rel/1 map> {
    predicate tp(A a, B b, C c, D d, E e, R r) {
      base(a, b, c, d, e) and
      r = map(c)
    }
  }

  /**
   * Maps the set of fourth values in the set of tuples that satisfy the given predicate,
   * against a mapper function, and use the result to add a column to this tuple set.
   *
   * Sibling function of `ExtendRelateFourth`, which operates on "relations" instead of
   * "functions."
   *
   * Example:
   * ```ql
   * predicate hasName(Person person, string name) { ... }
   * string getInitials(string name) { ... }
   *
   * // Selects (person, name, initials)
   * import Tp2<Person, string, hasName/2>
   *   ::ExtendMapSecond<string, getInitials/1>
   *   ::Query
   * ```
   */
  module ExtendMapFourth<InfiniteStringableType R, FnType1<R, D>::fn/1 map> {
    predicate tp(A a, B b, C c, D d, E e, R r) {
      base(a, b, c, d, e) and
      r = map(d)
    }
  }

  /**
   * Maps the set of fourth values in the set of tuples that satisfy the given predicate,
   * against a mapper function, and use the result to add a column to this tuple set.
   *
   * Sibling function of `ExtendRelateFourth`, which operates on "relations" instead of
   * "functions."
   *
   * Example:
   * ```ql
   * predicate employs(Company company, Person person) { ... }
   * Address hasAddress(Person p) { ... }
   *
   * // Selects (company, person, age) for all employed people.
   * import Tp2<Company, Person, employs/2>
   *   ::ExtendRelateSecond<getAge/1>
   *   ::Query
   * ```
   */
  module ExtendRelateFourth<InfiniteStringableType R, RelType1<R, D>::rel/1 map> {
    predicate tp(A a, B b, C c, D d, E e, R r) {
      base(a, b, c, d, e) and
      r = map(d)
    }
  }

  /**
   * Maps the set of fifth values in the set of tuples that satisfy the given predicate,
   * against a mapper function, and use the result to add a column to this tuple set.
   *
   * Sibling function of `ExtendRelateFifth`, which operates on "relations" instead of
   * "functions."
   *
   * Example:
   * ```ql
   * predicate hasName(Person person, string name) { ... }
   * string getInitials(string name) { ... }
   *
   * // Selects (person, name, initials)
   * import Tp2<Person, string, hasName/2>
   *   ::ExtendMapSecond<string, getInitials/1>
   *   ::Query
   * ```
   */
  module ExtendMapFifth<InfiniteStringableType R, FnType1<R, E>::fn/1 map> {
    predicate tp(A a, B b, C c, D d, E e, R r) {
      base(a, b, c, d, e) and
      r = map(e)
    }
  }

  /**
   * Maps the set of fifth values in the set of tuples that satisfy the given predicate,
   * against a mapper function, and use the result to add a column to this tuple set.
   *
   * Sibling function of `ExtendRelateFifth`, which operates on "relations" instead of
   * "functions."
   *
   * Example:
   * ```ql
   * predicate employs(Company company, Person person) { ... }
   * Address hasAddress(Person p) { ... }
   *
   * // Selects (company, person, age) for all employed people.
   * import Tp2<Company, Person, employs/2>
   *   ::ExtendRelateSecond<getAge/1>
   *   ::Query
   * ```
   */
  module ExtendRelateFifth<InfiniteStringableType R, RelType1<R, E>::rel/1 map> {
    predicate tp(A a, B b, C c, D d, E e, R r) {
      base(a, b, c, d, e) and
      r = map(e)
    }
  }

  /**
   * Takes a property which filters the contents of the current tuple set and produces a new one.
   *
   * Sibling predicate of `intersect`, which takes a "tuple predicate" instead of a "property."
   */
  module Filter<PropType5<A, B, C, D, E>::prop/5 flt> {
    predicate tp(A a, B b, C c, D d, E e) {
      flt(a, b, c, d, e) and
      base(a, b, c, d, e)
    }
  }

  /**
   * Takes a tuple set and intersects it with the current tuple set to produce a new one.
   *
   * Sibling predicate of `filter`, which takes a "property" instead of a "tuple set."
   */
  module Intersect<TpType5<A, B, C, D, E>::tp/5 tp2> {
    predicate tp(A a, B b, C c, D d, E e) {
      tp2(a, b, c, d, e) and
      base(a, b, c, d, e)
    }
  }

  /**
   * Creates a new tuple predicate that is a union of the current tuple set and the given one.
   */
  module Union<TpType5<A, B, C, D, E>::tp/5 tp2> {
    predicate tp(A a, B b, C c, D d, E e) {
      tp2(a, b, c, d, e) or
      base(a, b, c, d, e)
    }
  }

  /**
   * Creates a new tuple predicate that holds the elements only in the current tuple set, not the
   * given one.
   */
  module Difference<TpType5<A, B, C, D, E>::tp/5 tp2> {
    predicate tp(A a, B b, C c, D d, E e) {
      base(a, b, c, d, e) and
      not tp2(a, b, c, d, e)
    }
  }

  /**
   * Checks if (a, b, c, ...) is a member of the tuple set represented by this "tuple predicate."
   */
  predicate contains(A a, B b, C c, D d, E e) { base(a, b, c, d, e) }

  /**
   * A module with a single predicate, `holds`, that holds if the current tuple set contains all
   * of the tuples of the given tuple predicate `tp2`.
   */
  module ContainsAll<TpType5<A, B, C, D, E>::tp/5 tp2> {
    predicate holds() { forall(A a, B b, C c, D d, E e | tp2(a, b, c, d, e) | base(a, b, c, d, e)) }
  }

  /**
   * A module with a single predicate, `holds`, that holds if the current tuple set contains any
   * of the tuples of the given tuple predicate `tp2`.
   *
   * Sibling predicate of `AnyHoldsFor`, which takes a "property" instead of a "tuple predicate."
   */
  module ContainsAny<TpType5<A, B, C, D, E>::tp/5 tp2> {
    predicate holds() {
      exists(A a, B b, C c, D d, E e |
        tp2(a, b, c, d, e) and
        base(a, b, c, d, e)
      )
    }
  }

  /**
   * A module with a single predicate, `holds`, that holds if any of the tuples in the current tuple
   * satisfy the given property `prop`.
   *
   * Sibling predicate of `ContainsAny`, which takes a "tuple predicate" instead of a "property."
   */
  module AnyHoldsFor<PropType5<A, B, C, D, E>::prop/5 prop> {
    predicate holds() {
      exists(A a, B b, C c, D d, E e |
        base(a, b, c, d, e) and
        prop(a, b, c, d, e)
      )
    }
  }

  /**
   * A module with a single predicate, `holds`, that holds if all of the tuples in the current tuple
   * set satisfy the given property `prop`.
   *
   * Sibling predicate of `ContainedBy` which takes a "tuple predicate" instead of a "property."
   */
  module AllHoldsFor<PropType5<A, B, C, D, E>::prop/5 prop> {
    predicate holds() {
      forall(A a, B b, C c, D d, E e | base(a, b, c, d, e) | prop(a, b, c, d, e))
    }
  }

  /**
   * A module with a single predicate, `holds`, that holds if all of the tuples in the current tuple
   * set satisfy the given property `prop`.
   *
   * Sibling predicate of `AllHoldsFor`, which takes a "property" instead of a "tuple predicate."
   */
  module ContainedBy<TpType5<A, B, C, D, E>::tp/5 tp2> {
    predicate holds() { forall(A a, B b, C c, D d, E e | base(a, b, c, d, e) | tp2(a, b, c, d, e)) }
  }

  /**
   * Drop the first column in the set of tuples that satisfy the given predicate, and get
   * a new tuple set after that column has been dropped.
   */
  predicate dropFirst(B b, C c, D d, E e) { base(_, b, c, d, e) }

  /**
   * Drop the second column in the set of tuples that satisfy the given predicate, and get
   * a new tuple set after that column has been dropped.
   */
  predicate dropSecond(A a, C c, D d, E e) { base(a, _, c, d, e) }

  /**
   * Drop the third column in the set of tuples that satisfy the given predicate, and get
   * a new tuple set after that column has been dropped.
   */
  predicate dropThird(A a, B b, D d, E e) { base(a, b, _, d, e) }

  /**
   * Drop the fourth column in the set of tuples that satisfy the given predicate, and get
   * a new tuple set after that column has been dropped.
   */
  predicate dropFourth(A a, B b, C c, E e) { base(a, b, c, _, e) }

  /**
   * Drop the fifth column in the set of tuples that satisfy the given predicate, and get
   * a new tuple set after that column has been dropped.
   */
  predicate dropFifth(A a, B b, C c, D d) { base(a, b, c, d, _) }

  /**
   * Count the number of tuples in this tuple set.
   */
  int doCount() { result = count(A a, B b, C c, D d, E e | base(a, b, c, d, e)) }

  /**
   * Query for the contents of this tuple, by defining a query predicate `tpQuery` to import.
   */
  module Query {
    query predicate tpQuery(A a, B b, C c, D d, E e) { base(a, b, c, d, e) }
  }
}

/**
 * A module for transforming a "Tuple predicate" with 6 arguments.
 *
 * In qtil speak:
 *  - a "Function" (FnX) is a predicate with a bindingset[] on all of its arguments, and a result
 *  - a "TuplePredicate " (TpX) is a predicate with finite arguments and no result
 *  - a "Relation" (RelX) is a predicate with finite arguments and a finite result
 *  - a "Property" (PropX) is a predicate with a bindingset[] on all arguments no result
 *
 * Essentially, a tuple predicate `Tp<A, B, C>` represents a finite set of tuples `(a, b, c)`. This
 * module accepts a tuple predicate (`predicate p(A, B, C)`) as an input, and offers functional
 * programming features on top of it such as `map` and `filter`, as well as some relational algebra
 * features such as projection and joins.
 *
 * Example:
 * ```ql
 * predicate livesIn(Person p, City c) { c = p.getCity() }
 * string describe(Person p, City c) { result = p.getName() + " lives in " + c.getName() }
 *
 * // selects "Peter lives in New York", "Wanda lives in London", ...
 * select Tp2<Person, City, livesIn/2>::Map<string, describe/2>::find()
 * ```
 */
module Tp6<
  InfiniteStringableType A, InfiniteStringableType B, InfiniteStringableType C,
  InfiniteStringableType D, InfiniteStringableType E, InfiniteStringableType F,
  TpType6<A, B, C, D, E, F>::tp/6 base>
{
  /**
   * Get the set of first values in the set of tuples that satisfy the given predicate.
   */
  A first() { base(result, _, _, _, _, _) }

  /**
   * Get the set of first values in the set of tuples that satisfy the given predicate.
   */
  module First {
    import Tp6<A, B, C, D, E, F, first/0>
  }

  /**
   * Get the set of second values in the set of tuples that satisfy the given predicate.
   */
  B second() { base(_, result, _, _, _, _) }

  /**
   * Get the set of second values in the set of tuples that satisfy the given predicate.
   */
  module Second {
    import Tp6<A, B, C, D, E, F, second/0>
  }

  /**
   * Get the set of third values in the set of tuples that satisfy the given predicate.
   */
  C third() { base(_, _, result, _, _, _) }

  /**
   * Get the set of third values in the set of tuples that satisfy the given predicate.
   */
  module Third {
    import Tp6<A, B, C, D, E, F, third/0>
  }

  /**
   * Get the set of fourth values in the set of tuples that satisfy the given predicate.
   */
  D fourth() { base(_, _, _, result, _, _) }

  /**
   * Get the set of fourth values in the set of tuples that satisfy the given predicate.
   */
  module Fourth {
    import Tp6<A, B, C, D, E, F, fourth/0>
  }

  /**
   * Get the set of fifth values in the set of tuples that satisfy the given predicate.
   */
  E fifth() { base(_, _, _, _, result, _) }

  /**
   * Get the set of fifth values in the set of tuples that satisfy the given predicate.
   */
  module Fifth {
    import Tp6<A, B, C, D, E, F, fifth/0>
  }

  /**
   * Get the set of sixth values in the set of tuples that satisfy the given predicate.
   */
  F sixth() { base(_, _, _, _, _, result) }

  /**
   * Get the set of sixth values in the set of tuples that satisfy the given predicate.
   */
  module Sixth {
    import Tp6<A, B, C, D, E, F, sixth/0>
  }

  /**
   * Map a function over the tuples in this tuple set, and get a new tuple predicate back
   * representing the set of tuples after being transformed by that function.
   *
   * Sibling module of `Relate` (which takes a "relation" instead of a "function").
   *
   * Note that this implicitly performs a "flatMap," as the mapping function may return zero or
   * more than one result per tuple.
   *
   * Example:
   * ```ql
   * predicate livesIn(Person p, City c) { c = p.getCity() }
   * string describe(Person p, City c) { result = p.getName() + " lives in " + c.getName() }
   *
   * // selects "Peter lives in New York", "Wanda lives in London", ...
   * select Tp2<Person, City, livesIn/2>::Map<string, describe/2>::find()
   * ```
   */
  module Map<InfiniteStringableType R, FnType6<R, A, B, C, D, E, F>::fn/6 map> {
    /**
     * Get the result of mapping the function `map` over the set of tuples represented by this
     * tuple predicate.
     *
     * For mapping a "relation" (as opposed to a "function") over this tuple set, see `MapRelate`.
     */
    R find() {
      exists(A a, B b, C c, D d, E e, F f |
        base(a, b, c, d, e, f) and
        result = map(a, b, c, d, e, f)
      )
    }
    // TODO: import ResultSet<R, find/0>
  }

  /**
   * Maps a relation over the tuples in this tuple set, and get a new tuple predicate back
   * representing the related values to the tuples in this set.
   *
   * Sibling module of `Map` (which takes a "function" instead of a "relation").
   *
   * Note that this implicitly performs an intersection with the domain tuple set of the given
   * relation.
   *
   * Example:
   * ```ql
   * predicate livesIn(Person p, City c) { c = p.getCity() }
   * Address hasMailingAddress(Person p, City c) { ... }
   *
   * // Selects the mailing addresses that correspond to the people, city in `livesIn`.
   * select Tp2<Person, City, livesIn/2>::Relate<Address, hasMailingAddress/2>::find()
   * ```
   *
   * To preserve `Person`, `City`, see `ExtendRelate`.
   */
  module Relate<InfiniteStringableType R, RelType6<R, A, B, C, D, E, F>::rel/6 r> {
    /**
     * Get the result of mapping the relation `r` over the set of tuples represented by this tuple
     * predicate.
     *
     * For mapping a "function" (as opposed to a "relation") over this tuple set, see `MapRelate`.
     */
    R find() {
      exists(A a, B b, C c, D d, E e, F f |
        base(a, b, c, d, e, f) and
        result = r(a, b, c, d, e, f)
      )
    }
    // TODO: import ResultSet<R, find/0>
  }

  /**
   * An alias for `Map`, but the result is a "tuple set" (a predicate(A a) with one parameter and no
   * result) instead of a `ResultSet` (a predicate `R pred()` with no parameters and result `R`).
   *
   * Sibling module of `ProjectRelate1` (which takes a "relation" instead of a "function").
   *
   * See `Map` for more details.
   */
  module Project1<InfiniteStringableType R, FnType6<R, A, B, C, D, E, F>::fn/6 map> {
    /**
     * A predicate tuple that represents the result of a projection, from the input tuple
     * predicate, to a new tuple predicate with a single column derived from applying a tuple to the
     * given function `map`.
     *
     * For projecting this tuple by a "relation" (as opposed to a "function"), see `ProjectRelate`.
     */
    predicate tp(R related) {
      exists(A a, B b, C c, D d, E e, F f |
        base(a, b, c, d, e, f) and
        related = map(a, b, c, d, e, f)
      )
    }
    // TODO: import Tp1<R, tp/1> ?
  }

  /**
   * An alias for `Relate`, but the result is a "tuple set" (a predicate(A a) with one parameter and no
   * result) instead of a `ResultSet` (a predicate `R pred()` with no parameters and result `R`).
   *
   * Sibling module of `Project1` (which takes a "function" instead of a "relation").
   *
   * See `Relate` for more details.
   */
  module ProjectRelate1<InfiniteStringableType R, RelType6<R, A, B, C, D, E, F>::rel/6 r> {
    /**
     * A predicate tuple that represents the result of a projection, from the input tuple
     * predicate, to a new tuple predicate with a single column derived from the given relation
     * `r`.
     *
     * For projecting this tuple by a "function" (as opposed to a "relation"), see `Project`.
     */
    predicate tp(R related) {
      exists(A a, B b, C c, D d, E e, F f |
        base(a, b, c, d, e, f) and
        related = r(a, b, c, d, e, f)
      )
    }
    // TODO: import Tp1<R, tp/1> ?
  }

  /**
   * Project this tuple set to a new tuple set of 2 values per row, by using a set of
   * projection functions.
   *
   * Sibling module of `ProjectRelate2` (which takes a set of "relations" instead of "functions").
   *
   * Each project function accepts the values of a tuple from this tuple set, and returns a new
   * value, where the value returned by the nth function will become the nth column in the new tuple
   * set.
   *
   * For example, the following projection switches (first, last) names to (last, first) names.
   * ```ql
   * predicate firstLast(string first, string last) { exists(Person p | ... ) }
   *
   * import Tp2<string, string, firstLast/2>
   *   ::Project2<string, string,
   *       Tuples2<string, string>::getFirst/2,
   *       Tuples2<string, string>::getSecond/2>
   *   as LastFirst
   *
   * // Selects ("Curie", "Maria"), ("Einstein", "Albert"), etc.
   * from string a, string b where LastFirst::tp(a, b) select a, b
   * ```
   */
  module Project2<
    InfiniteStringableType A0, InfiniteStringableType B0, FnType6<A0, A, B, C, D, E, F>::fn/6 pja0,
    FnType6<B0, A, B, C, D, E, F>::fn/6 pjb0>
  {
    predicate tp(A0 a0, B0 b0) {
      exists(A a, B b, C c, D d, E e, F f |
        base(a, b, c, d, e, f) and
        a0 = pja0(a, b, c, d, e, f) and
        b0 = pjb0(a, b, c, d, e, f)
      )
    }
  }

  /**
   * Project this tuple set to a new tuple set of 2 values per row, by using a set of
   * relations.
   *
   * Sibling module of `Project2` (which takes a set of "functions" instead of "relations").
   *
   * Each projection relation accepts the values of a tuple from this tuple set, and returns a new
   * value, where the value held by the nth relation will become the nth column in the new tuple
   * set.
   *
   * For example, the following projection switches (first, last) names to (last, first) names.
   * ```ql
   * predicate siblings(Person a, Person b) { ... }
   * Person motherOf(Person a, Person b) { ... }
   * Person fatherOf(Person a, Person b) { ... }
   *
   * import Tp2<Person, Person, siblings/2>
   *     ::Project2<Person, Person, motherOf/2, fatherOf/2>
   *   as SiblingParents
   *
   * // Selects (mother, father) that have a pair of children
   * from Person mother, Person father where SiblingParents::tp(mother, father)
   * select mother, father
   * ```
   */
  module ProjectRelate2<
    InfiniteStringableType A0, InfiniteStringableType B0,
    RelType6<A0, A, B, C, D, E, F>::rel/6 pja0, RelType6<B0, A, B, C, D, E, F>::rel/6 pjb0>
  {
    predicate tp(A0 a0, B0 b0) {
      exists(A a, B b, C c, D d, E e, F f |
        base(a, b, c, d, e, f) and
        a0 = pja0(a, b, c, d, e, f) and
        b0 = pjb0(a, b, c, d, e, f)
      )
    }
  }

  /**
   * Project this tuple set to a new tuple set of 3 values per row, by using a set of
   * projection functions.
   *
   * Sibling module of `ProjectRelate3` (which takes a set of "relations" instead of "functions").
   *
   * Each project function accepts the values of a tuple from this tuple set, and returns a new
   * value, where the value returned by the nth function will become the nth column in the new tuple
   * set.
   *
   * For example, the following projection switches (first, last) names to (last, first) names.
   * ```ql
   * predicate firstLast(string first, string last) { exists(Person p | ... ) }
   *
   * import Tp2<string, string, firstLast/2>
   *   ::Project2<string, string,
   *       Tuples2<string, string>::getFirst/2,
   *       Tuples2<string, string>::getSecond/2>
   *   as LastFirst
   *
   * // Selects ("Curie", "Maria"), ("Einstein", "Albert"), etc.
   * from string a, string b where LastFirst::tp(a, b) select a, b
   * ```
   */
  module Project3<
    InfiniteStringableType A0, InfiniteStringableType B0, InfiniteStringableType C0,
    FnType6<A0, A, B, C, D, E, F>::fn/6 pja0, FnType6<B0, A, B, C, D, E, F>::fn/6 pjb0,
    FnType6<C0, A, B, C, D, E, F>::fn/6 pjc0>
  {
    predicate tp(A0 a0, B0 b0, C0 c0) {
      exists(A a, B b, C c, D d, E e, F f |
        base(a, b, c, d, e, f) and
        a0 = pja0(a, b, c, d, e, f) and
        b0 = pjb0(a, b, c, d, e, f) and
        c0 = pjc0(a, b, c, d, e, f)
      )
    }
  }

  /**
   * Project this tuple set to a new tuple set of 3 values per row, by using a set of
   * relations.
   *
   * Sibling module of `Project3` (which takes a set of "functions" instead of "relations").
   *
   * Each projection relation accepts the values of a tuple from this tuple set, and returns a new
   * value, where the value held by the nth relation will become the nth column in the new tuple
   * set.
   *
   * For example, the following projection switches (first, last) names to (last, first) names.
   * ```ql
   * predicate siblings(Person a, Person b) { ... }
   * Person motherOf(Person a, Person b) { ... }
   * Person fatherOf(Person a, Person b) { ... }
   *
   * import Tp2<Person, Person, siblings/2>
   *     ::Project2<Person, Person, motherOf/2, fatherOf/2>
   *   as SiblingParents
   *
   * // Selects (mother, father) that have a pair of children
   * from Person mother, Person father where SiblingParents::tp(mother, father)
   * select mother, father
   * ```
   */
  module ProjectRelate3<
    InfiniteStringableType A0, InfiniteStringableType B0, InfiniteStringableType C0,
    RelType6<A0, A, B, C, D, E, F>::rel/6 pja0, RelType6<B0, A, B, C, D, E, F>::rel/6 pjb0,
    RelType6<C0, A, B, C, D, E, F>::rel/6 pjc0>
  {
    predicate tp(A0 a0, B0 b0, C0 c0) {
      exists(A a, B b, C c, D d, E e, F f |
        base(a, b, c, d, e, f) and
        a0 = pja0(a, b, c, d, e, f) and
        b0 = pjb0(a, b, c, d, e, f) and
        c0 = pjc0(a, b, c, d, e, f)
      )
    }
  }

  /**
   * Project this tuple set to a new tuple set of 4 values per row, by using a set of
   * projection functions.
   *
   * Sibling module of `ProjectRelate4` (which takes a set of "relations" instead of "functions").
   *
   * Each project function accepts the values of a tuple from this tuple set, and returns a new
   * value, where the value returned by the nth function will become the nth column in the new tuple
   * set.
   *
   * For example, the following projection switches (first, last) names to (last, first) names.
   * ```ql
   * predicate firstLast(string first, string last) { exists(Person p | ... ) }
   *
   * import Tp2<string, string, firstLast/2>
   *   ::Project2<string, string,
   *       Tuples2<string, string>::getFirst/2,
   *       Tuples2<string, string>::getSecond/2>
   *   as LastFirst
   *
   * // Selects ("Curie", "Maria"), ("Einstein", "Albert"), etc.
   * from string a, string b where LastFirst::tp(a, b) select a, b
   * ```
   */
  module Project4<
    InfiniteStringableType A0, InfiniteStringableType B0, InfiniteStringableType C0,
    InfiniteStringableType D0, FnType6<A0, A, B, C, D, E, F>::fn/6 pja0,
    FnType6<B0, A, B, C, D, E, F>::fn/6 pjb0, FnType6<C0, A, B, C, D, E, F>::fn/6 pjc0,
    FnType6<D0, A, B, C, D, E, F>::fn/6 pjd0>
  {
    predicate tp(A0 a0, B0 b0, C0 c0, D0 d0) {
      exists(A a, B b, C c, D d, E e, F f |
        base(a, b, c, d, e, f) and
        a0 = pja0(a, b, c, d, e, f) and
        b0 = pjb0(a, b, c, d, e, f) and
        c0 = pjc0(a, b, c, d, e, f) and
        d0 = pjd0(a, b, c, d, e, f)
      )
    }
  }

  /**
   * Project this tuple set to a new tuple set of 4 values per row, by using a set of
   * relations.
   *
   * Sibling module of `Project4` (which takes a set of "functions" instead of "relations").
   *
   * Each projection relation accepts the values of a tuple from this tuple set, and returns a new
   * value, where the value held by the nth relation will become the nth column in the new tuple
   * set.
   *
   * For example, the following projection switches (first, last) names to (last, first) names.
   * ```ql
   * predicate siblings(Person a, Person b) { ... }
   * Person motherOf(Person a, Person b) { ... }
   * Person fatherOf(Person a, Person b) { ... }
   *
   * import Tp2<Person, Person, siblings/2>
   *     ::Project2<Person, Person, motherOf/2, fatherOf/2>
   *   as SiblingParents
   *
   * // Selects (mother, father) that have a pair of children
   * from Person mother, Person father where SiblingParents::tp(mother, father)
   * select mother, father
   * ```
   */
  module ProjectRelate4<
    InfiniteStringableType A0, InfiniteStringableType B0, InfiniteStringableType C0,
    InfiniteStringableType D0, RelType6<A0, A, B, C, D, E, F>::rel/6 pja0,
    RelType6<B0, A, B, C, D, E, F>::rel/6 pjb0, RelType6<C0, A, B, C, D, E, F>::rel/6 pjc0,
    RelType6<D0, A, B, C, D, E, F>::rel/6 pjd0>
  {
    predicate tp(A0 a0, B0 b0, C0 c0, D0 d0) {
      exists(A a, B b, C c, D d, E e, F f |
        base(a, b, c, d, e, f) and
        a0 = pja0(a, b, c, d, e, f) and
        b0 = pjb0(a, b, c, d, e, f) and
        c0 = pjc0(a, b, c, d, e, f) and
        d0 = pjd0(a, b, c, d, e, f)
      )
    }
  }

  /**
   * Project this tuple set to a new tuple set of 5 values per row, by using a set of
   * projection functions.
   *
   * Sibling module of `ProjectRelate5` (which takes a set of "relations" instead of "functions").
   *
   * Each project function accepts the values of a tuple from this tuple set, and returns a new
   * value, where the value returned by the nth function will become the nth column in the new tuple
   * set.
   *
   * For example, the following projection switches (first, last) names to (last, first) names.
   * ```ql
   * predicate firstLast(string first, string last) { exists(Person p | ... ) }
   *
   * import Tp2<string, string, firstLast/2>
   *   ::Project2<string, string,
   *       Tuples2<string, string>::getFirst/2,
   *       Tuples2<string, string>::getSecond/2>
   *   as LastFirst
   *
   * // Selects ("Curie", "Maria"), ("Einstein", "Albert"), etc.
   * from string a, string b where LastFirst::tp(a, b) select a, b
   * ```
   */
  module Project5<
    InfiniteStringableType A0, InfiniteStringableType B0, InfiniteStringableType C0,
    InfiniteStringableType D0, InfiniteStringableType E0, FnType6<A0, A, B, C, D, E, F>::fn/6 pja0,
    FnType6<B0, A, B, C, D, E, F>::fn/6 pjb0, FnType6<C0, A, B, C, D, E, F>::fn/6 pjc0,
    FnType6<D0, A, B, C, D, E, F>::fn/6 pjd0, FnType6<E0, A, B, C, D, E, F>::fn/6 pje0>
  {
    predicate tp(A0 a0, B0 b0, C0 c0, D0 d0, E0 e0) {
      exists(A a, B b, C c, D d, E e, F f |
        base(a, b, c, d, e, f) and
        a0 = pja0(a, b, c, d, e, f) and
        b0 = pjb0(a, b, c, d, e, f) and
        c0 = pjc0(a, b, c, d, e, f) and
        d0 = pjd0(a, b, c, d, e, f) and
        e0 = pje0(a, b, c, d, e, f)
      )
    }
  }

  /**
   * Project this tuple set to a new tuple set of 5 values per row, by using a set of
   * relations.
   *
   * Sibling module of `Project5` (which takes a set of "functions" instead of "relations").
   *
   * Each projection relation accepts the values of a tuple from this tuple set, and returns a new
   * value, where the value held by the nth relation will become the nth column in the new tuple
   * set.
   *
   * For example, the following projection switches (first, last) names to (last, first) names.
   * ```ql
   * predicate siblings(Person a, Person b) { ... }
   * Person motherOf(Person a, Person b) { ... }
   * Person fatherOf(Person a, Person b) { ... }
   *
   * import Tp2<Person, Person, siblings/2>
   *     ::Project2<Person, Person, motherOf/2, fatherOf/2>
   *   as SiblingParents
   *
   * // Selects (mother, father) that have a pair of children
   * from Person mother, Person father where SiblingParents::tp(mother, father)
   * select mother, father
   * ```
   */
  module ProjectRelate5<
    InfiniteStringableType A0, InfiniteStringableType B0, InfiniteStringableType C0,
    InfiniteStringableType D0, InfiniteStringableType E0,
    RelType6<A0, A, B, C, D, E, F>::rel/6 pja0, RelType6<B0, A, B, C, D, E, F>::rel/6 pjb0,
    RelType6<C0, A, B, C, D, E, F>::rel/6 pjc0, RelType6<D0, A, B, C, D, E, F>::rel/6 pjd0,
    RelType6<E0, A, B, C, D, E, F>::rel/6 pje0>
  {
    predicate tp(A0 a0, B0 b0, C0 c0, D0 d0, E0 e0) {
      exists(A a, B b, C c, D d, E e, F f |
        base(a, b, c, d, e, f) and
        a0 = pja0(a, b, c, d, e, f) and
        b0 = pjb0(a, b, c, d, e, f) and
        c0 = pjc0(a, b, c, d, e, f) and
        d0 = pjd0(a, b, c, d, e, f) and
        e0 = pje0(a, b, c, d, e, f)
      )
    }
  }

  /**
   * Project this tuple set to a new tuple set of 6 values per row, by using a set of
   * projection functions.
   *
   * Sibling module of `ProjectRelate6` (which takes a set of "relations" instead of "functions").
   *
   * Each project function accepts the values of a tuple from this tuple set, and returns a new
   * value, where the value returned by the nth function will become the nth column in the new tuple
   * set.
   *
   * For example, the following projection switches (first, last) names to (last, first) names.
   * ```ql
   * predicate firstLast(string first, string last) { exists(Person p | ... ) }
   *
   * import Tp2<string, string, firstLast/2>
   *   ::Project2<string, string,
   *       Tuples2<string, string>::getFirst/2,
   *       Tuples2<string, string>::getSecond/2>
   *   as LastFirst
   *
   * // Selects ("Curie", "Maria"), ("Einstein", "Albert"), etc.
   * from string a, string b where LastFirst::tp(a, b) select a, b
   * ```
   */
  module Project6<
    InfiniteStringableType A0, InfiniteStringableType B0, InfiniteStringableType C0,
    InfiniteStringableType D0, InfiniteStringableType E0, InfiniteStringableType F0,
    FnType6<A0, A, B, C, D, E, F>::fn/6 pja0, FnType6<B0, A, B, C, D, E, F>::fn/6 pjb0,
    FnType6<C0, A, B, C, D, E, F>::fn/6 pjc0, FnType6<D0, A, B, C, D, E, F>::fn/6 pjd0,
    FnType6<E0, A, B, C, D, E, F>::fn/6 pje0, FnType6<F0, A, B, C, D, E, F>::fn/6 pjf0>
  {
    predicate tp(A0 a0, B0 b0, C0 c0, D0 d0, E0 e0, F0 f0) {
      exists(A a, B b, C c, D d, E e, F f |
        base(a, b, c, d, e, f) and
        a0 = pja0(a, b, c, d, e, f) and
        b0 = pjb0(a, b, c, d, e, f) and
        c0 = pjc0(a, b, c, d, e, f) and
        d0 = pjd0(a, b, c, d, e, f) and
        e0 = pje0(a, b, c, d, e, f) and
        f0 = pjf0(a, b, c, d, e, f)
      )
    }
  }

  /**
   * Project this tuple set to a new tuple set of 6 values per row, by using a set of
   * relations.
   *
   * Sibling module of `Project6` (which takes a set of "functions" instead of "relations").
   *
   * Each projection relation accepts the values of a tuple from this tuple set, and returns a new
   * value, where the value held by the nth relation will become the nth column in the new tuple
   * set.
   *
   * For example, the following projection switches (first, last) names to (last, first) names.
   * ```ql
   * predicate siblings(Person a, Person b) { ... }
   * Person motherOf(Person a, Person b) { ... }
   * Person fatherOf(Person a, Person b) { ... }
   *
   * import Tp2<Person, Person, siblings/2>
   *     ::Project2<Person, Person, motherOf/2, fatherOf/2>
   *   as SiblingParents
   *
   * // Selects (mother, father) that have a pair of children
   * from Person mother, Person father where SiblingParents::tp(mother, father)
   * select mother, father
   * ```
   */
  module ProjectRelate6<
    InfiniteStringableType A0, InfiniteStringableType B0, InfiniteStringableType C0,
    InfiniteStringableType D0, InfiniteStringableType E0, InfiniteStringableType F0,
    RelType6<A0, A, B, C, D, E, F>::rel/6 pja0, RelType6<B0, A, B, C, D, E, F>::rel/6 pjb0,
    RelType6<C0, A, B, C, D, E, F>::rel/6 pjc0, RelType6<D0, A, B, C, D, E, F>::rel/6 pjd0,
    RelType6<E0, A, B, C, D, E, F>::rel/6 pje0, RelType6<F0, A, B, C, D, E, F>::rel/6 pjf0>
  {
    predicate tp(A0 a0, B0 b0, C0 c0, D0 d0, E0 e0, F0 f0) {
      exists(A a, B b, C c, D d, E e, F f |
        base(a, b, c, d, e, f) and
        a0 = pja0(a, b, c, d, e, f) and
        b0 = pjb0(a, b, c, d, e, f) and
        c0 = pjc0(a, b, c, d, e, f) and
        d0 = pjd0(a, b, c, d, e, f) and
        e0 = pje0(a, b, c, d, e, f) and
        f0 = pjf0(a, b, c, d, e, f)
      )
    }
  }

  /**
   * Maps the set of first values in the set of tuples that satisfy the given predicate,
   * against a mapper function.
   *
   * Sibling function of `MapRelateFirst`, which operates on "relations" instead of
   * "functions."
   *
   * Example:
   * ```ql
   * predicate employs(Company company, Person person) { ... }
   *
   * // Selects the ages of employed People.
   * select Tp2<Company, Person, employs/2>
   *   ::MapSecond<int, getAge/1>
   *   ::find()
   * ```
   */
  module MapFirst<InfiniteStringableType R, FnType1<R, A>::fn/1 map> {
    R find() {
      exists(A a |
        base(a, _, _, _, _, _) and
        result = map(a)
      )
    }
  }

  /**
   * Maps the set of first values in the set of tuples that satisfy the given predicate,
   * against a mapper relation.
   *
   * Sibling function of `MapFirst`, which operates on "functions" instead of
   * "relations."
   *
   * Example:
   * ```ql
   * predicate employs(Company company, Person person) { ... }
   * Pet getPets(Person p) { ... }
   *
   * // Selects the pets of employed People.
   * select Tp2<Company, Person, employs/2>
   *   ::MapRelateSecond<Pet, getPets/1>
   *   ::find()
   * ```
   */
  module MapRelateFirst<InfiniteStringableType R, RelType1<R, A>::rel/1 map> {
    R find() {
      exists(A a |
        base(a, _, _, _, _, _) and
        result = map(a)
      )
    }
  }

  /**
   * Maps the set of second values in the set of tuples that satisfy the given predicate,
   * against a mapper function.
   *
   * Sibling function of `MapRelateSecond`, which operates on "relations" instead of
   * "functions."
   *
   * Example:
   * ```ql
   * predicate employs(Company company, Person person) { ... }
   *
   * // Selects the ages of employed People.
   * select Tp2<Company, Person, employs/2>
   *   ::MapSecond<int, getAge/1>
   *   ::find()
   * ```
   */
  module MapSecond<InfiniteStringableType R, FnType1<R, B>::fn/1 map> {
    R find() {
      exists(B b |
        base(_, b, _, _, _, _) and
        result = map(b)
      )
    }
  }

  /**
   * Maps the set of second values in the set of tuples that satisfy the given predicate,
   * against a mapper relation.
   *
   * Sibling function of `MapSecond`, which operates on "functions" instead of
   * "relations."
   *
   * Example:
   * ```ql
   * predicate employs(Company company, Person person) { ... }
   * Pet getPets(Person p) { ... }
   *
   * // Selects the pets of employed People.
   * select Tp2<Company, Person, employs/2>
   *   ::MapRelateSecond<Pet, getPets/1>
   *   ::find()
   * ```
   */
  module MapRelateSecond<InfiniteStringableType R, RelType1<R, B>::rel/1 map> {
    R find() {
      exists(B b |
        base(_, b, _, _, _, _) and
        result = map(b)
      )
    }
  }

  /**
   * Maps the set of third values in the set of tuples that satisfy the given predicate,
   * against a mapper function.
   *
   * Sibling function of `MapRelateThird`, which operates on "relations" instead of
   * "functions."
   *
   * Example:
   * ```ql
   * predicate employs(Company company, Person person) { ... }
   *
   * // Selects the ages of employed People.
   * select Tp2<Company, Person, employs/2>
   *   ::MapSecond<int, getAge/1>
   *   ::find()
   * ```
   */
  module MapThird<InfiniteStringableType R, FnType1<R, C>::fn/1 map> {
    R find() {
      exists(C c |
        base(_, _, c, _, _, _) and
        result = map(c)
      )
    }
  }

  /**
   * Maps the set of third values in the set of tuples that satisfy the given predicate,
   * against a mapper relation.
   *
   * Sibling function of `MapThird`, which operates on "functions" instead of
   * "relations."
   *
   * Example:
   * ```ql
   * predicate employs(Company company, Person person) { ... }
   * Pet getPets(Person p) { ... }
   *
   * // Selects the pets of employed People.
   * select Tp2<Company, Person, employs/2>
   *   ::MapRelateSecond<Pet, getPets/1>
   *   ::find()
   * ```
   */
  module MapRelateThird<InfiniteStringableType R, RelType1<R, C>::rel/1 map> {
    R find() {
      exists(C c |
        base(_, _, c, _, _, _) and
        result = map(c)
      )
    }
  }

  /**
   * Maps the set of fourth values in the set of tuples that satisfy the given predicate,
   * against a mapper function.
   *
   * Sibling function of `MapRelateFourth`, which operates on "relations" instead of
   * "functions."
   *
   * Example:
   * ```ql
   * predicate employs(Company company, Person person) { ... }
   *
   * // Selects the ages of employed People.
   * select Tp2<Company, Person, employs/2>
   *   ::MapSecond<int, getAge/1>
   *   ::find()
   * ```
   */
  module MapFourth<InfiniteStringableType R, FnType1<R, D>::fn/1 map> {
    R find() {
      exists(D d |
        base(_, _, _, d, _, _) and
        result = map(d)
      )
    }
  }

  /**
   * Maps the set of fourth values in the set of tuples that satisfy the given predicate,
   * against a mapper relation.
   *
   * Sibling function of `MapFourth`, which operates on "functions" instead of
   * "relations."
   *
   * Example:
   * ```ql
   * predicate employs(Company company, Person person) { ... }
   * Pet getPets(Person p) { ... }
   *
   * // Selects the pets of employed People.
   * select Tp2<Company, Person, employs/2>
   *   ::MapRelateSecond<Pet, getPets/1>
   *   ::find()
   * ```
   */
  module MapRelateFourth<InfiniteStringableType R, RelType1<R, D>::rel/1 map> {
    R find() {
      exists(D d |
        base(_, _, _, d, _, _) and
        result = map(d)
      )
    }
  }

  /**
   * Maps the set of fifth values in the set of tuples that satisfy the given predicate,
   * against a mapper function.
   *
   * Sibling function of `MapRelateFifth`, which operates on "relations" instead of
   * "functions."
   *
   * Example:
   * ```ql
   * predicate employs(Company company, Person person) { ... }
   *
   * // Selects the ages of employed People.
   * select Tp2<Company, Person, employs/2>
   *   ::MapSecond<int, getAge/1>
   *   ::find()
   * ```
   */
  module MapFifth<InfiniteStringableType R, FnType1<R, E>::fn/1 map> {
    R find() {
      exists(E e |
        base(_, _, _, _, e, _) and
        result = map(e)
      )
    }
  }

  /**
   * Maps the set of fifth values in the set of tuples that satisfy the given predicate,
   * against a mapper relation.
   *
   * Sibling function of `MapFifth`, which operates on "functions" instead of
   * "relations."
   *
   * Example:
   * ```ql
   * predicate employs(Company company, Person person) { ... }
   * Pet getPets(Person p) { ... }
   *
   * // Selects the pets of employed People.
   * select Tp2<Company, Person, employs/2>
   *   ::MapRelateSecond<Pet, getPets/1>
   *   ::find()
   * ```
   */
  module MapRelateFifth<InfiniteStringableType R, RelType1<R, E>::rel/1 map> {
    R find() {
      exists(E e |
        base(_, _, _, _, e, _) and
        result = map(e)
      )
    }
  }

  /**
   * Maps the set of sixth values in the set of tuples that satisfy the given predicate,
   * against a mapper function.
   *
   * Sibling function of `MapRelateSixth`, which operates on "relations" instead of
   * "functions."
   *
   * Example:
   * ```ql
   * predicate employs(Company company, Person person) { ... }
   *
   * // Selects the ages of employed People.
   * select Tp2<Company, Person, employs/2>
   *   ::MapSecond<int, getAge/1>
   *   ::find()
   * ```
   */
  module MapSixth<InfiniteStringableType R, FnType1<R, F>::fn/1 map> {
    R find() {
      exists(F f |
        base(_, _, _, _, _, f) and
        result = map(f)
      )
    }
  }

  /**
   * Maps the set of sixth values in the set of tuples that satisfy the given predicate,
   * against a mapper relation.
   *
   * Sibling function of `MapSixth`, which operates on "functions" instead of
   * "relations."
   *
   * Example:
   * ```ql
   * predicate employs(Company company, Person person) { ... }
   * Pet getPets(Person p) { ... }
   *
   * // Selects the pets of employed People.
   * select Tp2<Company, Person, employs/2>
   *   ::MapRelateSecond<Pet, getPets/1>
   *   ::find()
   * ```
   */
  module MapRelateSixth<InfiniteStringableType R, RelType1<R, F>::rel/1 map> {
    R find() {
      exists(F f |
        base(_, _, _, _, _, f) and
        result = map(f)
      )
    }
  }

  /**
   * Maps the set of first values in the set of tuples that satisfy the given predicate,
   * against a mapper function, and use the result to add a column to this tuple set.
   *
   * Sibling function of `ExtendRelateFirst`, which operates on "relations" instead of
   * "functions."
   *
   * Example:
   * ```ql
   * predicate hasName(Person person, string name) { ... }
   * string getInitials(string name) { ... }
   *
   * // Selects (person, name, initials)
   * import Tp2<Person, string, hasName/2>
   *   ::ExtendMapSecond<string, getInitials/1>
   *   ::Query
   * ```
   */
  module ExtendMapFirst<InfiniteStringableType R, FnType1<R, A>::fn/1 map> {
    predicate tp(A a, B b, C c, D d, E e, F f, R r) {
      base(a, b, c, d, e, f) and
      r = map(a)
    }
  }

  /**
   * Maps the set of first values in the set of tuples that satisfy the given predicate,
   * against a mapper function, and use the result to add a column to this tuple set.
   *
   * Sibling function of `ExtendRelateFirst`, which operates on "relations" instead of
   * "functions."
   *
   * Example:
   * ```ql
   * predicate employs(Company company, Person person) { ... }
   * Address hasAddress(Person p) { ... }
   *
   * // Selects (company, person, age) for all employed people.
   * import Tp2<Company, Person, employs/2>
   *   ::ExtendRelateSecond<getAge/1>
   *   ::Query
   * ```
   */
  module ExtendRelateFirst<InfiniteStringableType R, RelType1<R, A>::rel/1 map> {
    predicate tp(A a, B b, C c, D d, E e, F f, R r) {
      base(a, b, c, d, e, f) and
      r = map(a)
    }
  }

  /**
   * Maps the set of second values in the set of tuples that satisfy the given predicate,
   * against a mapper function, and use the result to add a column to this tuple set.
   *
   * Sibling function of `ExtendRelateSecond`, which operates on "relations" instead of
   * "functions."
   *
   * Example:
   * ```ql
   * predicate hasName(Person person, string name) { ... }
   * string getInitials(string name) { ... }
   *
   * // Selects (person, name, initials)
   * import Tp2<Person, string, hasName/2>
   *   ::ExtendMapSecond<string, getInitials/1>
   *   ::Query
   * ```
   */
  module ExtendMapSecond<InfiniteStringableType R, FnType1<R, B>::fn/1 map> {
    predicate tp(A a, B b, C c, D d, E e, F f, R r) {
      base(a, b, c, d, e, f) and
      r = map(b)
    }
  }

  /**
   * Maps the set of second values in the set of tuples that satisfy the given predicate,
   * against a mapper function, and use the result to add a column to this tuple set.
   *
   * Sibling function of `ExtendRelateSecond`, which operates on "relations" instead of
   * "functions."
   *
   * Example:
   * ```ql
   * predicate employs(Company company, Person person) { ... }
   * Address hasAddress(Person p) { ... }
   *
   * // Selects (company, person, age) for all employed people.
   * import Tp2<Company, Person, employs/2>
   *   ::ExtendRelateSecond<getAge/1>
   *   ::Query
   * ```
   */
  module ExtendRelateSecond<InfiniteStringableType R, RelType1<R, B>::rel/1 map> {
    predicate tp(A a, B b, C c, D d, E e, F f, R r) {
      base(a, b, c, d, e, f) and
      r = map(b)
    }
  }

  /**
   * Maps the set of third values in the set of tuples that satisfy the given predicate,
   * against a mapper function, and use the result to add a column to this tuple set.
   *
   * Sibling function of `ExtendRelateThird`, which operates on "relations" instead of
   * "functions."
   *
   * Example:
   * ```ql
   * predicate hasName(Person person, string name) { ... }
   * string getInitials(string name) { ... }
   *
   * // Selects (person, name, initials)
   * import Tp2<Person, string, hasName/2>
   *   ::ExtendMapSecond<string, getInitials/1>
   *   ::Query
   * ```
   */
  module ExtendMapThird<InfiniteStringableType R, FnType1<R, C>::fn/1 map> {
    predicate tp(A a, B b, C c, D d, E e, F f, R r) {
      base(a, b, c, d, e, f) and
      r = map(c)
    }
  }

  /**
   * Maps the set of third values in the set of tuples that satisfy the given predicate,
   * against a mapper function, and use the result to add a column to this tuple set.
   *
   * Sibling function of `ExtendRelateThird`, which operates on "relations" instead of
   * "functions."
   *
   * Example:
   * ```ql
   * predicate employs(Company company, Person person) { ... }
   * Address hasAddress(Person p) { ... }
   *
   * // Selects (company, person, age) for all employed people.
   * import Tp2<Company, Person, employs/2>
   *   ::ExtendRelateSecond<getAge/1>
   *   ::Query
   * ```
   */
  module ExtendRelateThird<InfiniteStringableType R, RelType1<R, C>::rel/1 map> {
    predicate tp(A a, B b, C c, D d, E e, F f, R r) {
      base(a, b, c, d, e, f) and
      r = map(c)
    }
  }

  /**
   * Maps the set of fourth values in the set of tuples that satisfy the given predicate,
   * against a mapper function, and use the result to add a column to this tuple set.
   *
   * Sibling function of `ExtendRelateFourth`, which operates on "relations" instead of
   * "functions."
   *
   * Example:
   * ```ql
   * predicate hasName(Person person, string name) { ... }
   * string getInitials(string name) { ... }
   *
   * // Selects (person, name, initials)
   * import Tp2<Person, string, hasName/2>
   *   ::ExtendMapSecond<string, getInitials/1>
   *   ::Query
   * ```
   */
  module ExtendMapFourth<InfiniteStringableType R, FnType1<R, D>::fn/1 map> {
    predicate tp(A a, B b, C c, D d, E e, F f, R r) {
      base(a, b, c, d, e, f) and
      r = map(d)
    }
  }

  /**
   * Maps the set of fourth values in the set of tuples that satisfy the given predicate,
   * against a mapper function, and use the result to add a column to this tuple set.
   *
   * Sibling function of `ExtendRelateFourth`, which operates on "relations" instead of
   * "functions."
   *
   * Example:
   * ```ql
   * predicate employs(Company company, Person person) { ... }
   * Address hasAddress(Person p) { ... }
   *
   * // Selects (company, person, age) for all employed people.
   * import Tp2<Company, Person, employs/2>
   *   ::ExtendRelateSecond<getAge/1>
   *   ::Query
   * ```
   */
  module ExtendRelateFourth<InfiniteStringableType R, RelType1<R, D>::rel/1 map> {
    predicate tp(A a, B b, C c, D d, E e, F f, R r) {
      base(a, b, c, d, e, f) and
      r = map(d)
    }
  }

  /**
   * Maps the set of fifth values in the set of tuples that satisfy the given predicate,
   * against a mapper function, and use the result to add a column to this tuple set.
   *
   * Sibling function of `ExtendRelateFifth`, which operates on "relations" instead of
   * "functions."
   *
   * Example:
   * ```ql
   * predicate hasName(Person person, string name) { ... }
   * string getInitials(string name) { ... }
   *
   * // Selects (person, name, initials)
   * import Tp2<Person, string, hasName/2>
   *   ::ExtendMapSecond<string, getInitials/1>
   *   ::Query
   * ```
   */
  module ExtendMapFifth<InfiniteStringableType R, FnType1<R, E>::fn/1 map> {
    predicate tp(A a, B b, C c, D d, E e, F f, R r) {
      base(a, b, c, d, e, f) and
      r = map(e)
    }
  }

  /**
   * Maps the set of fifth values in the set of tuples that satisfy the given predicate,
   * against a mapper function, and use the result to add a column to this tuple set.
   *
   * Sibling function of `ExtendRelateFifth`, which operates on "relations" instead of
   * "functions."
   *
   * Example:
   * ```ql
   * predicate employs(Company company, Person person) { ... }
   * Address hasAddress(Person p) { ... }
   *
   * // Selects (company, person, age) for all employed people.
   * import Tp2<Company, Person, employs/2>
   *   ::ExtendRelateSecond<getAge/1>
   *   ::Query
   * ```
   */
  module ExtendRelateFifth<InfiniteStringableType R, RelType1<R, E>::rel/1 map> {
    predicate tp(A a, B b, C c, D d, E e, F f, R r) {
      base(a, b, c, d, e, f) and
      r = map(e)
    }
  }

  /**
   * Maps the set of sixth values in the set of tuples that satisfy the given predicate,
   * against a mapper function, and use the result to add a column to this tuple set.
   *
   * Sibling function of `ExtendRelateSixth`, which operates on "relations" instead of
   * "functions."
   *
   * Example:
   * ```ql
   * predicate hasName(Person person, string name) { ... }
   * string getInitials(string name) { ... }
   *
   * // Selects (person, name, initials)
   * import Tp2<Person, string, hasName/2>
   *   ::ExtendMapSecond<string, getInitials/1>
   *   ::Query
   * ```
   */
  module ExtendMapSixth<InfiniteStringableType R, FnType1<R, F>::fn/1 map> {
    predicate tp(A a, B b, C c, D d, E e, F f, R r) {
      base(a, b, c, d, e, f) and
      r = map(f)
    }
  }

  /**
   * Maps the set of sixth values in the set of tuples that satisfy the given predicate,
   * against a mapper function, and use the result to add a column to this tuple set.
   *
   * Sibling function of `ExtendRelateSixth`, which operates on "relations" instead of
   * "functions."
   *
   * Example:
   * ```ql
   * predicate employs(Company company, Person person) { ... }
   * Address hasAddress(Person p) { ... }
   *
   * // Selects (company, person, age) for all employed people.
   * import Tp2<Company, Person, employs/2>
   *   ::ExtendRelateSecond<getAge/1>
   *   ::Query
   * ```
   */
  module ExtendRelateSixth<InfiniteStringableType R, RelType1<R, F>::rel/1 map> {
    predicate tp(A a, B b, C c, D d, E e, F f, R r) {
      base(a, b, c, d, e, f) and
      r = map(f)
    }
  }

  /**
   * Takes a property which filters the contents of the current tuple set and produces a new one.
   *
   * Sibling predicate of `intersect`, which takes a "tuple predicate" instead of a "property."
   */
  module Filter<PropType6<A, B, C, D, E, F>::prop/6 flt> {
    predicate tp(A a, B b, C c, D d, E e, F f) {
      flt(a, b, c, d, e, f) and
      base(a, b, c, d, e, f)
    }
  }

  /**
   * Takes a tuple set and intersects it with the current tuple set to produce a new one.
   *
   * Sibling predicate of `filter`, which takes a "property" instead of a "tuple set."
   */
  module Intersect<TpType6<A, B, C, D, E, F>::tp/6 tp2> {
    predicate tp(A a, B b, C c, D d, E e, F f) {
      tp2(a, b, c, d, e, f) and
      base(a, b, c, d, e, f)
    }
  }

  /**
   * Creates a new tuple predicate that is a union of the current tuple set and the given one.
   */
  module Union<TpType6<A, B, C, D, E, F>::tp/6 tp2> {
    predicate tp(A a, B b, C c, D d, E e, F f) {
      tp2(a, b, c, d, e, f) or
      base(a, b, c, d, e, f)
    }
  }

  /**
   * Creates a new tuple predicate that holds the elements only in the current tuple set, not the
   * given one.
   */
  module Difference<TpType6<A, B, C, D, E, F>::tp/6 tp2> {
    predicate tp(A a, B b, C c, D d, E e, F f) {
      base(a, b, c, d, e, f) and
      not tp2(a, b, c, d, e, f)
    }
  }

  /**
   * Checks if (a, b, c, ...) is a member of the tuple set represented by this "tuple predicate."
   */
  predicate contains(A a, B b, C c, D d, E e, F f) { base(a, b, c, d, e, f) }

  /**
   * A module with a single predicate, `holds`, that holds if the current tuple set contains all
   * of the tuples of the given tuple predicate `tp2`.
   */
  module ContainsAll<TpType6<A, B, C, D, E, F>::tp/6 tp2> {
    predicate holds() {
      forall(A a, B b, C c, D d, E e, F f | tp2(a, b, c, d, e, f) | base(a, b, c, d, e, f))
    }
  }

  /**
   * A module with a single predicate, `holds`, that holds if the current tuple set contains any
   * of the tuples of the given tuple predicate `tp2`.
   *
   * Sibling predicate of `AnyHoldsFor`, which takes a "property" instead of a "tuple predicate."
   */
  module ContainsAny<TpType6<A, B, C, D, E, F>::tp/6 tp2> {
    predicate holds() {
      exists(A a, B b, C c, D d, E e, F f |
        tp2(a, b, c, d, e, f) and
        base(a, b, c, d, e, f)
      )
    }
  }

  /**
   * A module with a single predicate, `holds`, that holds if any of the tuples in the current tuple
   * satisfy the given property `prop`.
   *
   * Sibling predicate of `ContainsAny`, which takes a "tuple predicate" instead of a "property."
   */
  module AnyHoldsFor<PropType6<A, B, C, D, E, F>::prop/6 prop> {
    predicate holds() {
      exists(A a, B b, C c, D d, E e, F f |
        base(a, b, c, d, e, f) and
        prop(a, b, c, d, e, f)
      )
    }
  }

  /**
   * A module with a single predicate, `holds`, that holds if all of the tuples in the current tuple
   * set satisfy the given property `prop`.
   *
   * Sibling predicate of `ContainedBy` which takes a "tuple predicate" instead of a "property."
   */
  module AllHoldsFor<PropType6<A, B, C, D, E, F>::prop/6 prop> {
    predicate holds() {
      forall(A a, B b, C c, D d, E e, F f | base(a, b, c, d, e, f) | prop(a, b, c, d, e, f))
    }
  }

  /**
   * A module with a single predicate, `holds`, that holds if all of the tuples in the current tuple
   * set satisfy the given property `prop`.
   *
   * Sibling predicate of `AllHoldsFor`, which takes a "property" instead of a "tuple predicate."
   */
  module ContainedBy<TpType6<A, B, C, D, E, F>::tp/6 tp2> {
    predicate holds() {
      forall(A a, B b, C c, D d, E e, F f | base(a, b, c, d, e, f) | tp2(a, b, c, d, e, f))
    }
  }

  /**
   * Drop the first column in the set of tuples that satisfy the given predicate, and get
   * a new tuple set after that column has been dropped.
   */
  predicate dropFirst(B b, C c, D d, E e, F f) { base(_, b, c, d, e, f) }

  /**
   * Drop the second column in the set of tuples that satisfy the given predicate, and get
   * a new tuple set after that column has been dropped.
   */
  predicate dropSecond(A a, C c, D d, E e, F f) { base(a, _, c, d, e, f) }

  /**
   * Drop the third column in the set of tuples that satisfy the given predicate, and get
   * a new tuple set after that column has been dropped.
   */
  predicate dropThird(A a, B b, D d, E e, F f) { base(a, b, _, d, e, f) }

  /**
   * Drop the fourth column in the set of tuples that satisfy the given predicate, and get
   * a new tuple set after that column has been dropped.
   */
  predicate dropFourth(A a, B b, C c, E e, F f) { base(a, b, c, _, e, f) }

  /**
   * Drop the fifth column in the set of tuples that satisfy the given predicate, and get
   * a new tuple set after that column has been dropped.
   */
  predicate dropFifth(A a, B b, C c, D d, F f) { base(a, b, c, d, _, f) }

  /**
   * Drop the sixth column in the set of tuples that satisfy the given predicate, and get
   * a new tuple set after that column has been dropped.
   */
  predicate dropSixth(A a, B b, C c, D d, E e) { base(a, b, c, d, e, _) }

  /**
   * Count the number of tuples in this tuple set.
   */
  int doCount() { result = count(A a, B b, C c, D d, E e, F f | base(a, b, c, d, e, f)) }

  /**
   * Query for the contents of this tuple, by defining a query predicate `tpQuery` to import.
   */
  module Query {
    query predicate tpQuery(A a, B b, C c, D d, E e, F f) { base(a, b, c, d, e, f) }
  }
}
