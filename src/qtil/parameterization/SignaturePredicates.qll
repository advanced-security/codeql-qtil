private import qtil.parameterization.SignatureTypes

module Nullary {
  signature predicate pred();

  module Ret<InfiniteType R> {
    signature R pred();
  }
}

module Unary<InfiniteType T> {
  signature predicate pred(T t);

  module Ret<InfiniteType R> {
    signature R pred(T t);
  }
}

module Binary<InfiniteType T1, InfiniteType T2> {
  signature predicate pred(T1 t1, T2 t2);

  module Ret<InfiniteType R> {
    signature R pred(T1 t1, T2 t2);
  }
}

module Ternary<InfiniteType T1, InfiniteType T2, InfiniteType T3> {
  signature predicate pred(T1 t1, T2 t2, T3 t3);

  module Ret<InfiniteType R> {
    signature R pred(T1 t1, T2 t2, T3 t3);
  }
}

module Quaternary<InfiniteType T1, InfiniteType T2, InfiniteType T3, InfiniteType T4> {
  signature predicate pred(T1 t1, T2 t2, T3 t3, T4 t4);

  module Ret<InfiniteType R> {
    signature R pred(T1 t1, T2 t2, T3 t3, T4 t4);
  }
}

module Quinary<InfiniteType T1, InfiniteType T2, InfiniteType T3, InfiniteType T4, InfiniteType T5> {
  signature predicate pred(T1 t1, T2 t2, T3 t3, T4 t4, T5 t5);

  module Ret<InfiniteType R> {
    signature R pred(T1 t1, T2 t2, T3 t3, T4 t4, T5 t5);
  }
}
