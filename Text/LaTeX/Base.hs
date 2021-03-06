
{-# LANGUAGE CPP #-}

{- |
This module exports those minimal things you need
to work with HaTeX. Those things are:

* The 'LaTeX' datatype.

* The '<>' operator, to append 'LaTeX' values.

* The "Text.LaTeX.Base.Render" module, to render a 'LaTeX' value into 'Text'.

* The "Text.LaTeX.Base.Types" module, which contains several types used by
  other modules.

* The "Text.LaTeX.Base.Commands" module, which exports the LaTeX standard commands
  and environments.

* The "Text.LaTeX.Base.Writer" module, to work with the monad interface of the library.

Here is also defined a 'Num' instance for both 'LaTeX' and 'LaTeXT'.
-}
module Text.LaTeX.Base
 ( -- * @LaTeX@ datatype
   LaTeX
   -- * Escaping reserved characters
 , protectString , protectText
   -- * Internal re-exports
 , module Text.LaTeX.Base.Render
 , module Text.LaTeX.Base.Types
 , module Text.LaTeX.Base.Commands
 , module Text.LaTeX.Base.Writer
   -- * External re-exports
   --
   -- | Since the 'Monoid' instance is the only way to append 'LaTeX'
   --   values, a re-export of "Data.Monoid" is given here.
 , module Data.Monoid
#if __GLASGOW_HASKELL__ < 704
 , (<>)
#endif
   ) where

import Text.LaTeX.Base.Syntax (LaTeX (..),(<>),protectString,protectText)
import Text.LaTeX.Base.Class
import Text.LaTeX.Base.Render
import Text.LaTeX.Base.Types
import Text.LaTeX.Base.Commands
import Text.LaTeX.Base.Writer
--
import Data.Monoid

-- Num instances for LaTeX and LaTeXT

-- | Methods 'abs' and 'signum' are undefined. Don't use them!
instance Num LaTeX where
 (+) = TeXOp "+"
 (-) = TeXOp "-"
 (*) = (<>)
 negate = (TeXEmpty -)
 fromInteger = rendertex
 -- Non-defined methods
 abs _    = error "Cannot use \"abs\" Num method with a LaTeX value."
 signum _ = error "Cannot use \"signum\" Num method with a LaTeX value."

-- | Warning: this instance only exist for the 'Num' instance.
instance Monad m => Eq (LaTeXT m a) where
 _ == _ = error "Cannot use \"(==)\" Eq method with a LaTeXT value."

-- | Warning: this instance only exist for the 'Num' instance.
instance Monad m => Show (LaTeXT m a) where
 show _ = error "Cannot use \"show\" Show method with a LaTeXT value."

-- | Methods 'abs' and 'signum' are undefined. Don't use them!
instance Monad m => Num (LaTeXT m a) where
 (+) = liftOp (+)
 (-) = liftOp (-)
 (*) = (>>)
 negate = (mempty -)
 fromInteger = fromLaTeX . fromInteger
 -- Non-defined methods
 abs _    = error "Cannot use \"abs\" Num method with a LaTeXT value."
 signum _ = error "Cannot use \"signum\" Num method with a LaTeXT value."