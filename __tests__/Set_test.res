open Jest
open Expect
open FastCheck
open Arbitrary
open Property.SyncUnit
open Arbitraries
open ConstrainedType

describe("make", () => {
  test("Returns Ok(_) when all entries satisfy constraint", () => {
    assert_(
      property1(
        set(positiveInt()),
        underlying => {
          switch underlying->Set.make(~constraint_=module(Integer.Positive)) {
          | Ok(_) => pass->affirm
          | Error(_) => fail("Unexpected error")->affirm
          }
        },
      ),
    )
    pass
  })
  test("Returns Error(_) when some entries violate constraint", () => {
    assert_(
      property2(
        set(negativeInt())->Derive.filter(set => set->Belt.Set.size > 0),
        set(positiveInt()),
        (violatingElements, satisfyingElements) => {
          let underlying = Belt.Set.union(violatingElements, satisfyingElements)
          switch underlying->Set.make(~constraint_=module(Integer.Positive)) {
          | Ok(_) => fail("Unexpected OK")->affirm
          | Error(Set.InvalidEntries(violations)) =>
            expect(violations->Belt.Set.eq(violatingElements))->toBe(true)->affirm
          }
        },
      ),
    )
    pass
  })
  test("Element in result iff element in argument", () => {
    assert_(
      property1(
        set(positiveInt()),
        underlying => {
          switch underlying->Set.make(~constraint_=module(Integer.Positive)) {
          | Ok(result) => {
              let underlyingSubsetsResult =
                underlying
                ->Belt.Set.keepU(
                  (. element) =>
                    !(
                      result->Belt.Set.has(
                        element->Value.makeExn(~constraint_=module(Integer.Positive)),
                      )
                    ),
                )
                ->Belt.Set.size == 0
              let resultSubsetsUnderlying =
                result
                ->Belt.Set.keepU((. element) => !(underlying->Belt.Set.has(element->Value.value)))
                ->Belt.Set.size == 0
              expect(underlyingSubsetsResult && resultSubsetsUnderlying)->toBe(true)->affirm
            }

          | Error(_) => fail("Unexpected error")->affirm
          }
        },
      ),
    )
    pass
  })
})
describe("makeExn", () => {
  test("Returns a value when all entries satisfy constraint", () => {
    assert_(
      property1(
        set(positiveInt()),
        underlying => {
          expect(() => underlying->Set.makeExn(~constraint_=module(Integer.Positive)))
          ->not_
          ->toThrow
          ->affirm
        },
      ),
    )
    pass
  })
  test("Returns throws InvalidEntriesException when some entries violate constraint", () => {
    assert_(
      property2(
        set(negativeInt())->Derive.filter(set => set->Belt.Set.size > 0),
        set(positiveInt()),
        (violatingElements, satisfyingElements) => {
          let underlying = Belt.Set.union(violatingElements, satisfyingElements)
          switch underlying->Set.makeExn(~constraint_=module(Integer.Positive)) {
          | _ => fail("Unexpected success")->affirm
          | exception Set.InvalidEntriesException => pass->affirm
          }
        },
      ),
    )
    pass
  })
  test("Element in result iff element in argument", () => {
    assert_(
      property1(
        set(positiveInt()),
        underlying => {
          let result = underlying->Set.makeExn(~constraint_=module(Integer.Positive))
          let underlyingSubsetsResult =
            underlying
            ->Belt.Set.keepU(
              (. element) =>
                !(
                  result->Belt.Set.has(
                    element->Value.makeExn(~constraint_=module(Integer.Positive)),
                  )
                ),
            )
            ->Belt.Set.size == 0
          let resultSubsetsUnderlying =
            result
            ->Belt.Set.keepU((. element) => !(underlying->Belt.Set.has(element->Value.value)))
            ->Belt.Set.size == 0
          expect(underlyingSubsetsResult && resultSubsetsUnderlying)->toBe(true)->affirm
        },
      ),
    )
    pass
  })
})
describe("makeUnsafe", () => {
  test("Returns a value when all entries satisfy constraint", () => {
    assert_(
      property1(
        set(positiveInt()),
        underlying => {
          expect(() => underlying->Set.makeUnsafe(~constraint_=module(Integer.Positive)))
          ->not_
          ->toThrow
          ->affirm
        },
      ),
    )
    pass
  })
  test("Does not throw when some entries violate constraint", () => {
    assert_(
      property2(
        set(negativeInt())->Derive.filter(set => set->Belt.Set.size > 0),
        set(positiveInt()),
        (violatingElements, satisfyingElements) => {
          let underlying = Belt.Set.union(violatingElements, satisfyingElements)
          underlying->Set.makeUnsafe(~constraint_=module(Integer.Positive))->ignore
        },
      ),
    )
    pass
  })
  test("Element in result iff element in argument", () => {
    assert_(
      property1(
        set(positiveInt()),
        underlying => {
          let result = underlying->Set.makeUnsafe(~constraint_=module(Integer.Positive))
          let underlyingSubsetsResult =
            underlying
            ->Belt.Set.keepU(
              (. element) =>
                !(
                  result->Belt.Set.has(
                    element->Value.makeUnsafe(~constraint_=module(Integer.Positive)),
                  )
                ),
            )
            ->Belt.Set.size == 0
          let resultSubsetsUnderlying =
            result
            ->Belt.Set.keepU((. element) => !(underlying->Belt.Set.has(element->Value.value)))
            ->Belt.Set.size == 0
          expect(underlyingSubsetsResult && resultSubsetsUnderlying)->toBe(true)->affirm
        },
      ),
    )
    pass
  })
})
describe("value", () => {
  test("underlying->make->value eq underlying", () => {
    assert_(
      property1(
        set(positiveInt()),
        underlying => {
          let result = underlying->Set.makeExn(~constraint_=module(Integer.Positive))
          expect(result->Set.value)->toEqual(underlying)->affirm
        },
      ),
    )
    pass
  })
})

module AllInteger1 = Constraint.All.Make({
  type t = int
})
module AllInteger2 = Constraint.All.Make({
  type t = int
})
test("Two sets with different All constraints are compatible", () => {
  assert_(
    property2(set(integer()), set(integer()), (underlying1, underlying2) => {
      let constrainedSet1 = Set.makeExn(underlying1, ~constraint_=module(AllInteger1))
      let constrainedSet2 = Set.makeExn(underlying2, ~constraint_=module(AllInteger2))
      let constrainedUnion = constrainedSet1->Belt.Set.union(constrainedSet2)
      let actualUnderlyingUnion = constrainedUnion->Set.value
      let expectedUnderlyingUnion = underlying1->Belt.Set.union(underlying2)
      expect(actualUnderlyingUnion->Belt.Set.eq(expectedUnderlyingUnion))->toEqual(true)->affirm
    }),
  )
  pass
})
