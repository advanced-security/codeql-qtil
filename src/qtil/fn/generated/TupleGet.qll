/**
 * GENERATE CODE. DO NOT MODIFY.
 */

import qtil.parameterization.SignatureTypes

module Tuple1Get<InfiniteStringableType A> {
  bindingset[a]
  A getFirst(A a) { result = a }
}

module Tuple2Get<InfiniteStringableType A, InfiniteStringableType B> {
  bindingset[a, b]
  A getFirst(A a, B b) { result = a }

  bindingset[a, b]
  B getSecond(A a, B b) { result = b }
}

module Tuple3Get<InfiniteStringableType A, InfiniteStringableType B, InfiniteStringableType C> {
  bindingset[a, b, c]
  A getFirst(A a, B b, C c) { result = a }

  bindingset[a, b, c]
  B getSecond(A a, B b, C c) { result = b }

  bindingset[a, b, c]
  C getThird(A a, B b, C c) { result = c }
}

module Tuple4Get<
  InfiniteStringableType A, InfiniteStringableType B, InfiniteStringableType C,
  InfiniteStringableType D>
{
  bindingset[a, b, c, d]
  A getFirst(A a, B b, C c, D d) { result = a }

  bindingset[a, b, c, d]
  B getSecond(A a, B b, C c, D d) { result = b }

  bindingset[a, b, c, d]
  C getThird(A a, B b, C c, D d) { result = c }

  bindingset[a, b, c, d]
  D getFourth(A a, B b, C c, D d) { result = d }
}

module Tuple5Get<
  InfiniteStringableType A, InfiniteStringableType B, InfiniteStringableType C,
  InfiniteStringableType D, InfiniteStringableType E>
{
  bindingset[a, b, c, d, e]
  A getFirst(A a, B b, C c, D d, E e) { result = a }

  bindingset[a, b, c, d, e]
  B getSecond(A a, B b, C c, D d, E e) { result = b }

  bindingset[a, b, c, d, e]
  C getThird(A a, B b, C c, D d, E e) { result = c }

  bindingset[a, b, c, d, e]
  D getFourth(A a, B b, C c, D d, E e) { result = d }

  bindingset[a, b, c, d, e]
  E getFifth(A a, B b, C c, D d, E e) { result = e }
}

module Tuple6Get<
  InfiniteStringableType A, InfiniteStringableType B, InfiniteStringableType C,
  InfiniteStringableType D, InfiniteStringableType E, InfiniteStringableType F>
{
  bindingset[a, b, c, d, e, f]
  A getFirst(A a, B b, C c, D d, E e, F f) { result = a }

  bindingset[a, b, c, d, e, f]
  B getSecond(A a, B b, C c, D d, E e, F f) { result = b }

  bindingset[a, b, c, d, e, f]
  C getThird(A a, B b, C c, D d, E e, F f) { result = c }

  bindingset[a, b, c, d, e, f]
  D getFourth(A a, B b, C c, D d, E e, F f) { result = d }

  bindingset[a, b, c, d, e, f]
  E getFifth(A a, B b, C c, D d, E e, F f) { result = e }

  bindingset[a, b, c, d, e, f]
  F getSixth(A a, B b, C c, D d, E e, F f) { result = f }
}
