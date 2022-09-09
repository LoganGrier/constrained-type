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
