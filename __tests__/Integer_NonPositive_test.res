open Jest
open Expect
open ConstrainedType

let cases = list{(0, true), (-1, true), (1, false), (2147483647, false), (-2147483648, true)}

testAll("Integer.Value.nonPositive", cases, args => {
  let (num, expected) = args
  let isAllowed = switch Integer.Value.nonPositive(num) {
  | Some(_) => true
  | None => false
  }
  expect(isAllowed)->toBe(expected)
})

testAll("Integer.Value.nonPositiveExn", cases, args => {
  let (num, expected) = args
  let isAllowed = switch Integer.Value.nonPositiveExn(num) {
  | _ => true
  | exception Value.ConstraintUnsatisfied => false
  }
  expect(isAllowed)->toBe(expected)
})

testAll("Integer.Value.nonPositiveUnsafe", cases, args => {
  let (num, _expected) = args
  Integer.Value.nonPositiveUnsafe(num)->ignore
  pass
})
