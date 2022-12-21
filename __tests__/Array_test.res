open ConstrainedType.Array
open Jest
open Expect

let cases = list{([], false), ([1], true), ([1, 2, 3], true)}

testAll("NonEmpty.Value.make", cases, args => {
  let (num, expected) = args
  let isAllowed = switch NonEmpty.Value.make(num) {
  | Some(_) => true
  | None => false
  }
  expect(isAllowed)->toBe(expected)
})

testAll("NonEmpty.Value.makeExn", cases, args => {
  let (num, expected) = args
  let isAllowed = switch NonEmpty.Value.makeExn(num) {
  | _ => true
  | exception ConstrainedType.Value.ConstraintUnsatisfied => false
  }
  expect(isAllowed)->toBe(expected)
})

testAll("NonEmpty.Value.makeUnsafe", cases, args => {
  let (num, _expected) = args
  NonEmpty.Value.makeUnsafe(num)->ignore
  pass
})

describe("NonEmpty.Constraint.Make", () => {
  testAll("Value.make with resulting module works as expected", cases, ((nums, expected)) => {
    module IntNonEmptyConstraint = NonEmpty.Constraint.Make({
      type a1 = int
    })
    let isAllowed = switch ConstrainedType.Value.make(
      nums,
      ~constraint_=module(IntNonEmptyConstraint),
    ) {
    | Some(_) => true
    | None => false
    }
    expect(isAllowed)->toBe(expected)
  })
})
