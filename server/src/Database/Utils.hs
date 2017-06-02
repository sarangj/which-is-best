{-# LANGUAGE OverloadedStrings #-}
module Database.Utils where

import Prelude
import Database.MySQL.Simple
import Database.MySQL.Simple.Param
import Database.MySQL.Simple.QueryParams
import Database.MySQL.Simple.QueryResults
import Database.Types
import Data.Configurator
import Data.Configurator.Types
import Data.Text
import Types.Types

allPolls :: Query
allPolls = 
  "SELECT\
    \ timestamp,\
    \ pollname,\
    \ optiona,\
    \ optionb\
   \ FROM polls"

pollNameQuery :: Query
pollNameQuery = 
  "SELECT\
    \ timestamp,\
    \ pollname,\
    \ optiona,\
    \ optionb\
   \ FROM polls\
   \ WHERE pollname = ?"

insertPollQuery :: Query
insertPollQuery = 
  "INSERT INTO polls (timestamp, pollname, optiona, optionb)\
  \VALUES (?, ?, ?, ?)"

config :: Config
config = Data.Configurator.empty

requireConfigValue :: Configured a => Text -> IO a
requireConfigValue = require config 

pollConn :: IO ConnectInfo
pollConn = mkConnectInfo
  <$> requireConfigValue "host_name"
  <*> requireConfigValue "port"
  <*> requireConfigValue "user"
  <*> requireConfigValue "password"
  <*> requireConfigValue "database"

getAllPolls :: Connection -> IO [Poll]
getAllPolls conn = query_ conn allPolls

getPollFromName :: Text -> Connection -> IO [Poll]
getPollFromName name conn = query conn pollNameQuery [name]

insertPoll :: Poll -> Connection -> IO Bool
insertPoll poll conn = do
  result <- execute conn insertPollQuery poll
  return $ result > 0
