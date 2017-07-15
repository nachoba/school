Algebraic Data Types
‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾

Enumeration Types
‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾
Like many  programming languages,  Haskell allows programmer to create their own
enumeration types. Here is a simple example:

> data Thing = Shoe
>            | Ship
>            | SealingWax
>            | Cabbage
>            | King
>  deriving Show

This declares a new type called Thing with five "data constructors": Shoe, Ship,
etc which are the only values of type Thing. The deriving Show is a magical  in-
cantation which tells GHC to automatically generate default code for  converting
Things to Strings.  This is what GHCi uses when printing the value of an expres-
sion of type Thing.

> shoe :: Thing
> shoe = Shoe

> listOfThings :: [Thing]
> listOfThings = [Shoe, SealingWax, King, Cabbage, King]

We can write functions on Things by pattern matching:

> isSmall :: Thing -> Bool
> isSmall Shoe       = True
> isSmall Ship       = False
> isSmall SealingWax = True
> isSmall Cabbage    = True
> isSmall King       = False

This function can be defined a little bit shorter like:

> isSmall' :: Thing -> Bool
> isSmall' Ship  = False
> isSmall' King  = False
> isSmall'    _  = True

Beyond Enumerations
‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾
Thing is an enumeration  type, similar to those provided by other languages such
as Java, C++. However,enumerations are actually only a special case of Haskell's
more general algebraic data types.As a first example of a data type which is not
just an enumeration, consider the definition of FailableDouble:

> data FailableDouble = Failure
>                     | OK Double
>   deriving Show

This says that the FailableDouble type has two data constructors. The first one,
OK, takes an argument  of type Double.  So OK  by itself  is not a value of type
FailableDouble;  we need to give it a Double.  For example, OK 3.4 is a value of
type FailableDouble.

> a = Failure
> b = OK 3.4

1. Exercise: What is the type of OK?
   Prelude> :t OK
   OK :: Double → FailableDouble

For any x of type Double, "OK x" has type FailableDouble. We must therefore have
OK :: Double → FailableDouble

Here is one way we might use our new FailableDouble type:

> safeDiv :: Double -> Double -> FailableDouble
> safeDiv _ 0 = Failure
> safeDiv x y = OK (x / y)

So you can try something like:

Prelude> print $ safeDiv 2 0
Failure
Prelude> print $ safeDiv 3 4
OK 0.75

More pattern matching.Notice how in the OK case we can give a name to the Double
that comes along with it. For  some  applications, we might consider  mapping  a
failed computation to a value of zero:

> failureToZero :: FailableDouble -> Double
> failureToZero Failure  = 0
> failureToZero (OK d)   = d


Prelude> failureToZero Failure
0.0
Prelude> failureToZero (OK 3.4)
3.4

Data constructors can have more than one argument:
‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾

> data Person = Person String Int Thing
>   deriving Show
 
> brent :: Person
> brent = Person "Brent" 30 SealingWax

> stan :: Person
> stan  = Person "Stan"  94 Cabbage

> getAge :: Person -> Int
> getAge (Person _ age _ ) = age

Prelude> print $ getAge brent
30

Notice how the type constructor and data constructor are both named Person,  but
they inhabit different namespaces and are different things.  This idiom  (giving
the type and data constructor of a one-constructor type the same name) is common
but can be confusing until you get used to it.

Algebraic Data Type in General
‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾
In general, an algebraic data type has one or more data constructors,  and  each
date constructor can have zero or more arguments.

data AlgDataType = Constr1 Type11 Type12
                 | Constr2 Type21
                 | Constr3 Type31 Type32 Type 33
                 | Constr4

This  specifies that a  value of type  AlgDataType can be  constructed in one of
four ways Using Constr1, Constr2, Constr3, or Constr4.Depending on the construc-
tor used, an AlgDataType value may contain some other values. For example, if it
was constructed using Constr1,  then it comes along with two values, one of type
Type11 and one of type Type12.
One final note:type and data constructors names must always start with a capital
letter. Otherwise, Haskell parsers would have quite a difficult job figuring out
which names represent variables and which represent constructors.

Pattern Matching
‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾
We've seen pattern matching in a few specific cases, but let us see how pattern-
matching works in general. Fundamentally, pattern matching is about taking apart
a value by finding out which constructor it was built with. This information can
be used as the basis for  deciding what to do  -indeed, in Haskell, this  is the
only way to make a decision.
For example, to decide what to do with a value of type AlgDataType  (the made-up
type defined in the previous section), we could write something lke:

foo (Constr1 a b )   = .....
foo (Constr2 a )     = .....
foo (Constr3 a b c ) = .....
foo  Constr4         = .....

Note how we also get to give names to the values that come along with each cons-
tructor. Note  also that parentheses  are required around patterns consisting of
more than just a single constructor.
This is the main idea behind patterns, but there are a few more things to note.

  * An underscore _ can be used as a "wildcard pattern" which matches anything.
  * A pattern  of the form x@pat  can be used to match a value against the pat-
    tern pat, but also give the  name x to the entire  value being matched. For
    example:

> baz :: Person -> String
> baz p@(Person n _ _ ) = "The name filed of (" ++ show n ++ ") is " ++ n

Prelude> putStrLn $ baz brent
The name field of ("Brent") is Brent

Previously we had used print to display results,  but here we use putStrLn,  be-
cause the value we are displaying is  already a String.  Change the  code to use
print to see the difference.

Prelude> print $ baz brent
"The name field of (\"Brent\") is Brent"

Patterns can be nested. For example:
‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾

> checkFav :: Person -> String
> checkFav (Person n _ SealingWax) = n ++ ", you're my kind of person!"
> checkFav (Person n _          _) = n ++ ", your favorite thing is lame."

Prelude> putStrLn $ checkFav (Person "Brent" 30 SealingWax)
Brent, you're my kind of person!
Prelude> putStrLn $ checkFav (Person "John"  44 King)
John, your favorite thing is lame.

Note how we nest the pattern SealingWax inside the pattern for Person.In general
the following grammar defines what can be used as a pattern:

pat ::= _
      | var
      | var @ ( pat )
      | (Constructor pat1 pat2 ... patn )

* The first line says that an underscore is a pattern.
* The second line says that a variable by itself is a pattern;  such  a  pattern
  matches anything, and "binds" the given variable name to the matched value.
* The third line specifies @ patterns.
* The fourth, and last line, says that a constructor name followed by a sequence
  of patterns is itself a pattern; such a pattern matches  a value if that value
  was constructed using the given constructor,  and pat1  through patn all match 
  the values contained by the constructor, recursively.

In actual fact, the full grammar for patterns  includes yet more features  still, 
but the rest would take us too far afield for now.
Note that literal values like 2 or 'c' can be thought of as constructors with no
arguments. It is as if the types Int and Char were defined like:

data Int  = 0   | 1   | -1  | 2   | -2  | ...
data Char = 'a' | 'b' | 'c' | 'd' | 'e' | ...

Which means that we can pattern-match against literal values. (Of course,Int and
Char are not actually defined this way).

Case Expressions
‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾




