open Jest
open Expect
open ConstrainedType

let cases = list{(0, false), (-1, false), (1, true), (2147483647, true), (-2147483648, false)}

testAll("Integer.Value.positive", cases, args => {
  let (num, expected) = args
  let isAllowed = switch Integer.Value.positive(num) {
  | Some(_) => true
  | None => false
  }
  expect(isAllowed)->toBe(expected)
})

testAll("Integer.Value.positiveExn", cases, args => {
  let (num, expected) = args
  let isAllowed = switch Integer.Value.positiveExn(num) {
  | _ => true
  | exception Value.ConstraintUnsatisfied => false
  }
  expect(isAllowed)->toBe(expected)
})

testAll("Integer.Value.positiveUnsafe", cases, args => {
  let (num, _expected) = args
  Integer.Value.positiveUnsafe(num)->ignore
  pass
})
