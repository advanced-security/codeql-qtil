private import qtil.list.CondensedList
private import qtil.parameterization.Finalize
private import qtil.parameterization.SignatureTypes

/**
 * A module for adding `getNext()`, `getPrevious()` members to a type that is in some way
 * orderable, in optional groups.
 *
 * For instance, variables in a file may be ordered by their line number and grouped by their file.
 *
 * To use this module, extend the class `Ordered<T>::Type` or `Ordered<T>::GroupBy<G>::Type`,
 * where `T` is the type you want to order (for instance, a variable) and `G` is the optional type
 * you want to group by (for instance, a file name). You must also implement the member predicate
 * `int getOrder()` (items will be ordered by the result of this predicate) and if relevant, the
 * member `G getGroup()`.
 *
 * The member `getOrder()` must not have duplicate values for two items within the same group to
 * ensure correctness.
 *
 * Example grouped usage:
 * ```
 * class OrderedVar extends Ordered<Variable>::GroupBy<File>::Type {
 *   override int getOrder() { result = this.getLocation().getStartLine() }
 *   override File getGroup() { result = this.getFile() }
 * }
 *
 * // Selects all variables in a file, along with the previous and next.
 * from OrderedVar v
 * select v.getName(), v.getPrevious().getName(), v.getNext().getName()
 * ```
 *
 * Example ungrouped usage:
 * ```
 * class OrderedFib extends Ordered<int>::Type {
 *   OrderedFib() { this in fibonacciNumbers() }
 *   override int getOrder() { result = this }
 * }
 *
 * from OrderedFib f
 * select f, f.getPrevious(), f.getNext()
 * ```
 */
module Ordered<FiniteStringableType T> {
  /** Predicate parameter to the underlying condensed list for ungrouped ordered types. */
  private int getSparseIndexGlobal(Type type) { result = type.getOrder() }

  /* Import a condensed list of this type to find next and previous items. */
  private import CondenseList<Type, getSparseIndexGlobal/1>::Global as Global

  /**
   * Abstract class which should be extended to create a type which is ordered and not grouped.
   *
   * If the ordered data should be grouped (for instance, ordering variables by line number and
   * grouping by file), use `Ordered<T>::GroupBy<G>::Type` instead.
   *
   * To use this class, extend it e.g. `class OrderedInt extends Ordered<int>::Type` and implement
   * the member `int getOrder()`, which is used to order the items. `getOrder` must be unique
   * across items in the list to ensure correctness.
   */
  abstract class Type extends Final<T>::Type {
    /**
     * Items are ordered by the result of this member predicate.
     *
     * This must be unique across items in the list to ensure correctness.
     */
    abstract int getOrder();

    /**
     * Returns the index of this item in the dense list.
     *
     * This is a 1-based index, so the first item in the list will have index 1.
     */
    int getDenseIndex() { result = getListEntry().getDenseIndex() }

    /**
     * Returns the previous item in the list.
     *
     * Does not hold if this is the first item in the list.
     */
    Type getPrevious() { result.getListEntry() = getListEntry().getPrev() }

    /**
     * Returns the next item in the list.
     *
     * Does not hold if this is the last item in the list.
     */
    Type getNext() { result.getListEntry() = getListEntry().getNext() }

    /**
     * Get the underlying `CondensedList::Global::ListEntry` for this item.
     */
    Global::ListEntry getListEntry() { result.getItem() = this }
  }

  /**
   * A module for adding `getNext()`, `getPrevious()` members to a type that is in some way
   * orderable, divided by some grouping.
   *
   * If the ordered data should not be grouped (for instance, ordering a subset of the integers),
   * use `Ordered<T>::Type` instead.
   *
   * See the module `Ordered` for more information.
   */
  module GroupBy<FiniteType Division> {
    /** Predicate parameter to the underlying condensed list for grouped ordered types. */
    private int getSparseIndexGrouped(Type type) { result = type.getOrder() }

    /** Predicate parameter to the underlying condensed list for grouping ordered types. */
    private Division getDivision(Type type) { result = type.getGroup() }

    /* Import a condensed and grouped list of this type to find next and previous items. */
    private import CondenseList<Type, getSparseIndexGrouped/1>::GroupBy<Division, getDivision/1> as Grouped

    /**
     * Abstract class which should be extended to create a type which is ordered and grouped (for
     * instance, ordering variables by line number and grouping by file).
     *
     * If the ordered data should not be grouped (for instance, ordering a subset of the integers),
     * use `Ordered<T>::Type` instead.
     *
     * To use this class, extend it e.g.
     * `class OrderedVariable extends Ordered<variable>::GroupBy<File>::Type` and implement
     * the members `int getOrder()`, which is used to order the items, and `File getGroup`, which is
     * used to segment the items into separate lists. The predicate `getOrder` must not have
     * duplicate values for two items within the same group to ensure correctness.
     */
    abstract class Type extends Final<T>::Type {
      /**
       * Items are ordered by the result of this member predicate.
       *
       * This must be unique across items in each group to ensure correctness.
       */
      abstract int getOrder();

      /**
       * Items are ordered by the result of this member predicate.
       *
       * This must be unique across items in each group to ensure correctness.
       */
      abstract Division getGroup();

      /**
       * Returns the index of this item in the dense list.
       *
       * This is a 1-based index, so the first item in the list will have index 1.
       */
      int getDenseIndex() { result = getListEntry().getDenseIndex() }

      /**
       * Returns the previous item in the list.
       *
       * Does not hold if this is the first item in the list.
       */
      Type getPrevious() { result.getListEntry() = getListEntry().getPrev() }

      /**
       * Returns the next item in the list.
       *
       * Does not hold if this is the last item in the list.
       */
      Type getNext() { result.getListEntry() = getListEntry().getNext() }

      /**
       * Get the underlying `CondensedList::GroupBy::ListEntry` for this item.
       */
      Grouped::ListEntry getListEntry() { result.getItem() = this }
    }
  }
}
