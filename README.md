# Constrained type

A library for constraining types.

Each constraint created with the library is signed with a type parameter so that different constraints have different types.

This library has special functions for constraining the elements of existing [sets and maps](#2-sets-and-maps), creating [inequality constraints](#4-inequality-constraints) from `Belt.Id.Comparable`s, and [constraining generic types](#5-generic-constraints).

It's also safe to use in [JavaScript bindings](#6-javascript-interop).

[![npm](https://img.shields.io/npm/v/@awebyte/constrained-type.svg)](https://npmjs.org/@awebyte/constrained-type)
[![CI](https://github.com/LoganGrier/constrained-type/actions/workflows/test.yml/badge.svg)](https://github.com/LoganGrier/constrained-type/actions/workflows/test.yml)
[![Issues](https://img.shields.io/github/issues/LoganGrier/constrained-type.svg)](https://github.com/LoganGrier/constrained-type/issues)
[![Last Commit](https://img.shields.io/github/last-commit/LoganGrier/constrained-type.svg)](https://github.com/LoganGrier/constrained-type/commits/master)

## 1 Constraints and Values

`Constraint.t<'value, 'id>` and `Value.t<'value, 'id>` are the two basic types in this library.

### 1.1 Constraints

A `Constraint.t<'value, 'id>` is a function signed by `'id` that constrains `'value`.

Any module satisfying `Constraint.Type` can be turned into a `Constraint.t` with the built-in `module` function. Typically users create these modules using `Constraint.Make` or `Constraint.MakeU`.

### 1.2 Values

A `Value.t<'value, 'id>` is a record/object of type 'value that satisfies `Constraint.t<'value, 'id>`.

There are three functions for creating values. These functions are differentiated by their behavior when their value argument doesn't satisfy their constraint:

* `make: ('value, ~constraint_: Constraint.t<'value, 'id>) => option<t<'value, 'id>>` returns `None` if `value` doesn't satisfy `~constraint_`
* `makeExn: ('value, ~constraint_: Constraint.t<'value, 'id>) => t<'value, 'id>` raises a `ConstraintUnsatisfied` exception if `value` doesn't satisfy `~constraint_`
* `makeUnsafe: ('value, ~constraint_: Constraint.t<'value, 'id>) => t<'value, 'id>` returns `value` **regardless of whether it satisfies `~constraint_`**.

While makeUnsafe takes `~constraint_` as a parameter, it does not call the underlying constraint function. This gives it a potential performance advantage over the other two functions at the cost of not detecting non-conforming arguments. `makeUnsafe` is unsafe because it allows the creation of constrained values that don't actually satisfy their constraint. You should only call makeUnsafe if you are certain the constraint is satisfied. Even then, be wary of premature optimization.

None of these functions copy their input. Thus, their result is reference-wise equal to their value parameter.

The underlying value can be retrieved using the `Value.value: (Value.t<'value, 'id>) => 'value` function

### 1.3 Examples

```rescript
open ConstrainedType
// Creating a constraint //
module EvenInteger = Constraint.MakeU({
  type t = int
  let isSatisfied = (. value) => mod(value, 2) == 0
})

// Creating values //
// Set a to Some(2)
let a: option<Value.t<int, EvenInteger.identity>> = Value.make(2, ~constraint_=module(EvenInteger))
// Set b to None
let b: option<Value.t<int, EvenInteger.identity>> = Value.make(1, ~constraint_=module(EvenInteger)) 
// Set c to 2
let c: Value.t<int, EvenInteger.identity> = Value.makeExn(2, ~constraint_=module(EvenInteger))
// Raise a ConstraintUnsatisfied exception
let d: Value.t<int, EvenInteger.identity> = Value.makeExn(1, ~constraint_=module(EvenInteger)) 
// Set e to 2
let e: Value.t<int, EvenInteger.identity> = Value.makeUnsafe(2, ~constraint_=module(EvenInteger)) 
// Set f to 1
let f: Value.t<int, EvenInteger.identity> = Value.makeUnsafe(1, ~constraint_=module(EvenInteger)) 

// Unwrapping constrained values //
// Sets x to 2
let x: int = c->Value.value 
```

## 2 Sets and Maps

This library provides several utility functions for constraining immutable Sets and Maps in the `Set` and `Map` modules.

`Map` offers functions to constrain both the key and the value, just the key (inside `Map.KeyOnly`), and just the value (inside `Map.ValueOnly`).

Similar to `Value`, there are three functions in each of `Set`, `Map`, `Map.KeyOnly` and `Map.ValueOnly`: `make`, `makeExn`, and `makeUnsafe`.

Like their corresponding functions in 'Value', these functions are differentiated by their behavior when their value argument doesn't satisfy their constraint:

* `make` returns `Error([Module].InvalidEntries(Belt.[Module].t<...>))` where '[Module]' is either 'Set' or 'Map'.
* `makeExn` raise `[Module].InvalidEntriesException` where '[Module]' is either 'Set' or 'Map'.
* `makeUnsafe` raise `[Module].InvalidEntriesException` returns `value` **regardless of whether its elements satisfy the constraint(s)**.

Like their corresponding functions in `Value`, none of these functions copy their inputs.

**Unlike** their corresponding functions in `Value`, these functions create collections of constrained values. For example, `Map.makeExn` has this signature:

```rescript
let makeExn: (
  Belt.Map.t<'key, 'value, 'cmpId>,
  ~keyConstraint: Constraint.t<'key, 'keyCntId>,
  ~valueConstraint: Constraint.t<'value, 'valueCntId>,
) => Belt.Map.t<
  Value.t<'key, 'keyCntId>,
  Value.t<'value, 'valueCntId>,
  'cmpId,
>
```

### 2.1 Time Complexity

`make` and `makeExn` iterate over all elements in the given collection, so, assuming that evaluating a constraint takes constant time, they have θ(nlog(n)) time complexity. `makeUnsafe` has θ(1) time complexity.

### 2.2 Examples

```rescript
// Creating sets //
let unconstrainedSetOk = Belt.Set.fromArray([2, 4, 6, 8], ~id=module(MyComparableModule))
let unconstrainedSetError = Belt.Set.fromArray([2, 4, 6, 8, 9], ~id=module(MyComparableModule))
// Set constrainedSetOk to Ok({2, 4, 6, 8})
let constrainedSetOk = Set.make(unconstrainedSetOk, ~constraint_=module(EvenInteger)) 
// Set constrainedSetError to Error(InvalidEntries({9}))
let constrainedSetError = Set.make(unconstrainedSetError, ~constraint_=module(EvenInteger)) 
// Set constrainedSetOk2 to {2, 4, 6, 8}
let constrainedSetOk2 = Set.makeExn(unconstrainedSetOk, ~constraint_=module(EvenInteger)) 
// Raise Set.InvalidEntriesException
let constrainedSetError2 = Set.makeExn(unconstrainedSetError, ~constraint_=module(EvenInteger)) 
// Set constrainedSetOk3 to {2, 4, 6, 8}
let constrainedSetOk3 = Set.makeUnsafe(unconstrainedSetOk, ~constraint_=module(EvenInteger)) 
// Set constrainedSetError3 to {2, 4, 6, 8, 9}
let constrainedSetError3 = Set.makeUnsafe(unconstrainedSetError, ~constraint_=module(EvenInteger)) 

// Creating maps  //
let unconstrainedMapOk = Belt.Map.fromArray([(2, 1), (4, 3), (6, 5)], ~id=module(MyComparableModule))
let unconstrainedMapError = Map.Set.fromArray([(2, 2), (4, 3), (6, 5)],, ~id=module(MyComparableModule))
// Set constrainedMapOk to Ok({(2, 1), (4, 3), (6, 5)})
let constrainedMapOk = Map.make(unconstrainedMapOk, ~keyConstraint=module(EvenInteger), ~valueConstraint=module(OddInteger))
// Set constrainedMapError to Error(InvalidEntries({(4, 3), (6, 5)}))
let constrainedMapError = Map.make(unconstrainedMapError, ~keyConstraint=module(EvenInteger), ~valueConstraint=module(EvenInteger)) 
// Set constrainedMapOk2 to {(2, 1), (4, 3), (6, 5)}
let constrainedMapOk2 = Map.makeExn(unconstrainedMapOk, ~keyConstraint=module(EvenInteger), ~valueConstraint=module(OddInteger))
// Raise Map.InvalidEntriesException
let constrainedMapError2 = Map.makeExn(unconstrainedMapError, ~keyConstraint=module(EvenInteger), ~valueConstraint=module(EvenInteger)) 
// Set constrainedMapOk3 to {(2, 1), (4, 3), (6, 5)}
let constrainedMapOk3 = Map.make(unconstrainedMapOk, ~keyConstraint=module(EvenInteger), ~valueConstraint=module(OddInteger))
// Set constrainedMapError3 to {(2, 2), (4, 3), (6, 5)}
let constrainedMapError3 = Map.make(unconstrainedMapError, ~keyConstraint=module(EvenInteger), ~valueConstraint=module(EvenInteger)) 
```

### 2.3 NonEmpty

Both `Set` and `Map` each have a `NonEmpty` constraint created using [`Generic`](#5-generic-constraints).

## 3 'All' Constraint

The 'All' constraint is a constraint that is always satisfied.

This can be useful when creating Maps where only the key or only the value is constrained. Consider using Map.KeyOnly or Map.ValueOnly instead.

Since making a constrained value satisfying the `All` constraint always succeeds, `All` has no `makeExn` or `makeUnsafe` function, and `make` returns its input value instead of wrapping it in an option.

Multiple instances of Constraint.All.t<'element> are compatible.

### 3.1 Example

```rescript
module AllInteger = Constraint.All.Make({
  type t = int
})

// Set a to 1
let a: Value.t<int, Constraint.All.identity> = Value.All.make(1)

// Multiple instances of Constraint.All are compatible
module AllInteger1 = Constraint.All.Make({
  type t = int
})
module AllInteger2 = Constraint.All.Make({
  type t = int
})

let unconstrainedSet1 = Belt.Set.fromArray([2, 4, 6, 8], ~id=module(MyComparableModule))
let set1 = Set.make(unconstrainedSet1, ~constraint_=module(AllInteger1))
let unconstrainedSet2 = Belt.Set.fromArray([1, 3, 5], ~id=module(MyComparableModule))
let set2 = Set.make(unconstrainedSet2, ~constraint_=module(AllInteger2))
let union = set1->Belt.Set.union(set2) // Set union to {1, 2, 3, 4, 5, 6, 8}
```

## 4 Inequality Constraints

The `Inequality` module allows users to create inequality constraints from a comparable. See [ConstrainedType_Inequality.resi](src/ConstrainedType_Inequality.resi) for documentation.

### 4.1 Integers

The `Integer` module defines integer inequality constraints using `Inequality`.

## 5 Generic Constraints

The `Generic` module allows users to create generic constraints.

At present, only generics with one, two or three type parameters are supported, though it would be easy to add support for additional type parameters by copying and tweaking existing code. PRs are welcome.

### 5.1 Arrays

The `Array` module defines an array `NonEmpty` constraint using `Generic`.

## 6 JavaScript interop

Value.t<'value, 'id> is implemented as 'value. While this is an implementation detail as far as the Rescript compiler is concerned, it is part of the contract of this module, and as such, it is safe to assume in your code. This is useful in JavaScript bindings when you want to constrain the parameters of an external JavaScript function.

For example, suppose you have an external function "foo" that takes a single number parameter. You could interop with this function in Rescript as follows:

```rescript
module MyConstraint = Constraint.Make({
  type t = int
  let isSatisfied = ...
})
type fooResult = ...
external foo: t<int, MyConstraint.identity> => fooResult = "foo"
```

## 7 Mutable underlying types are unsafe

If the 'value type of of a Value.t<'value, 'id> object is mutable, then instances of Value.t<'value, 'id> may not actually satisfy the constraint specified by 'id. This could be true even if all instances of Value.t<'value, 'id> are created with make or makeExn. This is because creating a Value.t doesn't copy the input value. If the input value is mutated so that the constraint is no longer satisfied, the Value.t's invariant will be violated. As such, you should only use mutable underlying types when you can guarantee that instances of those types are never mutated after being used to create ConstrainedType values.

We offer Value.assertConstraint to help clients catch mutation bugs.
