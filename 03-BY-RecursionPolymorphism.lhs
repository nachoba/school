Recursion Patterns, Polymorphism, and the Prelude
‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾
At this point, you might think Haskell programmers spend most of their time wri-
ting recursive  functions.  In fact, they hardly ever do!  How is this possible?
The key  is  to notice that  although recursive  functions can  theoretically do
pretty much anything, in practice there are certain common patterns that come up
over  and over again.  By abstracting out these patterns into library functions,
programmers can leave the low-level details of actually doing recursion to these
functions, and think about problems at a higher level -that's the goal of whole-
meal programming.

Recursion Patterns
‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾
Recall our simple definition of lists of Int values:

> data IntList = Empty | Cons Int IntList
>     deriving Show

What sorts of  things might we want to do with an IntList? Here are a few common
possibilities:

* Perform some operation on every element of the list.
* Keep only some elements of the list, and throw othes away, based on a test.
* Summarize the elements of the list somehow: sum, product, maximum,..
* You can probably think of others!

Map
‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾
Let's think about the first one: "Perform some operation on every element of the
list." For example, we could add one to every element in a list:

> addOneToAll :: IntList -> IntList
> addOneToAll Empty       = Empty
> addOneToAll (Cons x xs) = Cons (x + 1) (addOneToAll xs)

> myIntList = Cons 2 (Cons (-3) (Cons 5 Empty))

If we apply addOneToAll to myIntList
Prelude> print $ addOneToAll myIntList
Cons 3 (Cons (-2) (Cons 6 Empty))

Or we could ensure that every element in a list is nonnegative by taking the ab-
solute value:

> absAll :: IntList -> IntList
> absAll Empty        = Empty
> absAll (Cons x xs)  = Cons (abs x) (absAll xs)

Prelude> print $ absAll myIntList
Cons 2 (Cons 3 (Cons 5 Empty))

Or we could square every element:

> squareAll :: IntList -> IntList
> squareAll Empty       = Empty
> squareAll (Cons x xs) = Cons (x * x) (squareAll xs)

Prelude> print $ squareAll myIntList
Cons 4 (Cons 9 (Cons 25 Empty))

At this point, big flashing red lights  and warning bells whould be going off in
your head. These three functions look way too similar.There ought to be some way
to abstract out the commonality so we don't have to repeat ourselves!.  There is
indeed a way -can you figure it out? Which parts are the same in all three exam-
ples and which parts change?
[All functions have the same base condition. All functions take one argument and
return one result of the same type. All functions are recursive.]

