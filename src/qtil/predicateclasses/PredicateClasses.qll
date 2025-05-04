/**
 * A true abomination of a module.
 * 
 * .....anything cool we can do with this??
 */
private import qtil.parameterization.SignatureTypes
private import qtil.parameterization.SignaturePredicates
private import qtil.inheritance.Instance
private import qtil.tuple.StringTuple
private import qtil.strings.SeparatedList
private import codeql.util.Unit

module BinaryToClass<InfiniteStringableType A, InfiniteStringableType B, Binary<A, B>::pred/2 pred> {
  final class Type instanceof Unit {
    predicate holds(A t1, B t2) { pred(t1, t2) }

    bindingset[t1]
    Curryable curry(A t1) {
      result.curried(t1)
    }

    string toString() { result = "Binary predicate class" }
  }

  bindingset[this]
  private class Curryable extends InfInstance<A>::Type {
    bindingset[t1]
    predicate curried(A t1) {
        this = t1
    }

    predicate curry(B t2) {
    }

    predicate holds(B t) {
        pred(this, t)
    }
  }
}

module UnaryToClass<InfiniteStringableType T, Unary<T>::pred/1 pred> {
  final class Type instanceof Unit {
    predicate holds(T t) { pred(t) }

    bindingset[t]
    Curryable curry(T t) {
      result.curried(t)
    }

    string toString() { result = "Unary predicate class" }
  }

  bindingset[this]
  private class Curryable extends InfInstance<T>::Type {
    bindingset[t]
    predicate curried(T t) {
        this = t
    }

    predicate holds() {
        pred(this)
    }
  }
}

module UnaryClassSig<InfiniteType T> {
  signature class Type {
    predicate holds(T t);
  }
}

module NullaryClassSig {
    signature class Type {
        predicate holds();
    }
}

signature class UnaryIntSig {
    predicate holds(int t);
}

module ClassToUnary<InfiniteType T, UnaryClassSig<T>::Type UnaryClass> {
  predicate pred(T t) { any(UnaryClass u).holds(t) }
}

module ClassToNullary<NullaryClassSig::Type NullaryClass> {
  predicate pred() { any(NullaryClass u).holds() }
}

predicate isEven(int i) { i % 2 = 0 and i in [0..10] }

class IsEvenClass = UnaryToClass<int, isEven/1>::Type;
predicate test() {
    exists(IsEvenClass unary |
        ClassToUnary<int, IsEvenClass>::pred(1) and
        unary.curry(2).holds()
    )
}