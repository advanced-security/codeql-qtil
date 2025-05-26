/**
 * A module to declare any finite type as a signature type, without a separate declaration.
 * 
 * With this module, rather than writing `signature class ExprSig extends Expr;`, you can simply
 * declare a module `module MyModule<Signature<Expr>::Type T> { ... }` to declare a parameterized
 * module that takes a type that extends `Expr` as a parameter.
 * 
 * To create an infinite signature type, use `InfSignature` instead.
 */
module Signature<FiniteType T> {
  signature class Type extends T;
}

/**
 * A module to declare any infinite type as a signature type, without a separate declaration.
 * 
 * With this module, rather than writing `signature class MyInt extends int;` with a `bindingset`,
 * you can simply declare a module `module MyModule<InfSignature<MyInt>::Type T> { ... }` to declare
 * a * parameterized module that takes a type that extends `int` as a parameter.
 * 
 * To create a finite signature type, use `Signature` instead.
 */
module InfSignature<InfiniteType T> {
  bindingset[this]
  signature class Type extends T;
}

/**
 * A common signature type that can be used to represent any finite type, including `newtype`s.
 * 
 * Cannot be used to represent infinite types, such as `int` or `string`, but can be used to
 * represent finite types such as any normal class or algebraic `newtype`. To support infinite
 * types in your module, use `InfiniteType` instead.
 * 
 * Note that `newtype`s do not have the member predicate `toString()`. If you need `toString()` in
 * your parameterization, you should use `FiniteStringableType` instead, and your module will no
 * longer support `newtype`s.
 */
signature class FiniteType;

/**
 * A common signature type that can be used to represent any finite type, excluding `newtype`s, in
 * order to provide a `toString()` method.
 * 
 * Cannot be used to represent infinite types, such as `int` or `string`, and cannot represent
 * `newtype`s since those do not have a `toString()` member predicate, but can be used to represent
 * finite classes such as most normal classes. To support infinite types in your module, use
 * `InfiniteType` instead, and to support `newtype`s, use `FiniteType`.
 * 
 * If you do not need `toString()` in your parameterization, you should prefer to use `FiniteType`
 * over this class, so that your module will support `newtype`s as well as normal classes.
 */
signature class FiniteStringableType {
  string toString();
}

/**
 * A common signature type that can be used to represent any possibly infinite type, including
 * `int` and `string`, as well as any normal class or algebraic `newtype`.
 * 
 * Generally, using this type and supporting infinite types will constrain options in your module
 * design. For this reason, it is often preferable to use one of the finite types `FiniteType` or
 * `FiniteStringableType` instead, unless you specifically need to support infinite types in your
 * module.
 * 
 * Note that `newtype`s do not have the member predicate `toString()`. If you need `toString()` in
 * your parameterization, you should use `InfiniteStringableType` instead, and your module will no
 * longer support `newtype`s.
 */
bindingset[this]
signature class InfiniteType;

/**
 * A common signature type that can be used to represent any possibly infinite type, such as `int`
 * and `string` and normal classes, but excludes `newtype`s, in order to provide a `toString()`
 * method.
 * 
 * Generally, using this type and supporting infinite types will constrain options in your module
 * design. For this reason, it is often preferable to use one of the finite types `FiniteType` or
 * `FiniteStringableType` instead, unless you specifically need to support infinite types in your
 * module.
 * 
 * If you do not need `toString()` in your parameterization, you should prefer to use `InfiniteType`
 * over this class, so that your module will support `newtype`s as well as normal classes.
 */
bindingset[this]
signature class InfiniteStringableType {
  bindingset[this]
  string toString();
}

/**
 * A common signature type that can be used to represent any string type, including `string` and
 * classes that are instances of `string` via `instanceof` inheritance.
 * 
 * This type is useful for creating modules that assemble strings and cast them to a string-like
 * type, such as those that extend `UnderlyingString`.
 */
bindingset[this]
signature class StringlikeType instanceof string;