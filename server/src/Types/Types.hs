{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE OverloadedStrings #-} 
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE RecordWildCards #-}
{-# LANGUAGE DeriveGeneric #-}
module Types.Types where

import Prelude
import GHC.Generics
import Data.Aeson
import Data.Text 
import Data.Text.Conversions

data Poll = Poll 
  { pollName :: Text
  , firstResponse :: Text
  , secondResponse :: Text
  , timestamp :: Int
  } deriving (Generic, Show, Eq)

instance ToJSON Poll where
  toJSON Poll{..} = object
    [ "name" .= pollName
    , "firstResponse" .= firstResponse
    , "secondResponse" .= secondResponse
    , "timeCreated" .= timestamp
    ]

instance FromJSON Poll
