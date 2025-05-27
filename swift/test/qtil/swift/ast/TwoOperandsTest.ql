import swift
import qtil.swift.ast.TwoOperands

from BinaryExpr op, TwoOperands<BinaryExpr>::Set ops
where
  ops.someOperand().(DeclRefExpr).getDecl().(VarDecl).getName() = "a" and
  ops.otherOperand().(DeclRefExpr).getDecl().(VarDecl).getName() = "b" and
  ops.getOperation() = op
select op, ops.someOperand(), ops.otherOperand()
