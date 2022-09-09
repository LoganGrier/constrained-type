open Jest
open Expect
open FastCheck
open ConstrainedType

let cases = list{(0, false), (-1, true), (1, false), (2147483647, false), (-2147483648, true)}

testAll("Integer.Value.negative", cases, args => {
  let (num, expected) = args
  let isAllowed = switch Integer.Value.negative(num) {
  | Some(_) => true
  | None => false
  }
  expect(isAllowed)->toBe(expected)
})

testAll("Integer.Value.negativeExn", cases, args => {
  let (num, expected) = args
  let isAllowed = switch Integer.Value.negativeExn(num) {
  | _ => true
  | exception Value.ConstraintUnsatisfied => false
  }
  expect(isAllowed)->toBe(expected)
})

testAll("Integer.Value.negativeUnsafe", cases, args => {
  let (num, _expected) = args
  Integer.Value.negativeUnsafe(num)->ignore
  pass
})

test("value is identity", () => {
  let arb = FastCheck.Arbitrary.integerRange(-2147483648, -1)
  Property.Sync.assert_(
    Property.Sync.property1(arb, i => {
      let constrained = Integer.Value.negative(i)
      switch constrained {
      | Some(c) => c->Value.value == i
      | None => false
      }
    }),
  )
  pass
})
