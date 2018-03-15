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
        -> m (Event t [(), ()])
comments = do
  postBuild <- getPostBuild
  commentsEvent <- fmap (fromJust . decodeXhrResponse) <$> performRequestAsync (xhrRequest "GET" "localhost:8080/json" def <$ postBuild)
  for commentsEvent $ comment

comment :: MonadWidget t m
        => Event t Comment
        -> m (Event t ((), ()))
comment commentEvent =
  card [] (Just ("a", Nothing)) (constDyn <$> text "b") ([(Nothing, "Reply", ())])
numberInput :: MonadWidget t m => m (Dynamic t (Maybe Double))
numberInput = do
  n <- Reflex.Dom.textInput
    $ def & textInputConfig_inputType .~ "number"
          & textInputConfig_initialValue .~ "5"
  mapDyn (readMay . T.unpack) $ _textInput_value n
