open Jest
open Expect
open FastCheck
open Arbitrary
open Property.SyncUnit
open ConstrainedType

describe("makeExn", () => {
  test("Throws InvalidArgument iff not ConstrainedType.isSatisfied", () => {
    assert_(
      property1(integer(), raw => {
        let isSatisfied = module(Integer.Positive)->Constraint.isSatisfied(raw)
        let makeExnThrows = switch Value.makeExn(raw, ~constraint_=module(Integer.Positive)) {
        | _ => false
        | exception Value.ConstraintUnsatisfied => true
        }
        expect(!isSatisfied)->toBe(makeExnThrows)->affirm
      }),
    )
    pass
  })
})
describe("makeUnsafe", () => {
  test("Does not ever throw", () => {
    assert_(
      property1(integer(), raw => {
        Value.makeUnsafe(raw, ~constraint_=module(Integer.Positive))->ignore
      }),
    )
    pass
  })
})

describe("make", () => {
  test("isSatisfied iff make returns Some(_)", () => {
    assert_(
      property1(integer(), raw => {
        let isSatisfied = module(Integer.Positive)->Constraint.isSatisfied(raw)
        let makeReturnsSome = switch Value.make(raw, ~constraint_=module(Integer.Positive)) {
        | Some(_) => true
        | None => false
        }
        expect(isSatisfied)->toBe(makeReturnsSome)->affirm
      }),
    )
    pass
  })
})

describe("value", () => {
  test("value returns initial argument", () => {
    assert_(
      property1(integerRange(1, 2147483647), raw => {
        let value = Value.makeExn(raw, ~constraint_=module(Integer.Positive))->Value.value
        expect(value)->toBe(raw)->affirm
      }),
    )
    pass
  })
})

describe("all", () => {
  describe("make", () => {
    test("value returns initial argument", () => {
      assert_(
        property1(integer(), raw => {
          let value = Value.All.make(raw)->Value.value
          expect(value)->toBe(raw)->affirm
        }),
      )
      pass
    })
  })
})
