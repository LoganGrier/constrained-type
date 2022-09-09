open Jest
open Expect
open FastCheck
open Property.SyncUnit
open Arbitraries
open ConstrainedType
open Arbitrary

describe("make", () => {
  test("Returns Ok(_) when all entries satisfy constraint", () => {
    assert_(
      property1(map(positiveInt(), negativeInt()), underlying => {
        switch underlying->Map.make(
          ~keyConstraint=module(Integer.Positive),
          ~valueConstraint=module(Integer.Negative),
        ) {
        | Ok(_) => pass->affirm
        | Error(_) => fail("Unexpected error")->affirm
        }
      }),
    )
    pass
  })
  test("Returns Error(_) when some entries violate key constraint", () => {
    assert_(
      property2(
        map(positiveInt(), negativeInt()),
        map(negativeInt(), negativeInt())->Arbitrary.Derive.filter(map => map->Belt.Map.size > 0),
        (satisfyingElements, violatingElements) => {
          let underlying = Belt.Map.mergeMany(
            satisfyingElements,
            violatingElements->Belt.Map.toArray,
          )
          switch underlying->Map.make(
            ~keyConstraint=module(Integer.Positive),
            ~valueConstraint=module(Integer.Negative),
          ) {
          | Ok(_) => fail("Unexpected OK")->affirm
          | Error(Map.InvalidEntries(violations)) =>
            expect(violations->Belt.Map.eq(violatingElements, (v1, v2) => v1 == v2))
            ->toBe(true)
            ->affirm
          }
        },
      ),
    )
    pass
  })
  test("Returns Error(_) when some entries violate value constraint", () => {
    assert_(
      property2(
        map(positiveInt(), negativeInt()),
        map(positiveInt(), positiveInt())->Arbitrary.Derive.filter(map => map->Belt.Map.size > 0),
        (satisfyingElements, violatingElements) => {
          let underlying = Belt.Map.mergeMany(
            satisfyingElements,
            violatingElements->Belt.Map.toArray,
          )
          switch underlying->Map.make(
            ~keyConstraint=module(Integer.Positive),
            ~valueConstraint=module(Integer.Negative),
          ) {
          | Ok(_) => fail("Unexpected OK")->affirm
          | Error(Map.InvalidEntries(violations)) =>
            expect(violations->Belt.Map.eq(violatingElements, (v1, v2) => v1 == v2))
            ->toBe(true)
            ->affirm
          }
        },
      ),
    )
    pass
  })
  test("Returns Error(_) when some entries violate both constraints", () => {
    assert_(
      property2(
        map(positiveInt(), negativeInt()),
        map(negativeInt(), positiveInt())->Arbitrary.Derive.filter(map => map->Belt.Map.size > 0),
        (satisfyingElements, violatingElements) => {
          let underlying = Belt.Map.mergeMany(
            satisfyingElements,
            violatingElements->Belt.Map.toArray,
          )
          switch underlying->Map.make(
            ~keyConstraint=module(Integer.Positive),
            ~valueConstraint=module(Integer.Negative),
          ) {
          | Ok(_) => fail("Unexpected OK")->affirm
          | Error(Map.InvalidEntries(violations)) =>
            expect(violations->Belt.Map.eq(violatingElements, (v1, v2) => v1 == v2))
            ->toBe(true)
            ->affirm
          }
        },
      ),
    )
    pass
  })
  test("Element in result iff element in argument", () => {
    assert_(
      property1(map(positiveInt(), negativeInt()), underlying => {
        switch underlying->Map.make(
          ~keyConstraint=module(Integer.Positive),
          ~valueConstraint=module(Integer.Negative),
        ) {
        | Ok(result) => {
            let underlyingSubsetsResult =
              underlying
              ->Belt.Map.keepU((. key, value) => {
                result->Belt.Map.get(key->Value.makeExn(~constraint_=module(Integer.Positive))) !=
                  Some(value->Value.makeExn(~constraint_=module(Integer.Negative)))
              })
              ->Belt.Map.size == 0
            let resultSubsetsUnderlying =
              result
              ->Belt.Map.keepU((. key, value) => {
                underlying->Belt.Map.get(key->Value.value) != Some(value->Value.value)
              })
              ->Belt.Map.size == 0
            expect(underlyingSubsetsResult && resultSubsetsUnderlying)->toBe(true)->affirm
          }
        | Error(_) => fail("Unexpected error")->affirm
        }
      }),
    )
    pass
  })
})
describe("makeExn", () => {
  test("Does not throw when all entries satisfy constraint", () => {
    assert_(
      property1(map(positiveInt(), negativeInt()), underlying => {
        expect(() =>
          underlying->Map.makeExn(
            ~keyConstraint=module(Integer.Positive),
            ~valueConstraint=module(Integer.Negative),
          )
        )
        ->not_
        ->toThrow
        ->affirm
      }),
    )
    pass
  })
  test("Throws InvalidEntriesException when some entries violate key constraint", () => {
    assert_(
      property2(
        map(positiveInt(), negativeInt()),
        map(negativeInt(), negativeInt())->Arbitrary.Derive.filter(map => map->Belt.Map.size > 0),
        (satisfyingElements, violatingElements) => {
          let underlying = Belt.Map.mergeMany(
            satisfyingElements,
            violatingElements->Belt.Map.toArray,
          )
          switch underlying->Map.makeExn(
            ~keyConstraint=module(Integer.Positive),
            ~valueConstraint=module(Integer.Negative),
          ) {
          | _ => fail("Unexpected OK")->affirm
          | exception Map.InvalidEntriesException => pass->affirm
          }
        },
      ),
    )
    pass
  })
  test("Throws InvalidEntriesException when some entries violate value constraint", () => {
    assert_(
      property2(
        map(positiveInt(), negativeInt()),
        map(positiveInt(), positiveInt())->Arbitrary.Derive.filter(map => map->Belt.Map.size > 0),
        (satisfyingElements, violatingElements) => {
          let underlying = Belt.Map.mergeMany(
            satisfyingElements,
            violatingElements->Belt.Map.toArray,
          )
          switch underlying->Map.makeExn(
            ~keyConstraint=module(Integer.Positive),
            ~valueConstraint=module(Integer.Negative),
          ) {
          | _ => fail("Unexpected OK")->affirm
          | exception Map.InvalidEntriesException => pass->affirm
          }
        },
      ),
    )
    pass
  })
  test("Throws InvalidEntriesException when some entries violate both constraints", () => {
    assert_(
      property2(
        map(positiveInt(), negativeInt()),
        map(negativeInt(), positiveInt())->Arbitrary.Derive.filter(map => map->Belt.Map.size > 0),
        (satisfyingElements, violatingElements) => {
          let underlying = Belt.Map.mergeMany(
            satisfyingElements,
            violatingElements->Belt.Map.toArray,
          )
          switch underlying->Map.makeExn(
            ~keyConstraint=module(Integer.Positive),
            ~valueConstraint=module(Integer.Negative),
          ) {
          | _ => fail("Unexpected OK")->affirm
          | exception Map.InvalidEntriesException => pass->affirm
          }
        },
      ),
    )
    pass
  })
  test("Element in result iff element in argument", () => {
    assert_(
      property1(map(positiveInt(), negativeInt()), underlying => {
        let result =
          underlying->Map.makeExn(
            ~keyConstraint=module(Integer.Positive),
            ~valueConstraint=module(Integer.Negative),
          )
        let underlyingSubsetsResult =
          underlying
          ->Belt.Map.keepU((. key, value) => {
            result->Belt.Map.get(key->Value.makeExn(~constraint_=module(Integer.Positive))) !=
              Some(value->Value.makeExn(~constraint_=module(Integer.Negative)))
          })
          ->Belt.Map.size == 0
        let resultSubsetsUnderlying =
          result
          ->Belt.Map.keepU((. key, value) => {
            underlying->Belt.Map.get(key->Value.value) != Some(value->Value.value)
          })
          ->Belt.Map.size == 0
        expect(underlyingSubsetsResult && resultSubsetsUnderlying)->toBe(true)->affirm
      }),
    )
    pass
  })
})
describe("makeUnsafe", () => {
  test("Does not throw when all entries satisfy constraint", () => {
    assert_(
      property1(map(positiveInt(), negativeInt()), underlying => {
        expect(() =>
          underlying->Map.makeExn(
            ~keyConstraint=module(Integer.Positive),
            ~valueConstraint=module(Integer.Negative),
          )
        )
        ->not_
        ->toThrow
        ->affirm
      }),
    )
    pass
  })
  test("Does not throw when some entries violate key constraint", () => {
    assert_(
      property2(
        map(positiveInt(), negativeInt()),
        map(negativeInt(), negativeInt())->Arbitrary.Derive.filter(map => map->Belt.Map.size > 0),
        (satisfyingElements, violatingElements) => {
          let underlying = Belt.Map.mergeMany(
            satisfyingElements,
            violatingElements->Belt.Map.toArray,
          )
          underlying
          ->Map.makeUnsafe(
            ~keyConstraint=module(Integer.Positive),
            ~valueConstraint=module(Integer.Negative),
          )
          ->ignore
        },
      ),
    )
    pass
  })
  test("Does not throw when some entries violate value constraint", () => {
    assert_(
      property2(
        map(positiveInt(), negativeInt()),
        map(positiveInt(), positiveInt())->Arbitrary.Derive.filter(map => map->Belt.Map.size > 0),
        (satisfyingElements, violatingElements) => {
          let underlying = Belt.Map.mergeMany(
            satisfyingElements,
            violatingElements->Belt.Map.toArray,
          )
          underlying
          ->Map.makeUnsafe(
            ~keyConstraint=module(Integer.Positive),
            ~valueConstraint=module(Integer.Negative),
          )
          ->ignore
        },
      ),
    )
    pass
  })
  test("Does not throw when some entries violate both constraints", () => {
    assert_(
      property2(
        map(positiveInt(), negativeInt()),
        map(negativeInt(), positiveInt())->Arbitrary.Derive.filter(map => map->Belt.Map.size > 0),
        (satisfyingElements, violatingElements) => {
          let underlying = Belt.Map.mergeMany(
            satisfyingElements,
            violatingElements->Belt.Map.toArray,
          )
          underlying
          ->Map.makeUnsafe(
            ~keyConstraint=module(Integer.Positive),
            ~valueConstraint=module(Integer.Negative),
          )
          ->ignore
        },
      ),
    )
    pass
  })
  test("Element in result iff element in argument", () => {
    assert_(
      property1(map(positiveInt(), negativeInt()), underlying => {
        let result =
          underlying->Map.makeUnsafe(
            ~keyConstraint=module(Integer.Positive),
            ~valueConstraint=module(Integer.Negative),
          )
        let underlyingSubsetsResult =
          underlying
          ->Belt.Map.keepU((. key, value) => {
            result->Belt.Map.get(key->Value.makeUnsafe(~constraint_=module(Integer.Positive))) !=
              Some(value->Value.makeUnsafe(~constraint_=module(Integer.Negative)))
          })
          ->Belt.Map.size == 0
        let resultSubsetsUnderlying =
          result
          ->Belt.Map.keepU((. key, value) => {
            underlying->Belt.Map.get(key->Value.value) != Some(value->Value.value)
          })
          ->Belt.Map.size == 0
        expect(underlyingSubsetsResult && resultSubsetsUnderlying)->toBe(true)->affirm
      }),
    )
    pass
  })
})
describe("value", () => {
  test("underlying->make->value eq underlying", () => {
    assert_(
      property1(map(positiveInt(), negativeInt()), underlying => {
        let result =
          underlying->Map.makeExn(
            ~keyConstraint=module(Integer.Positive),
            ~valueConstraint=module(Integer.Negative),
          )
        expect(result->Map.value)->toEqual(underlying)->affirm
      }),
    )
    pass
  })
})

describe("KeyOnly", () => {
  describe("make", () => {
    test("Returns Ok(_) when all entries satisfy constraint", () => {
      assert_(
        property1(map(positiveInt(), integer()), underlying => {
          switch underlying->Map.KeyOnly.make(module(Integer.Positive)) {
          | Ok(_) => pass->affirm
          | Error(_) => fail("Unexpected error")->affirm
          }
        }),
      )
      pass
    })
    test("Returns Error(_) when some entries violate constraint", () => {
      assert_(
        property2(
          map(positiveInt(), integer()),
          map(negativeInt(), integer())->Arbitrary.Derive.filter(map => map->Belt.Map.size > 0),
          (satisfyingElements, violatingElements) => {
            let underlying = Belt.Map.mergeMany(
              satisfyingElements,
              violatingElements->Belt.Map.toArray,
            )
            switch underlying->Map.KeyOnly.make(module(Integer.Positive)) {
            | Ok(_) => fail("Unexpected OK")->affirm
            | Error(Map.InvalidEntries(violations)) =>
              expect(violations->Belt.Map.eq(violatingElements, (v1, v2) => v1 == v2))
              ->toBe(true)
              ->affirm
            }
          },
        ),
      )
      pass
    })
    test("Element in result iff element in argument", () => {
      assert_(
        property1(map(positiveInt(), integer()), underlying => {
          switch underlying->Map.KeyOnly.make(module(Integer.Positive)) {
          | Ok(result) => {
              let underlyingSubsetsResult =
                underlying
                ->Belt.Map.keepU((. key, value) => {
                  result->Belt.Map.get(key->Value.makeExn(~constraint_=module(Integer.Positive))) !=
                    Some(value)
                })
                ->Belt.Map.size == 0
              let resultSubsetsUnderlying =
                result
                ->Belt.Map.keepU((. key, value) => {
                  underlying->Belt.Map.get(key->Value.value) != Some(value)
                })
                ->Belt.Map.size == 0
              expect(underlyingSubsetsResult && resultSubsetsUnderlying)->toBe(true)->affirm
            }
          | Error(_) => fail("Unexpected error")->affirm
          }
        }),
      )
      pass
    })
  })
  describe("makeExn", () => {
    test("Does not throw when all entries satisfy constraint", () => {
      assert_(
        property1(map(positiveInt(), integer()), underlying => {
          expect(() => underlying->Map.KeyOnly.makeExn(module(Integer.Positive)))
          ->not_
          ->toThrow
          ->affirm
        }),
      )
      pass
    })
    test("Throws InvalidEntriesException when some entries violate key constraint", () => {
      assert_(
        property2(
          map(positiveInt(), integer()),
          map(negativeInt(), integer())->Arbitrary.Derive.filter(map => map->Belt.Map.size > 0),
          (satisfyingElements, violatingElements) => {
            let underlying = Belt.Map.mergeMany(
              satisfyingElements,
              violatingElements->Belt.Map.toArray,
            )
            switch underlying->Map.KeyOnly.makeExn(module(Integer.Positive)) {
            | _ => fail("Unexpected OK")->affirm
            | exception Map.InvalidEntriesException => pass->affirm
            }
          },
        ),
      )
      pass
    })
    test("Element in result iff element in argument", () => {
      assert_(
        property1(map(positiveInt(), integer()), underlying => {
          let result = underlying->Map.KeyOnly.makeExn(module(Integer.Positive))
          let underlyingSubsetsResult =
            underlying
            ->Belt.Map.keepU((. key, value) => {
              result->Belt.Map.get(key->Value.makeExn(~constraint_=module(Integer.Positive))) !=
                Some(value)
            })
            ->Belt.Map.size == 0
          let resultSubsetsUnderlying =
            result
            ->Belt.Map.keepU((. key, value) => {
              underlying->Belt.Map.get(key->Value.value) != Some(value)
            })
            ->Belt.Map.size == 0
          expect(underlyingSubsetsResult && resultSubsetsUnderlying)->toBe(true)->affirm
        }),
      )
      pass
    })
  })
  describe("makeUnsafe", () => {
    test("Does not throw when all entries satisfy constraint", () => {
      assert_(
        property1(map(positiveInt(), integer()), underlying => {
          expect(() => underlying->Map.KeyOnly.makeExn(module(Integer.Positive)))
          ->not_
          ->toThrow
          ->affirm
        }),
      )
      pass
    })
    test("Does not throw when some entries violate key constraint", () => {
      assert_(
        property2(
          map(positiveInt(), integer()),
          map(negativeInt(), integer())->Arbitrary.Derive.filter(map => map->Belt.Map.size > 0),
          (satisfyingElements, violatingElements) => {
            let underlying = Belt.Map.mergeMany(
              satisfyingElements,
              violatingElements->Belt.Map.toArray,
            )
            underlying->Map.KeyOnly.makeUnsafe(module(Integer.Positive))->ignore
          },
        ),
      )
      pass
    })
    test("Element in result iff element in argument", () => {
      assert_(
        property1(map(positiveInt(), integer()), underlying => {
          let result = underlying->Map.KeyOnly.makeUnsafe(module(Integer.Positive))
          let underlyingSubsetsResult =
            underlying
            ->Belt.Map.keepU((. key, value) => {
              result->Belt.Map.get(key->Value.makeUnsafe(~constraint_=module(Integer.Positive))) !=
                Some(value)
            })
            ->Belt.Map.size == 0
          let resultSubsetsUnderlying =
            result
            ->Belt.Map.keepU((. key, value) => {
              underlying->Belt.Map.get(key->Value.value) != Some(value)
            })
            ->Belt.Map.size == 0
          expect(underlyingSubsetsResult && resultSubsetsUnderlying)->toBe(true)->affirm
        }),
      )
      pass
    })
  })
  describe("value", () => {
    test("underlying->make->value eq underlying", () => {
      assert_(
        property1(map(positiveInt(), integer()), underlying => {
          let result = underlying->Map.KeyOnly.makeExn(module(Integer.Positive))
          expect(result->Map.KeyOnly.value)->toEqual(underlying)->affirm
        }),
      )
      pass
    })
  })
})

describe("ValueOnly", () => {
  describe("make", () => {
    test("Returns Ok(_) when all entries satisfy constraint", () => {
      assert_(
        property1(map(integer(), negativeInt()), underlying => {
          switch underlying->Map.ValueOnly.make(module(Integer.Negative)) {
          | Ok(_) => pass->affirm
          | Error(_) => fail("Unexpected error")->affirm
          }
        }),
      )
      pass
    })
    test("Returns Error(_) when some entries violate value constraint", () => {
      assert_(
        property2(
          map(integer(), negativeInt()),
          map(integer(), positiveInt())->Arbitrary.Derive.filter(map => map->Belt.Map.size > 0),
          (satisfyingElements, violatingElements) => {
            let underlying = Belt.Map.mergeMany(
              satisfyingElements,
              violatingElements->Belt.Map.toArray,
            )
            switch underlying->Map.ValueOnly.make(module(Integer.Negative)) {
            | Ok(_) => fail("Unexpected OK")->affirm
            | Error(Map.InvalidEntries(violations)) =>
              expect(violations->Belt.Map.eq(violatingElements, (v1, v2) => v1 == v2))
              ->toBe(true)
              ->affirm
            }
          },
        ),
      )
      pass
    })
    test("Element in result iff element in argument", () => {
      assert_(
        property1(map(integer(), negativeInt()), underlying => {
          switch underlying->Map.ValueOnly.make(module(Integer.Negative)) {
          | Ok(result) => {
              let underlyingSubsetsResult =
                underlying
                ->Belt.Map.keepU((. key, value) => {
                  result->Belt.Map.get(key) !=
                    Some(value->Value.makeExn(~constraint_=module(Integer.Negative)))
                })
                ->Belt.Map.size == 0
              let resultSubsetsUnderlying =
                result
                ->Belt.Map.keepU((. key, value) => {
                  underlying->Belt.Map.get(key) != Some(value->Value.value)
                })
                ->Belt.Map.size == 0
              expect(underlyingSubsetsResult && resultSubsetsUnderlying)->toBe(true)->affirm
            }
          | Error(_) => fail("Unexpected error")->affirm
          }
        }),
      )
      pass
    })
  })
  describe("makeExn", () => {
    test("Does not throw when all entries satisfy constraint", () => {
      assert_(
        property1(map(integer(), negativeInt()), underlying => {
          expect(() => underlying->Map.ValueOnly.makeExn(module(Integer.Negative)))
          ->not_
          ->toThrow
          ->affirm
        }),
      )
      pass
    })
    test("Throws InvalidEntriesException when some entries violate value constraint", () => {
      assert_(
        property2(
          map(integer(), negativeInt()),
          map(integer(), positiveInt())->Arbitrary.Derive.filter(map => map->Belt.Map.size > 0),
          (satisfyingElements, violatingElements) => {
            let underlying = Belt.Map.mergeMany(
              satisfyingElements,
              violatingElements->Belt.Map.toArray,
            )
            switch underlying->Map.ValueOnly.makeExn(module(Integer.Negative)) {
            | _ => fail("Unexpected OK")->affirm
            | exception Map.InvalidEntriesException => pass->affirm
            }
          },
        ),
      )
      pass
    })
    test("Element in result iff element in argument", () => {
      assert_(
        property1(map(integer(), negativeInt()), underlying => {
          let result = underlying->Map.ValueOnly.makeExn(module(Integer.Negative))
          let underlyingSubsetsResult =
            underlying
            ->Belt.Map.keepU((. key, value) => {
              result->Belt.Map.get(key) !=
                Some(value->Value.makeExn(~constraint_=module(Integer.Negative)))
            })
            ->Belt.Map.size == 0
          let resultSubsetsUnderlying =
            result
            ->Belt.Map.keepU((. key, value) => {
              underlying->Belt.Map.get(key) != Some(value->Value.value)
            })
            ->Belt.Map.size == 0
          expect(underlyingSubsetsResult && resultSubsetsUnderlying)->toBe(true)->affirm
        }),
      )
      pass
    })
  })
  describe("makeUnsafe", () => {
    test("Does not throw when all entries satisfy constraint", () => {
      assert_(
        property1(map(integer(), negativeInt()), underlying => {
          expect(() => underlying->Map.ValueOnly.makeExn(module(Integer.Negative)))
          ->not_
          ->toThrow
          ->affirm
        }),
      )
      pass
    })
    test("Does not throw when some entries violate value constraint", () => {
      assert_(
        property2(
          map(integer(), negativeInt()),
          map(integer(), positiveInt())->Arbitrary.Derive.filter(map => map->Belt.Map.size > 0),
          (satisfyingElements, violatingElements) => {
            let underlying = Belt.Map.mergeMany(
              satisfyingElements,
              violatingElements->Belt.Map.toArray,
            )
            underlying->Map.ValueOnly.makeUnsafe(module(Integer.Negative))->ignore
          },
        ),
      )
      pass
    })
    test("Element in result iff element in argument", () => {
      assert_(
        property1(map(integer(), negativeInt()), underlying => {
          let result = underlying->Map.ValueOnly.makeUnsafe(module(Integer.Negative))
          let underlyingSubsetsResult =
            underlying
            ->Belt.Map.keepU((. key, value) => {
              result->Belt.Map.get(key) !=
                Some(value->Value.makeUnsafe(~constraint_=module(Integer.Negative)))
            })
            ->Belt.Map.size == 0
          let resultSubsetsUnderlying =
            result
            ->Belt.Map.keepU((. key, value) => {
              underlying->Belt.Map.get(key) != Some(value->Value.value)
            })
            ->Belt.Map.size == 0
          expect(underlyingSubsetsResult && resultSubsetsUnderlying)->toBe(true)->affirm
        }),
      )
      pass
    })
  })
  describe("value", () => {
    test("underlying->make->value eq underlying", () => {
      assert_(
        property1(map(integer(), negativeInt()), underlying => {
          let result = underlying->Map.ValueOnly.makeExn(module(Integer.Negative))
          expect(result->Map.ValueOnly.value)->toEqual(underlying)->affirm
        }),
      )
      pass
    })
  })
})

module AllInteger1 = Constraint.All.Make({
  type t = int
})
module AllInteger2 = Constraint.All.Make({
  type t = int
})
module AllInteger3 = Constraint.All.Make({
  type t = int
})
module AllInteger4 = Constraint.All.Make({
  type t = int
})
test("Two maps with different All constraints are compatible", () => {
  assert_(
    property2(
      map(Arbitrary.integer(), Arbitrary.integer()),
      map(Arbitrary.integer(), Arbitrary.integer()),
      (underlying1, underlying2) => {
        let constrainedMap1 =
          underlying1->Map.makeExn(
            ~keyConstraint=module(AllInteger1),
            ~valueConstraint=module(AllInteger2),
          )
        let constrainedMap2 =
          underlying2->Map.makeExn(
            ~keyConstraint=module(AllInteger3),
            ~valueConstraint=module(AllInteger4),
          )
        let constrainedUnion =
          constrainedMap1->Belt.Map.mergeMany(constrainedMap2->Belt.Map.toArray)
        let actualUnderlyingUnion = constrainedUnion->Map.value
        let expectedUnderlyingUnion = underlying1->Belt.Map.mergeMany(underlying2->Belt.Map.toArray)
        expect(actualUnderlyingUnion)->toEqual(expectedUnderlyingUnion)->affirm
      },
    ),
  )
  pass
})
