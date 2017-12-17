{-# LANGUAGE OverloadedStrings #-}
module Database.Utils 
  ( insertPoll
  , getAllPolls
  , getPollFromName
  , withConn
  ) where

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

withConn :: (Connection -> IO a) -> IO a
withConn f = f =<< connect =<< pollConn

getAllPolls :: Connection -> IO [Poll]
getAllPolls conn = query_ conn allPolls

getPollFromName :: Text -> Connection -> IO [Poll]
getPollFromName name conn = query conn pollNameQuery [name]

insertPoll :: Poll -> Connection -> IO Bool
insertPoll poll conn = do
  result <- execute conn insertPollQuery poll
  return $ result > 0

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

getConfig :: IO Config
getConfig = load [Required "$(WIB_DIR)/configuration/db_connection.cfg"] 

pollConn :: IO ConnectInfo
pollConn = do 
  conf <- getConfig
  mkConnectInfo
    <$> require conf "host_name"
    <*> require conf "port"
    <*> require conf "user"
    <*> require conf "password"
    <*> require conf "database"
