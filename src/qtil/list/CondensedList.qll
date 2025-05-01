private import qtil.parameterization.SignatureTypes
private import qtil.parameterization.SignaturePredicates
private import qtil.inheritance.Instance
private import codeql.util.Unit
private import codeql.util.DenseRank

/**
 * A module to take orderable data (which may not be continuous) and condense it into one or more
 * dense lists, with one such list per specified division.
 *
 * To instantiate this module, you need to provide at least one predicate that specifies the sparse
 * index of a given item. Items can be segmented into separate lists via another predicate which
 * specifies the division of each item.
 *
 * The sparse index (which may have gaps) is used to determine the ordering of the items in the
 * condensed list. Once the condensed list is created, the items in the list will automatically be
 * assigned a dense index (which has no gaps).
 *
 * For instance, to create a condensed list of variables defined in every file, create predicates
 * that specify the line number of the variable as the sparse index, and the file of the variable
 * as the division:
 *
 * ```ql
 *   int getLineNumber(File file) { result = file.getLocation().getStartLine() }
 *   File getFile(Variable var) { result = var.getLocation().getFile() }
 *
 *   class Entry = Condense<Variable, getLineNumber/1>::GroupBy<File, getFile/1>::ListEntry;
 *
 *   from Entry entry
 *   select entry, entry.getDivision(), entry.getItem(), entry.getDenseIndex(), entry.getNext(),
 *       entry.getPrev()
 * ```
 *
 * To get a list of all items without a division, use the class
 * `CondenseList<...>::Global::ListEntry`.
 *
 * This module will produce incorrect results if the sparse index contains duplicates for the
 * selected division.
 */
module CondenseList<FiniteStringableType Item, Unary<Item>::Ret<int>::pred/1 getSparseIndex> {
  module Global {
    private Unit toUnit(Item i) { any() }

    class ListEntry extends Instance<GroupBy<Unit, toUnit/1>::ListEntry>::Type {
      Item getItem() { result = inst().getItem() }

      int getDenseIndex() { result = inst().getDenseIndex() }

      ListEntry getNext() { result = inst().getNext() }

      ListEntry getPrev() { result = inst().getPrev() }
    }
  }

  /**
   * The division specifies which items are connected into lists, with one list per division.
   *
   * For instance, if connecting variables defined in a file, the division will be the file.
   */
  module GroupBy<InfiniteType Division, Unary<Item>::Ret<Division>::pred/1 getDivision> {
    private newtype TList =
      THead(Item l, Division t) { denseRank(t, l) = 1 } or
      TCons(ListEntry prev, Item l) { prev.getDenseIndex() = denseRank(prev.getDivision(), l) - 1 }

    private module DenseRankConfig implements DenseRankInputSig2 {
      class Ranked = Item;

      class C = Division;

      int getRank(Division d, Item i) { result = getSparseIndex(i) and d = getDivision(i) }
    }

    private import DenseRank2<DenseRankConfig>

    class ListEntry extends TList {
      Division getDivision() {
        this = THead(_, result)
        or
        exists(ListEntry prev | this = TCons(prev, _) and result = prev.getDivision())
      }

      string toString() { result = getItem().toString() + " [index " + getDenseIndex() + "]" }

      Item getItem() {
        this = THead(result, _)
        or
        this = TCons(_, result)
      }

      int getDenseIndex() { result = denseRank(getDivision(), getItem()) }

      ListEntry getPrev() { this = TCons(result, _) }

      ListEntry getNext() { result.getPrev() = this }
    }
  }
}
