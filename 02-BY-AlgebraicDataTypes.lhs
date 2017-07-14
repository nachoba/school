Algebraic Data Types
--------------------------------------------------------------------------------

Enumeration Types
--------------------------------------------------------------------------------
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
--------------------------------------------------------------------------------
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

