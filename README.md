# Constrained type

A library for constraining types with an interface is similar to [Belt.Id](https://rescript-lang.org/docs/manual/latest/api/belt/id).

[![npm](https://img.shields.io/npm/v/@awebyte/constrained-type.svg)](https://npmjs.org/@awebyte/constrained-type)
[![CI](https://github.com/LoganGrier/constrained-type/actions/workflows/test.yml/badge.svg)](https://github.com/LoganGrier/constrained-type/actions/workflows/test.yml)
[![Issues](https://img.shields.io/github/issues/LoganGrier/constrained-type.svg)](https://github.com/LoganGrier/constrained-type/issues)
[![Last Commit](https://img.shields.io/github/last-commit/LoganGrier/constrained-type.svg)](https://github.com/LoganGrier/constrained-type/commits/master)

## Usage

```rescript
open ConstrainedType

// Creating constraints
module EvenInteger = Constraint.MakeU({
  type t = int
  let isSatisfied = (. value) => mod(value, 2) == 0
})

// Creating a constraint that is always satisfied (useful when for creating Maps where only the key or only the value is constrained)
module AllInteger = Constraint.All.Make({
  type t = int
})

// Creating values //
// Set a to Some(2)
let a = Value.make(2, ~constraint_=module(EvenInteger))
// Set b to None
let b = Value.make(1, ~constraint_=module(EvenInteger)) 
// Set c to 2
let c = Value.makeExn(2, ~constraint_=module(EvenInteger))
// Raise a ConstraintUnsatisfied exception
let d = Value.makeExn(1, ~constraint_=module(EvenInteger)) 
// Set e to 2
let e = Value.makeUnsafe(2, ~constraint_=module(EvenInteger)) 
// Set f to 1. Unlike make and makeExn, makeUnsafe does not verify that it's constraint is satisfied
let f = Value.makeUnsafe(1, ~constraint_=module(EvenInteger)) 
// Set g to 1. Value.All has no makeExn or makeUnsafe functions since Value.All.make always succeeds
let g = Value.All.make(1)

// Creating sets //
// Creating sets uses no additional space
// make and makeExn take linear time. makeUnsafe takes constant time
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
// Set constrainedSetError3 to {2, 4, 6, 8, 9}. Unlike make and makeExn, makeUnsafe does not verify that it's constraint is satisfied)
let constrainedSetError3 = Set.makeUnsafe(unconstrainedSetError, ~constraint_=module(EvenInteger)) 

// Creating maps  //
// Creating sets uses no additional space
// make and makeExn take linear time. makeUnsafe takes constant time
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

## Constrained set and saps are type-safe

```rescript
let unconstrainedEvenSet = Belt.Set.fromArray([2, 4, 6, 8], ~id=module(MyComparableModule))
let evenSet = Set.make(unconstrainedEvenSet, ~constraint_=module(EvenInteger))
let unconstrainedOddSet = Belt.Set.fromArray([1, 3, 5], ~id=module(MyComparableModule))
let oddSet = Set.make(unconstrainedOddSet, ~constraint_=module(OddInteger))
let union = evenSet->Belt.Set.union(oddSet) // Emits compile-time error
```

### Multiple instances of Constraint.All are Compatible

```rescript
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

## Macros

*ConstrainedType.Inequality* builds inequality constraints and helper functions from a comparable. See [ConstrainedType_Inequality.resi](src/ConstrainedType_Inequality.resi) for documentation.

## Built-in constraints

*ConstrainedType.Integer*. The module interface satisfies *ConstrainedType.Inequality.Module*.
*ConstrainedType.Array*. Offers a generic NonEmpty constraint, and utilities to create ConstraintType.Value.t objects satisfying NonEmpty.

## Constraints on generic types

The syntax for creating constraints on generic types is verbose and unintuitive. See [ConstrainedType_Array.res](src/ConstrainedType_Array.res) for an example.

## JavaScript interop

ConstraintType.Value.t<'value, 'id> is implemented as 'value. While this is an implementation detail as far as the Rescript compiler is concerned, it is part of the contract of this module, and as such, it is safe to assume in your code. This is useful in JavaScript bindings when you want to constraint the parameters of an external JavaScript function.

For example, suppose you have an external function "foo" that takes a single number parameter. You could interop with this function in Rescript as follows:

```rescript
module MyConstraint = Constraint.Make({
  type t = int
  let isSatisfied = ...
})
type fooResult = ...
external foo: t<int, MyConstraint.identity> => fooResult = "foo"
```

## Mutable underlying types are unsafe

If the 'value type of of a ConstraintType.Value.t<'value, 'id> object is mutable, then instances of ConstraintType.Value.t<'value, 'id> may not actually satisfy the constraint specified by 'id. This could be true even if all instances of ConstraintType.Value.t<'value, 'id> are created with make or makeExn.
