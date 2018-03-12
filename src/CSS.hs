{-# LANGUAGE OverloadedStrings #-}

module CSS where

import Clay

css :: Css
css = do
  ".center-text" ? do
    textAlign . alignSide $ sideCenter
  ".full-height" ? do
    height $ vh 100
  ".card" ? do
    display $ flex
    flexDirection $ column
  ".card" |> ".card-header" ? do
    flexGrow $ 0
  ".card" |> ".card-content" ? do
    flexGrow $ 1
  ".card" |> ".card-footer" ? do
    flexGrow $ 0
    
