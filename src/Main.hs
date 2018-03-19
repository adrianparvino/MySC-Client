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
import           Reflex.Dom
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
  commentTextE' <- card []
                        (Just ("Comment", Nothing))
                        (_textInput_value <$> Reflex.Bulma.textInput [] "")           
                        (constDyn [(Nothing, "Post", ())])
  currentTime <- performEvent $ fmap (\(commentText, _) -> 
                                        (,) commentText <$> liftIO getCurrentTime) 
                                     commentTextE'
  let commentE' = (\(commentText, time) ->
                     Comment "Sample"
                             commentText
                             1
                             time
                             Nothing
                             Nothing) <$> currentTime
  performRequestAsync $ postJson "/" <$> commentE'
    where
     toComment time (commentText, _) = 
       Comment 
         "Sample"
         commentText
         1
         time
         Nothing
         Nothing
  
comments :: MonadWidget t m
         => m (Dynamic t [Event t (((), CommentId))])
comments = do
  postBuild <- getPostBuild
  commentsEvent <- getAndDecode ("/json" <$ postBuild)
  widgetHold (pure []) $ fmap (maybe (pure []) (traverse comment)) commentsEvent

comment :: MonadWidget t m
        => (CommentId, Comment)
        -> m (Event t ((), CommentId))
comment (commentid, comment) =
  card [] (Just (commentName comment, Nothing)) (constDyn () <$ (text $ commentContent comment)) (constDyn [(Nothing, "Reply", commentid)])
