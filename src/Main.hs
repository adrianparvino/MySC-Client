-- | This file is part of MySC.
-- |
-- | MySC is free software: you can redistribute it and/or modify
-- | it under the terms of the GNU General Public License as published by
-- | the Free Software Foundation, either version 3 of the License, or
-- | (at your option) any later version.
-- |
-- | MySC is distributed in the hope that it will be useful,
-- | but WITHOUT ANY WARRANTY; without even the implied warranty of
-- | MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- | GNU General Public License for more details.
-- |
-- | You should have received a copy of the GNU General Public License
-- | along with MySC.  If not, see <http://www.gnu.org/licenses/>.

{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DataKinds #-}
{-# LANGUAGE ScopedTypeVariables #-}

module Main where

import MySC.Common.DB.Types
import Reflex
import Reflex.Dom
import Reflex.Bulma
import qualified Data.Map as Map
import Safe (readMay)
import qualified Data.Text as T
import Data.Text.Lazy (toStrict)
import Control.Applicative ((<*>), (<$>))
import Data.Monoid
import Data.Maybe
import Data.Traversable

import GHCJS.DOM
import GHCJS.DOM.JSFFI.Generated.Document
import GHCJS.DOM.JSFFI.Generated.NonElementParentNode

main = withJSContextSingletonMono $ \jsSing -> do
  doc <- currentDocumentUnchecked
  body <- getElementByIdUnchecked doc ("comments" :: T.Text)
  attachWidget body jsSing comments
            
comments :: MonadWidget t m
         => m ()
--         -> m (Dynamic t [Event t [((), ())]])
comments = do
  postBuild <- getPostBuild
  commentsEvent <- getAndDecode ("/json" <$ postBuild)
  widgetHold (return []) $ fmap (maybe (return []) (traverse comment)) commentsEvent
  return ()

comment :: MonadWidget t m
        => (CommentId, Comment)
        -> m (Event t ((), CommentId))
comment (commentid, comment) =
  card [] (Just (commentName comment, Nothing)) (constDyn () <$ (text $ commentContent comment)) ([(Nothing, "Reply", commentid)])
