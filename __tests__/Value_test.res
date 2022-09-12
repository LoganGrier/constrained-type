open Jest
open Expect
open FastCheck
open Arbitrary
open Property.SyncUnit
open ConstrainedType

describe("makeExn", () => {
  test("Throws InvalidArgument iff not ConstrainedType.isSatisfied", () => {
    assert_(
      property1(
        integer(),
        raw => {
          let isSatisfied = module(Integer.Positive)->Constraint.isSatisfied(raw)
          let makeExnThrows = switch Value.makeExn(raw, ~constraint_=module(Integer.Positive)) {
          | _ => false
          | exception Value.ConstraintUnsatisfied => true
          }
          expect(!isSatisfied)->toBe(makeExnThrows)->affirm
        },
      ),
    )
    pass
  })
})
describe("makeUnsafe", () => {
  test("Does not ever throw", () => {
    assert_(
      property1(
        integer(),
        raw => {
          Value.makeUnsafe(raw, ~constraint_=module(Integer.Positive))->ignore
        },
      ),
    )
    pass
  })
})

describe("make", () => {
  test("isSatisfied iff make returns Some(_)", () => {
    assert_(
      property1(
        integer(),
        raw => {
          let isSatisfied = module(Integer.Positive)->Constraint.isSatisfied(raw)
          let makeReturnsSome = switch Value.make(raw, ~constraint_=module(Integer.Positive)) {
          | Some(_) => true
          | None => false
          }
          expect(isSatisfied)->toBe(makeReturnsSome)->affirm
        },
      ),
    )
    pass
  })
})

describe("value", () => {
  test("value returns initial argument", () => {
    assert_(
      property1(
        integerRange(1, 2147483647),
        raw => {
          let value = Value.makeExn(raw, ~constraint_=module(Integer.Positive))->Value.value
          expect(value)->toBe(raw)->affirm
        },
      ),
    )
    pass
  })
})

describe("assertConstraint", () => {
  module Positive = Constraint.MakeU({
    type t = ref<int>
    let isSatisfied = (. value) => value.contents > 0
  })
  test("throws AssertionFailure if constraint is violated", () => {
    let underlying = ref(1)
    let value = Value.makeExn(underlying, ~constraint_=module(Positive))
    underlying.contents = 0
    let throwsAssertionFailure = switch Value.assertConstraint(
      value,
      ~constraint_=module(Positive),
    ) {
    | _ => false
    | exception Value.AssertionFailure => true
    }
    expect(throwsAssertionFailure)->toBe(true)
  })
  exception ConstraintException
  module PositiveThrows = Constraint.MakeU({
    type t = ref<int>
    let isSatisfied = (. value) =>
      switch value.contents > 0 {
      | true => true
      | false => raise(ConstraintException)
      }
  })
  test("throws constraint exception if constraint throws", () => {
    let underlying = ref(1)
    let value = Value.makeExn(underlying, ~constraint_=module(PositiveThrows))
    underlying.contents = 0
    let throwsConstraintException = switch Value.assertConstraint(
      value,
      ~constraint_=module(PositiveThrows),
    ) {
    | _ => false
    | exception ConstraintException => true
    }
    expect(throwsConstraintException)->toBe(true)
  })
  test("Doesn't throw if constraint is satisfied", () => {
    let underlying = ref(1)
    let value = Value.makeExn(underlying, ~constraint_=module(Positive))
    underlying.contents = 3
    expect(() => Value.assertConstraint(value, ~constraint_=module(Positive)))->not_->toThrow
  })
})

describe("all", () => {
  describe("make", () => {
    test(
      "value returns initial argument",
      () => {
        assert_(
          property1(
            integer(),
            raw => {
              let value = Value.All.make(raw)->Value.value
              expect(value)->toBe(raw)->affirm
            },
          ),
        )
        pass
      },
    )
  })
})
