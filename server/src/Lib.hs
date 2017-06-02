{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DataKinds #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE TypeOperators #-}

module Lib
  ( runApp
  ) where

import Database.MySQL.Simple
import Database.Utils
import Database.Types
import Types.Types

import Prelude ()
import Prelude.Compat

import Control.Monad.Except
import Control.Monad.Reader
import Data.Aeson.Types
import Data.Attoparsec.ByteString
import Data.ByteString (ByteString)
import Data.List
import Data.Maybe
import Data.Text
import Data.String.Conversions
import Data.Time.Calendar
import GHC.Generics
import Lucid
import Network.HTTP.Media ((//), (/:))
import Network.Wai
import Network.Wai.Handler.Warp
import Servant
import System.Directory
import Text.Blaze
import Text.Blaze.Html.Renderer.Utf8
import qualified Data.Aeson.Parser
import qualified Text.Blaze.Html

type PollAPI = "polls" :> "list-all" :> Get '[JSON] [Poll]
  :<|> "polls" :> Capture "name" Text :> Get '[JSON] [Poll]
  :<|> "create-poll" :> ReqBody '[JSON] Poll :> Post '[JSON] Bool

pollAPI :: Proxy PollAPI
pollAPI = Proxy

server :: Server PollAPI
server = getAll
  :<|> getByName
  :<|> create
  where
    conn :: IO Connection
    conn = connect =<< pollConn
    
    getAll :: Handler [Poll]
    getAll = liftIO $ getAllPolls =<< conn

    getByName :: Text -> Handler [Poll]
    getByName name = liftIO $ getPollFromName name =<< conn

    create :: Poll -> Handler Bool
    create poll = liftIO $ insertPoll poll =<< conn


app :: Application
app = serve pollAPI server

runApp :: IO ()
runApp = run 3001 app 
