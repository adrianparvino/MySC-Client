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

import Reflex
import Reflex.Dom
import Reflex.Bulma
import qualified Data.Map as Map
import Safe (readMay)
import qualified Data.Text as T
import Data.Text.Lazy (toStrict)
import Control.Applicative ((<*>), (<$>))
import Data.Monoid
import Clay hiding ((&))

import GHCJS.DOM
import GHCJS.DOM.JSFFI.Generated.Document
import GHCJS.DOM.JSFFI.Generated.NonElementParentNode

import qualified CSS as CSS

main = do
  print "Hello World!"
  withJSContextSingletonMono $ \jsSing -> do
    doc <- currentDocumentUnchecked
    headElement <- getHeadUnchecked doc
    attachWidget headElement jsSing headWidget
    -- body <- getBodyUnchecked doc
    body <- getElementByIdUnchecked doc ("content-thingy" :: T.Text)
    attachWidget body jsSing widget
  
widget = el "div" $ do
  nx <- numberInput
  text " + "
  ny <- numberInput
  text " = "
  result <- combineDyn (\x y -> (+) <$> x <*> y) nx ny
  resultString <- mapDyn (T.pack . show) result
  dynText resultString

numberInput :: MonadWidget t m => m (Dynamic t (Maybe Double))
numberInput = do
  n <- Reflex.Dom.textInput
    $ def & textInputConfig_inputType .~ "number"
          & textInputConfig_initialValue .~ "5"
  mapDyn (readMay . T.unpack) $ _textInput_value n


headWidget :: MonadWidget t m => m ()
headWidget = do
  el "style" . text . toStrict . render $ CSS.css
  elAttr "link" ("href" =: "https://fonts.googleapis.com/css?family=Pacifico" <> "rel" =: "stylesheet") $ return ()
  elAttr "link" ("href" =: "https://cdnjs.cloudflare.com/ajax/libs/bulma/0.4.1/css/bulma.min.css" <> "rel" =: "stylesheet") $ return ()
  elAttr "script" ("src" =: "https://use.fontawesome.com/bc68209d19.js") $ return ()
