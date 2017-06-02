{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RecordWildCards #-}
{-# OPTIONS_GHC -fno-warn-orphans #-}
module Database.Types where

import Prelude
import Data.Text.Conversions
import Database.MySQL.Simple
import Database.MySQL.Simple.Param
import Database.MySQL.Simple.Result
import Database.MySQL.Simple.QueryParams
import Database.MySQL.Simple.QueryResults
import Data.Word
import Types.Types

mkConnectInfo 
  :: String
  -> Word16
  -> String
  -> String
  -> String
  -> ConnectInfo
mkConnectInfo host port user password db = ConnectInfo 
  { connectHost = host
  , connectPort = port
  , connectUser = user
  , connectPassword = password
  , connectDatabase = db
  , connectOptions = []
  , connectPath = ""
  , connectSSL = Nothing
  }

instance QueryParams Poll where
  renderParams Poll{..} =  
    [ render timestamp
    , render pollName
    , render firstResponse
    , render secondResponse
    ]

instance QueryResults Poll where
  convertResults [fa, fb, fc, fd] [va, vb, vc, vd] = 
    Poll 
      (convert fb vb)
      (convert fc vc)
      (convert fd vd)
      (convert fa va)
  convertResults fs vs = convertError fs vs 4
