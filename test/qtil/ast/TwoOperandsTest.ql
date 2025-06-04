import cpp as cpp
import qtil.testing.Qnit

signature class BinaryOperationSig extends cpp::BinaryOperation;

module TwoOperands<BinaryOperationSig BinOp> {
  private import qtil.ast.TwoOperands as Make
  import Make::TwoOperands<cpp::Expr, BinOp>
}

class FiveMatchesClassApiTest extends Test, Case {
  override predicate run(Qnit test) {
    if
      count(TwoOperands<cpp::AddExpr>::Set set |
        set.someOperand().isConstant() and
        set.otherOperand().getType() instanceof cpp::IntType
      ) = 5
    then test.pass("Correct number of matches with class API")
    else test.fail("Incorrect number of matches with class API")
  }
}

class FiveMatchesPredicateApiTest extends Test, Case {
  override predicate run(Qnit test) {
    if
      count(cpp::AddExpr op, cpp::Expr one, cpp::Expr another |
        TwoOperands<cpp::AddExpr>::set(op, one, another) and
        one.isConstant() and
        another.getType() instanceof cpp::IntType
      ) = 5
    then test.pass("Correct number of matches with predicate API")
    else test.fail("Incorrect number of matches with predicate API")
  }
}

class TestOperandAllOperandsAreChildrenPredicateAPI extends Test, Case {
  override predicate run(Qnit test) {
    if
      forall(cpp::AddExpr op, cpp::Expr one, cpp::Expr another |
        TwoOperands<cpp::AddExpr>::set(op, one, another)
      |
        one = op.getAnOperand() and another = op.getAnOperand()
      )
    then test.pass("All operands are children in predicate API")
    else test.fail("Not all operands are children in predicate API")
  }
}

class TestOperandAllOperandsAreChildrenClassAPI extends Test, Case {
  override predicate run(Qnit test) {
    if
      forall(TwoOperands<cpp::AddExpr>::Set set | any() |
        set.someOperand() = set.getOperation().getAnOperand() and
        set.otherOperand() = set.getOperation().getAnOperand()
      )
    then test.pass("All operands are children in class API")
    else test.fail("Not all operands are children in class API")
  }
}

class TestNoMissingOperands extends Test, Case {
  override predicate run(Qnit test) {
    if
      forall(cpp::AddExpr op, cpp::Expr one, cpp::Expr another |
        op.getAnOperand() = one and op.getAnOperand() = another and not one = another
      |
        TwoOperands<cpp::AddExpr>::set(op, one, another) and
        exists(TwoOperands<cpp::AddExpr>::Set set |
          set.someOperand() = op.getAnOperand() and
          set.otherOperand() = op.getAnOperand()
        )
      )
    then test.pass("No missing operands")
    else test.fail("Missing operands")
  }
}

class TestNoOperandsOverlapPredicateAPI extends Test, Case {
  override predicate run(Qnit test) {
    if
      forall(cpp::AddExpr op, cpp::Expr one, cpp::Expr another |
        TwoOperands<cpp::AddExpr>::set(op, one, another)
      |
        not one = another
      )
    then test.pass("No operands overlap in predicate API")
    else test.fail("Operands overlap in predicate API")
  }
}

class TestNoOperandsOverlapClassAPI extends Test, Case {
  override predicate run(Qnit test) {
    if
      forall(TwoOperands<cpp::AddExpr>::Set set | any() |
        not set.someOperand() = set.otherOperand()
      )
    then test.pass("No operands overlap in class API")
    else test.fail("Operands overlap in class API")
  }
}
