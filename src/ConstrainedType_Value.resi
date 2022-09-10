/**
A value of type 'value that satisfies the constraint with id 'id.

ConstraintType.Value.t<'value, 'id> is implemented as 'value. While this is 
an implementation detail as far as the Rescript compiler is concerned, it 
is part of the contract of this module, and as such, it is safe to assume 
in your code. This is useful in Javascript bindings when you want to 
constraint the parameters of an external JS function.

For example, suppose you have an external function "foo" that takes a single 
number parameter. You could interop with this function in Rescript as 
follows:

```rescript
module MyConstraint = Constraint.Make({
  type t = int
  let isSatisfied = ...
})
type fooResult = ...
external foo: t<int, MyConstraint.identity> => fooResult = "foo"
```

WARNING:
If the 'value type of of a ConstraintType.Value.t<'value, 'id> object is 
mutable, then instances of ConstraintType.Value.t<'value, 'id> may not 
actually satisfy the constraint specified by 'id. This could be true even 
if all instances of ConstraintType.Value.t<'value, 'id> are created with 
make or makeExn.
*/
type t<'value, 'id>

/**
@param value
@param ~constraint_
@return Some(value) if ~constraint_(value) returns true. None otherwise
@throws Any exception thrown by constraint_
*/
let make: (
  'value,
  ~constraint_: ConstrainedType_Constraint.t<'value, 'id>,
) => option<t<'value, 'id>>

exception ConstraintUnsatisfied

/**
@param value
@param ~constraint_
@return value if ~constraint_(value) returns true
@throws ConstraintUnsatisfied if ~constraint_(value) returns false
@throws Any exception thrown by constraint_
*/
let makeExn: ('value, ~constraint_: ConstrainedType_Constraint.t<'value, 'id>) => t<'value, 'id>

/**
@param value
@param ~constraint_
@return value
@property Does not execute constraint_ on value
*/
let makeUnsafe: ('value, ~constraint_: ConstrainedType_Constraint.t<'value, 'id>) => t<'value, 'id>

/**
@param constrainedValue
@return The argument, as an unconstrained value
*/
let value: t<'value, 'id> => 'value

module All: {
  /**
  @param value
  @return value, constrained with the "All" constraint
  */
  let make: 'value => t<'value, ConstrainedType_Constraint.All.identity>
}
