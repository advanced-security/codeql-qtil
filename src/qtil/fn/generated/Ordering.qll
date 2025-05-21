/**
 * GENERATE CODE. DO NOT MODIFY.
 */

import qtil.parameterization.SignatureTypes

module Ordering1<InfiniteStringableType A> {
  signature module Sig {
    int getRank(A a);
  }

  signature module StrSig {
    string getRank(A a);
  }

  module ByStr<StrSig Config> implements Sig {
    int getRank(A a) {
      Config::getRank(a) = rank[result](string str, A a0 | str = Config::getRank(a0) | str)
    }
  }
}

module Ordering2<InfiniteStringableType A, InfiniteStringableType B> {
  signature module Sig {
    int getRank(A a, B b);
  }

  signature module StrSig {
    string getRank(A a, B b);
  }

  module ByStr<StrSig Config> implements Sig {
    int getRank(A a, B b) {
      Config::getRank(a, b) =
        rank[result](string str, A a0, B b0 | str = Config::getRank(a0, b0) | str)
    }
  }
}

module Ordering3<InfiniteStringableType A, InfiniteStringableType B, InfiniteStringableType C> {
  signature module Sig {
    int getRank(A a, B b, C c);
  }

  signature module StrSig {
    string getRank(A a, B b, C c);
  }

  module ByStr<StrSig Config> implements Sig {
    int getRank(A a, B b, C c) {
      Config::getRank(a, b, c) =
        rank[result](string str, A a0, B b0, C c0 | str = Config::getRank(a0, b0, c0) | str)
    }
  }
}

module Ordering4<
  InfiniteStringableType A, InfiniteStringableType B, InfiniteStringableType C,
  InfiniteStringableType D>
{
  signature module Sig {
    int getRank(A a, B b, C c, D d);
  }

  signature module StrSig {
    string getRank(A a, B b, C c, D d);
  }

  module ByStr<StrSig Config> implements Sig {
    int getRank(A a, B b, C c, D d) {
      Config::getRank(a, b, c, d) =
        rank[result](string str, A a0, B b0, C c0, D d0 |
          str = Config::getRank(a0, b0, c0, d0)
        |
          str
        )
    }
  }
}

module Ordering5<
  InfiniteStringableType A, InfiniteStringableType B, InfiniteStringableType C,
  InfiniteStringableType D, InfiniteStringableType E>
{
  signature module Sig {
    int getRank(A a, B b, C c, D d, E e);
  }

  signature module StrSig {
    string getRank(A a, B b, C c, D d, E e);
  }

  module ByStr<StrSig Config> implements Sig {
    int getRank(A a, B b, C c, D d, E e) {
      Config::getRank(a, b, c, d, e) =
        rank[result](string str, A a0, B b0, C c0, D d0, E e0 |
          str = Config::getRank(a0, b0, c0, d0, e0)
        |
          str
        )
    }
  }
}

module Ordering6<
  InfiniteStringableType A, InfiniteStringableType B, InfiniteStringableType C,
  InfiniteStringableType D, InfiniteStringableType E, InfiniteStringableType F>
{
  signature module Sig {
    int getRank(A a, B b, C c, D d, E e, F f);
  }

  signature module StrSig {
    string getRank(A a, B b, C c, D d, E e, F f);
  }

  module ByStr<StrSig Config> implements Sig {
    int getRank(A a, B b, C c, D d, E e, F f) {
      Config::getRank(a, b, c, d, e, f) =
        rank[result](string str, A a0, B b0, C c0, D d0, E e0, F f0 |
          str = Config::getRank(a0, b0, c0, d0, e0, f0)
        |
          str
        )
    }
  }
}
