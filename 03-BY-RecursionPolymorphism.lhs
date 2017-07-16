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
The thing that changes, of course, is the  operation we want to perform  on each
element of the list. We can specify this operation as a function of type:
                                                                       Int → Int
Here is  where  we begin  to see how incredibly  useful it is to be able to pass
functions as inputs to other functions!.

> mapIntList :: (Int -> Int) -> IntList -> IntList
> mapIntList _ Empty       = Empty
> mapIntList f (Cons x xs) = Cons (f x) (mapIntList f xs)

So we can now use mapIntList to re-implement: addOneToAll, absAll, squareAll:
First we define the functions that implement the "Int → Int" part:

> addOne :: Int -> Int
> addOne x = x + 1

> square :: Int -> Int
> square x = x * x

> addOneToAll' :: IntList -> IntList
> addOneToAll' xs = mapIntList addOne xs

> absAll' :: IntList -> IntList
> absAll' xs = mapIntList abs xs

> squareAll' :: IntList -> IntList
> squareAll' xs = mapIntList square xs

Prelude> print $ absAll' myIntList
Cons 2 (Cons 3 (Cons 5 Empty))

Prelude> print $ addOneToAll' myIntList
Cons 3 (Cons (-2) (Cons 6 Empty))

Prelude> print $ squareAll' myIntList
Cons 4 (Cons 9 (Cons 25 Empty))

Filter
‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾
Another common pattern is when we want to keep only some elements of a list, and
throw others away, based on a test.  For example, we might want to keep only the
even numbers:

> keepOnlyEven :: IntList -> IntList
> keepOnlyEven Empty                   = Empty
> keepOnlyEven (Cons x xs) | even x    = Cons x (keepOnlyEven xs)
>                          | otherwise = keepOnlyEven xs

Prelude> print $ keepOnlyEven myIntList
Cons 2 Empty

How can we generalize this pattern? What stays the same,  and what do we need to
abstract out? The thing to abstract out is  the test (or predicate)  used to de-
termine which values to keep.    A predicate is a function of type "Int → Bool",
which returns True for those  elements which should be kept, and False for those
which should be discarded.  So we can write a function filterIntList as follows:

> filterIntList :: (Int -> Bool) -> IntList -> IntList
> filterIntList _ Empty                    = Empty
> filterIntList p (Cons x xs) | p x        = Cons x (filterIntList p xs)
>                             | otherwise  = filterIntList p xs

Prelude> print $ filterIntList even myIntList
Cons 2 Empty

Fold
‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾
The final pattern mentioned was to "summarize" the elements of the list; this is
also variously known as "fold" or "reduce" operation. We'll come back to this in
the next lesson.  In the meantime, you might want to think about how to abstract
out this pattern.

Polymorphism
‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾
We have now written some nice,  general functions for mapping and filtering over
lists of Ints.But we're not done generalizing! What if we wanted to filter lists
of Integers? or Bools? Or lists of lists of trees of stacks of Strings? We would
have to make a new data type  and a new function for each  of these cases.  Even
worse the code would be exactly the same; the only thing that would be different
is the type signatures. Can't Haskell help us out here?
Of course it can! Haskell supports polymorphism for data types and functions.The
word "polymorphic" comes from  Greek and means  "having  many forms":  something
which is polymorphic works for multiple types.

Polymorphic data types
‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾
First, let's see how to declare a polymorphic data type:

> data List t = Empty2 | Cons2 t (List t)
>    deriving Show

Whereas before we had "data IntList = ...", we now have "data List t = ...". The
"t" is a type variable wich can stand for  any type.  Type variables  must start
with a lowercase letter, whereas types must start with uppercase.This expression
"data List t = ..." means that the List type is parameterized by a type, in much
the same way that a function can be parameterized by some input.
Given a type t, a "List t" consists of either the constructor Empty,or the cons-
tructor Cons along with a value of type "t" and another "List t". Here are  some
examples:

> list1 :: List Int
> list1 = Cons2 3 (Cons2 5 (Cons2 2 Empty2))

> list2 :: List Char
> list2 = Cons2 'x' (Cons2 'y' (Cons2 'z' Empty2))

> list3 :: List Bool
> list3 = Cons2 True (Cons2 False Empty2)

Prelude> print list1
Cons2 3 (Cons2 5 (Cons2 2 Empty2))

Prelude> print list2
Cons2 'x' (Cons2 'y' (Cons2 'z' Empty2))

Prelude> print list3
Cons2 True (Cons2 False Empty2)

Polymorphic Functions
‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾
Now, let's generalize "filterIntList" to work over our new polymorphic Lists. We
can take code of filterIntList, and replace  Empty by Empty2, and Cons by Cons2:

> myList2 :: List Integer
> myList2 = Cons2 2 (Cons2 (-3) (Cons2 5 Empty2))

> filterList' :: (t -> Bool) -> List t -> List t
> filterList' _ Empty2                    = Empty2
> filterList' p (Cons2 x xs) | p x        = Cons2 x (filterList' p xs)
>                            | otherwise  = filterList' p xs

Prelude> print $ filterList' even myList2
Cons2 2 Empty2

Now, what is the type of filterList'? Let's see what type GHCi infers for it:

Prelude> :t filterList'
filterList' :: (t → Bool) → List t → List t

We can read this as:     "for any type t, filterList' takes a function from t to
                          Bool, and a list of t's, and returns a list of t's"

What  about  generalizing mapIntList?   What type should  we give to  a function
mapList that applies a function  to every element in a "List t"? Our first  idea
might be to give it the type:  "mapList :: ( t → t) → List t → List t"
This works, but it means that when applying mapList,   we always get a list with
the same type of elements as the list we started with.   This is overly restric-
tive: we'd like to be able to do things like "mapList show" in order to convert,
let's say, a list of Ints into a list of Strings. Here,then, is the most general
possible type for mapList, along with an implementation:

> mapList' :: (a -> b) -> List a -> List b
> mapList' f (Cons2 x xs) = Cons2 (f x) (mapList' f xs)
> mapList' f Empty2       = Empty2

> double :: Integer -> Integer
> double x = 2 * x

Prelude> print $ mapList' double myList2
Cons2 4 (Cons2 (-6) (Cons2 10 Empty2))

One important thing to  remember about  polymorphic functions is that the caller
gets to pick the types. When you write a  polymorphic function, it must work for
every possible input type. This -together  with the fact that Haskell has no way
to directly make decision based on what type something is-  has some interesting
implications which we will explore later.

The Prelude
‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾
The Prelude is a module with a bunch of standard definitions that  gets implici-
tly imported into every Haskell program. It's worth spending some time  skimming
through its documentation to familiarize oneself with the tools that are availa-
ble. Of course, polymorphic  lists are defined  in the Prelude,  along with many
useful polymorphic functions for working with them.  For example, filter and map
are the counterparts to our filterList and mapList. In fact, the Data.List modu-
le contains many more list functions still.

Another useful polymorphic type to know is Maybe, defines as:

data Maybe a = Nothing | Just a

A value of type "Maybe a" either contains a value of type a (wrapped in the Just
constructor), or it is Nothing (representing some sort of failure or error). The
Data.Maybe module has functions for working with Maybe values.

Total and Partial Functions
‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾
Consider the polymorphic type "[a] → a", what  functions could have such a type?
The type says that given a list of things of type "a", the function must produce
some value of type a. For example, the Prelude function head has this type.  But
what happens if head is  given an empty list as input?  The source code for head 
looks something like this:

head :: [a] → a
head (x:_) = x
head []    = error "head"

It crashes! There's nothing else it possibly could do,since it must work for all
types.There's no way to make up an element of an arbitrary type out of thin air.
"head" is what is known as a partial function:there are certain inputs for which
head will crash. Functions which have certain inputs that will make them recurse
infinitely are also called partial. Functions which are well-defined on all pos-
sible inputs are know as total functions.   It is good Haskell practice to avoid
partial functions as much as possible.   Actually, avoiding partial functions is
good practice in any programming language  -but in most of them it's ridiculous-
ly annoying. Haskell tends to make it quite easy and sensible.

head is a mistake! It should not be in the Prelude. Other partial  Prelude func-
tions you should almost never use include: tail, init, last and (!!). What to do
instead?

Replacing partial functions
‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾



