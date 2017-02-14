{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DuplicateRecordFields #-}
{-# LANGUAGE RecordWildCards #-}
{-# LANGUAGE NamedFieldPuns #-}
module App.API where

import           Control.Lens hiding ((.=), elements)
import           Control.Concurrent.MVar
import           Control.Monad.IO.Class
import           Data.HashMap.Lazy (HashMap)
import qualified Data.HashMap.Lazy as HashMap
import           Network.Wai
import           Servant

import           App.Types
import           App.Model

-- * API

appApi :: Proxy AppAPI
appApi = Proxy

-- TODO: add delete

type AppAPI =
  "todos" :> (
         ReqBody '[JSON] Todo :> Post '[JSON] TodoId
    :<|> Get '[JSON] (HashMap TodoId Todo)
    :<|> Capture "id" TodoId :> Get '[JSON] Todo
    :<|> Capture "id" TodoId :> Delete '[JSON] TodoId
  )

data Endpoints = Endpoints {
  createTodo :: Todo -> Handler TodoId,
  findTodo :: TodoId -> Handler Todo,
  fetchTodos :: Handler (HashMap TodoId Todo),
  deleteTodo :: TodoId -> Handler TodoId
}

toAppServer :: Endpoints -> Server AppAPI
toAppServer Endpoints{..} =
       createTodo
  :<|> fetchTodos
  :<|> findTodo
  :<|> deleteTodo

-- * Endpoints

makeEndpoints :: MockDB -> IO Endpoints
makeEndpoints db = do
  dbRef <- newMVar db
  let findTodo :: TodoId -> Handler Todo
      findTodo todoId = do
        MkMockDB { todos } <- liftIO $ readMVar dbRef
        case HashMap.lookup todoId todos of
          Nothing -> throwError err404
          Just todo -> return todo

      fetchTodos :: Handler (HashMap TodoId Todo)
      fetchTodos = do
        MkMockDB { todos } <- liftIO $ readMVar dbRef
        return todos

      createTodo :: Todo -> Handler TodoId
      createTodo todo = liftIO $ modifyMVar dbRef $ return . dbAddTodo todo

      deleteTodo :: TodoId -> Handler TodoId
      deleteTodo todoId = do
        MkMockDB { todos } <- liftIO $ readMVar dbRef
        case HashMap.lookup todoId todos of
          Nothing -> throwError err404
          Just todo -> liftIO $ modifyMVar dbRef $ return . dbDeleteTodo todoId

  return $ Endpoints {..}
