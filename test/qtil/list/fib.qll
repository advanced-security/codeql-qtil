int fib(int n) {
  n = 0 and
  result = 0
  or
  n = 1 and
  result = 1
  or
  n = [0 .. 10] and
  result = fib(n - 1) + fib(n - 2)
}

// The fibonacci numbers greater than 1.
// We start at 2 to avoid the fact that fib(0) and fib(1) are both 1.
class Fib extends int {
  Fib() { this = fib(_) and this > 1 }

  string toString() { result = "fib" }
}

int identity(Fib x) { result = x }

newtype TEvenOrOdd =
  TEven() or
  TOdd()

TEvenOrOdd evenOrOdd(Fib i) {
  i % 2 = 0 and result = TEven()
  or
  i % 2 = 1 and result = TOdd()
}
