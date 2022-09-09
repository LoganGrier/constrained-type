open Jest
open Expect
open ConstrainedType

let cases = list{(0, true), (-1, false), (1, true), (2147483647, true), (-2147483648, false)}

testAll("Integer.Value.nonNegative", cases, args => {
  let (num, expected) = args
  let isAllowed = switch Integer.Value.nonNegative(num) {
  | Some(_) => true
  | None => false
  }
  expect(isAllowed)->toBe(expected)
})

testAll("Integer.Value.nonNegativeExn", cases, args => {
  let (num, expected) = args
  let isAllowed = switch Integer.Value.nonNegativeExn(num) {
  | _ => true
  | exception Value.ConstraintUnsatisfied => false
  }
  expect(isAllowed)->toBe(expected)
})

testAll("Integer.Value.nonNegativeUnsafe", cases, args => {
  let (num, _expected) = args
  Integer.Value.nonNegativeUnsafe(num)->ignore
  pass
})
