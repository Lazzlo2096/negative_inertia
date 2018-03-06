module AABB(AABB, fromPhysical, intersectAABBtoAABB) where

import Prelude
import Data.Number (infinity)
import Math (max)
import Types (Physical, Vector, getX, getY)
import Data.Maybe (Maybe(..))

type AABB = {
  top :: Number,
  right :: Number,
  bottom :: Number,
  left :: Number
}

fromPhysical :: Physical -> AABB
fromPhysical x = {  
    top: getY x.pos,
    right: getX x.pos + getX x.size,
    bottom: getY x.pos + getY x.size,
    left: getX x.pos
  }

-- | Separating Axis Theorem to find overlaping AABB of two AABB's
intersectAABBtoAABB :: AABB -> AABB -> Maybe AABB
intersectAABBtoAABB x y
  | x.top > y.bottom = Nothing
  | x.bottom < y.top = Nothing
  | x.left > y.right = Nothing
  | x.right < y.left = Nothing
  | otherwise = Just {
      top: if x.top >= y.top && x.top <= y.bottom then x.top else y.top,
      right: if x.right >= y.left && x.right <= y.right then x.right else y.right,
      bottom: if x.bottom >= y.top && x.bottom <= y.bottom then x.bottom else y.bottom,
      left: if x.left >= y.left && x.left <= y.right then x.left else y.left
    }

-- | *** NOT TESTED ***
-- |
-- | Find intersection time (0..1 inclusive) of moving AABB to static AABB
-- | First argument is velocity of first AABB
-- |
-- | Based on https://www.gamedev.net/articles/programming/general-and-gameplay-programming/swept-aabb-collision-detection-and-response-r3084/
-- |
sweepAABB :: Vector -> AABB -> AABB -> Maybe Number
sweepAABB v a b = Just 1.0
  where
    vx = getX v
    vy = getY v
    xInvEntry = if vx > 0.0 then b.left - a.right else b.right - a.left
    xInvExit = if vx > 0.0 then b.right - a.left else b.left - a.right
    yInvEntry = if vy > 0.0 then b.top - a.bottom else b.bottom - a.top
    yInvExit = if vy > 0.0 then b.bottom - a.top else b.top - a.bottom
    xEntry = if vx == 0.0 then -infinity else xInvEntry / vx
    xExit = if vx == 0.0 then infinity else xInvExit / vx
    yEntry = if vy == 0.0 then -infinity else yInvEntry / vy
    yExit = if vy == 0.0 then infinity else yInvExit / vy
    entryTime = max xEntry yEntry
    exitTime = max xExit yExit
    r = if entryTime > exitTime || xEntry < 0.0 && yEntry < 0.0 || xEntry > 1.0 || yEntry > 1.0
        then Nothing
        else Just entryTime
