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

import           Control.Applicative ((<*>), (<$>))
import           Control.Monad
import Control.Monad.IO.Class
import qualified Data.Map as Map
import           Data.Maybe
import           Data.Monoid
import qualified Data.Text as T
import           Data.Text.Lazy (toStrict)
import           Data.Time.Clock
import           Data.Traversable
import           MySC.Common.DB.Types
import           Reflex
import           Reflex.Bulma
import           Reflex.Dom hiding (textInput)
import           Safe (readMay)

import           GHCJS.DOM
import           GHCJS.DOM.JSFFI.Generated.Document
import           GHCJS.DOM.JSFFI.Generated.NonElementParentNode

main = withJSContextSingletonMono $ \jsSing -> do
  doc <- currentDocumentUnchecked
  body <- getElementByIdUnchecked doc ("comments" :: T.Text)
  attachWidget body jsSing widget

widget :: MonadWidget t m
       => m ()
widget = do
  comments
  postComment
  pure ()

postComment :: MonadWidget t m
            => m ()
postComment = void $ do
  card [] $ \header body footer -> do
    header $ \title _ -> title "Post Comment"
    comment <- body   $ _textInput_value <$> textInput [] ""
    click   <- footer $ \item -> item () "Post"

    commentE' <- performEvent $
      ffor (tagDyn comment click) $ \commentText ->
        ffor (liftIO getCurrentTime) $ \time ->
          Comment "Sample" commentText 1 time Nothing Nothing
    performRequestAsync $ postJson "/" <$> commentE'

comments :: MonadWidget t m
         => m ()
comments = void $ do
  postBuild <- getPostBuild
  commentsEvent <- getAndDecode ("/json" <$ postBuild)
  widgetHold (pure []) $ fmap (maybe (pure []) (traverse comment)) commentsEvent

comment :: MonadWidget t m
        => (CommentId, Comment)
        -> m ()
comment (commentId, comment) = void $ do
  card [] $ \header body footer -> do
    header $ \title _ -> title "Comment"
    body   $ text $ commentContent comment
    footer $ \item    -> item Nothing "Reply"
