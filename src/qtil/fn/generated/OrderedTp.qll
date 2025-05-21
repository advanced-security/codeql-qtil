/**
 * GENERATED CODE. DO NOT MODIFY.
 */

private import qtil.parameterization.SignatureTypes
private import qtil.fn.FnTypes
private import qtil.fn.Ordering

module OrdTp1<InfiniteStringableType A, TpType1<A>::tp/1 tp, Ordering1<A>::Sig Ord> {
  int maxRank() { result = max(Ord::getRank(_)) }

  private int minRank() { result = min(Ord::getRank(_)) }

  predicate maxTup(A a) { maxRank() = Ord::getRank(a) }

  predicate minTup(A a) { minRank() = Ord::getRank(a) }

  module Fold<InfiniteStringableType R, FnType2<R, R, A>::fn/2 agg, FnType0<R>::fn/0 init> {
    private R step(int rank_) {
      if rank_ = minRank() - 1
      then result = init()
      else
        exists(A a |
          rank_ = Ord::getRank(a) and
          result = agg(step(rank_ - 1), a)
        )
    }
  }
}

module OrdTp2<
  InfiniteStringableType A, InfiniteStringableType B, TpType2<A, B>::tp/2 tp,
  Ordering2<A, B>::Sig Ord>
{
  int maxRank() { result = max(Ord::getRank(_, _)) }

  private int minRank() { result = min(Ord::getRank(_, _)) }

  predicate maxTup(A a, B b) { maxRank() = Ord::getRank(a, b) }

  predicate minTup(A a, B b) { minRank() = Ord::getRank(a, b) }

  module Fold<InfiniteStringableType R, FnType3<R, R, A, B>::fn/3 agg, FnType0<R>::fn/0 init> {
    private R step(int rank_) {
      if rank_ = minRank() - 1
      then result = init()
      else
        exists(A a, B b |
          rank_ = Ord::getRank(a, b) and
          result = agg(step(rank_ - 1), a, b)
        )
    }
  }
}

module OrdTp3<
  InfiniteStringableType A, InfiniteStringableType B, InfiniteStringableType C,
  TpType3<A, B, C>::tp/3 tp, Ordering3<A, B, C>::Sig Ord>
{
  int maxRank() { result = max(Ord::getRank(_, _, _)) }

  private int minRank() { result = min(Ord::getRank(_, _, _)) }

  predicate maxTup(A a, B b, C c) { maxRank() = Ord::getRank(a, b, c) }

  predicate minTup(A a, B b, C c) { minRank() = Ord::getRank(a, b, c) }

  module Fold<InfiniteStringableType R, FnType4<R, R, A, B, C>::fn/4 agg, FnType0<R>::fn/0 init> {
    private R step(int rank_) {
      if rank_ = minRank() - 1
      then result = init()
      else
        exists(A a, B b, C c |
          rank_ = Ord::getRank(a, b, c) and
          result = agg(step(rank_ - 1), a, b, c)
        )
    }
  }
}

module OrdTp4<
  InfiniteStringableType A, InfiniteStringableType B, InfiniteStringableType C,
  InfiniteStringableType D, TpType4<A, B, C, D>::tp/4 tp, Ordering4<A, B, C, D>::Sig Ord>
{
  int maxRank() { result = max(Ord::getRank(_, _, _, _)) }

  private int minRank() { result = min(Ord::getRank(_, _, _, _)) }

  predicate maxTup(A a, B b, C c, D d) { maxRank() = Ord::getRank(a, b, c, d) }

  predicate minTup(A a, B b, C c, D d) { minRank() = Ord::getRank(a, b, c, d) }

  module Fold<InfiniteStringableType R, FnType5<R, R, A, B, C, D>::fn/5 agg, FnType0<R>::fn/0 init> {
    private R step(int rank_) {
      if rank_ = minRank() - 1
      then result = init()
      else
        exists(A a, B b, C c, D d |
          rank_ = Ord::getRank(a, b, c, d) and
          result = agg(step(rank_ - 1), a, b, c, d)
        )
    }
  }
}

module OrdTp5<
  InfiniteStringableType A, InfiniteStringableType B, InfiniteStringableType C,
  InfiniteStringableType D, InfiniteStringableType E, TpType5<A, B, C, D, E>::tp/5 tp,
  Ordering5<A, B, C, D, E>::Sig Ord>
{
  int maxRank() { result = max(Ord::getRank(_, _, _, _, _)) }

  private int minRank() { result = min(Ord::getRank(_, _, _, _, _)) }

  predicate maxTup(A a, B b, C c, D d, E e) { maxRank() = Ord::getRank(a, b, c, d, e) }

  predicate minTup(A a, B b, C c, D d, E e) { minRank() = Ord::getRank(a, b, c, d, e) }

  module Fold<
    InfiniteStringableType R, FnType6<R, R, A, B, C, D, E>::fn/6 agg, FnType0<R>::fn/0 init>
  {
    private R step(int rank_) {
      if rank_ = minRank() - 1
      then result = init()
      else
        exists(A a, B b, C c, D d, E e |
          rank_ = Ord::getRank(a, b, c, d, e) and
          result = agg(step(rank_ - 1), a, b, c, d, e)
        )
    }
  }
}

module OrdTp6<
  InfiniteStringableType A, InfiniteStringableType B, InfiniteStringableType C,
  InfiniteStringableType D, InfiniteStringableType E, InfiniteStringableType F,
  TpType6<A, B, C, D, E, F>::tp/6 tp, Ordering6<A, B, C, D, E, F>::Sig Ord>
{
  int maxRank() { result = max(Ord::getRank(_, _, _, _, _, _)) }

  private int minRank() { result = min(Ord::getRank(_, _, _, _, _, _)) }

  predicate maxTup(A a, B b, C c, D d, E e, F f) { maxRank() = Ord::getRank(a, b, c, d, e, f) }

  predicate minTup(A a, B b, C c, D d, E e, F f) { minRank() = Ord::getRank(a, b, c, d, e, f) }

  module Fold<
    InfiniteStringableType R, FnType7<R, R, A, B, C, D, E, F>::fn/7 agg, FnType0<R>::fn/0 init>
  {
    private R step(int rank_) {
      if rank_ = minRank() - 1
      then result = init()
      else
        exists(A a, B b, C c, D d, E e, F f |
          rank_ = Ord::getRank(a, b, c, d, e, f) and
          result = agg(step(rank_ - 1), a, b, c, d, e, f)
        )
    }
  }
}
