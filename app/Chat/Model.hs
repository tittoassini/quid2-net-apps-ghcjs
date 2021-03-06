{-# LANGUAGE DeriveGeneric ,DeriveAnyClass ,FlexibleInstances #-}
module Chat.Model where

import  ZM

-- We need to derive instances for Flat (binary serialisation so that our values can be tranferred on the network)
-- and Model (so that their structure can be picked up by the system)
-- both instances are derived automatically provided that our data type derive Generic

-- Data model for a simple chat system
data Message = Message {fromUser::User
                       ,subject::Subject
                       ,content::Content User Message}
             deriving (Eq, Ord, Read, Show, Generic, Flat, Model)

data User = User {userName::String} deriving (Eq, Ord, Read, Show, Generic, Flat, Model)

-- Hierarchical subject
-- Example: Subject ["Haskell","Meeting","Firenze"]
data Subject = Subject [String] deriving (Eq, Ord, Read, Show, Generic, Flat, Model)

-- Different kinds of contents
data Content user message =
             -- Basic text message
             TextMessage String

             -- Some extensions that we might implement during the meeting:

             -- Retrieve the subject being discussed
             | AskSubSubjects

             -- A system to track users that are following the current subject
             | Join
             | Leave
             | Ping          -- Signal that we are still connected
             | AskUsers      -- Ask for list of users
             | Users [user]  -- Return list of users

             -- Retrieve recent messages
             | AskHistory         -- Ask
             | History [message]  -- Return last messages

             -- Haskell queries
             -- | HaskellSearch String
             -- | HaskellExpression String

             -- and so on ...

             deriving (Eq, Ord, Read, Show, Generic) -- , Flat)

instance Flat (Content User Message)

-- We need to derive this explicitly, because of a limitation of 'model'
instance (Model a,Model b) => Model (Content a b)
