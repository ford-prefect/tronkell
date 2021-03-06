module Tronkell.Game.Types where

import Control.Monad.State.Strict
import Data.Map
import qualified Data.Text as T

import Tronkell.Types

data GameConfig = GameConfig { gameWidth          :: Int
                             , gameHeight         :: Int
                             , gamePlayerSpeed    :: Int
                             , gameTicksPerSecond :: Int
                             } deriving (Show)

data Game = Game { gameWinner  :: Maybe Player
                 , gamePlayers :: Map PlayerNick Player
                 , gameStatus  :: GameStatus
                 , gameConfig  :: GameConfig
                 } deriving (Show)

data GameStatus = InProgress | Finished
                  deriving (Eq, Enum, Show)

newtype PlayerNick = PlayerNick { getPlayerNick :: T.Text }
                     deriving (Eq, Ord, Show)

data Player = Player { playerNick        :: PlayerNick
                     , playerStatus      :: PlayerStatus
                     , playerCoordinate  :: Coordinate
                     , playerOrientation :: Orientation
                     , playerTrail       :: Trail
                     } deriving (Show)

data PlayerStatus = Alive | Dead
                    deriving (Show, Eq, Enum)

type Trail = [Coordinate]

data InputEvent = Tick
                | TurnLeft  PlayerNick
                | TurnRight PlayerNick
                | PlayerQuit PlayerNick
                deriving (Show)

data OutEvent = PlayerMoved PlayerNick Coordinate Orientation
              | PlayerDied  PlayerNick Coordinate
              | GameEnded   (Maybe PlayerNick)
              deriving (Show, Eq, Ord)

-- type GameEngine = [InputEvent] -> Game -> ([OutEvent], Game)
type GameEngine = [InputEvent] -> State Game [OutEvent]
