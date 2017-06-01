{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RecordWildCards #-}
module Database.Types where

import Prelude
import Data.Text.Conversions
import Database.MySQL.Simple
import Database.MySQL.Simple.Param
import Database.MySQL.Simple.Result
import Database.MySQL.Simple.QueryParams
import Database.MySQL.Simple.QueryResults
import Types.Types

-- This info is fake for now.  TODO: move this to an unversioned config
pollConn :: ConnectInfo
pollConn = ConnectInfo 
  { connectHost = "blah"
  , connectPort = 0
  , connectUser = "blah"
  , connectPassword = "password"
  , connectDatabase = "db"
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
