{-|
    Full Name: Nian Li
    Student Id: 819497
    Purpose of the file: 
        This file can be used to guess the correct three-pitch music chord.
        The definition of 'Chord' is a list of Pitch, and its length must be 3

    details:
        The code below are the implementation of The Game of Musician.
        It includes all needed functions, 
            such as feedback, initial guess, next guess, and so on.
        The initial guess is defined as "A1, B2, C3".
        And the initial game state is a list including all possible chords.
        The feedback function is to show the information about 
            correct pitches, notes, and octaves by analysing the given guess.
        The next guess function is to generate a new guess 
            by analysing the previous guess and feedback.
-}
module Proj1 (Pitch, toPitch, feedback, 
            GameState, initialGuess, nextGuess) where

import Data.List
import Data.Maybe
import Data.Function

-- Definition of GameState, a list of chord
type GameState = [[Pitch]]

-- Definition of Note, 
-- the first part of a pitch,
-- should be within ['A'..'G']
type Note = Char 

showNote :: Note -> String
showNote n = [n]

-- Definition of Octave, 
-- the second part of a pitch,
-- should be within ['1'..'3']
type Octave = Char

showOctave :: Octave -> String
showOctave oct = [oct]

-- Definition of Pitch, contain one note and one octave
data Pitch = Pitch Note Octave deriving Eq

{-|
    The 'toPitch' function is used to convert a string to Maybe Pitch.
    It check that is input valid. 
    If not return Nothing; If yes, convert it to a Pitch.
-}
toPitch :: String -> Maybe Pitch
toPitch xs
    | length xs /= 2 = Nothing
    | xs !! 0 >= 'A' && xs !! 0 <= 'G' && xs !! 1 >= '1' && xs !! 1 <= '3' 
        = Just (Pitch (xs !! 0) (xs !! 1))
    | otherwise = Nothing

showPitch :: Pitch -> String
showPitch (Pitch note octave) = (showNote note) ++ (showOctave octave)

instance Show Pitch where show = showPitch 

{-|
    The 'feedback' function returns the feedback message to User.
    It takes 2 arguments: the list of target Pitch, the list of guess Pitch.
    The feedback message contains 3 numbers. 
    They are the number of correct pitches, correct notes, and correct octaves
-}
feedback :: [Pitch] -> [Pitch] -> (Int, Int, Int)
feedback target guess = (correctPitch target guess,
                        correctNote target guess, 
                        correctOctave target guess) 

{-|
    The 'correctPitch' function returns the number of correct pitches.
    It takes 2 arguments: the list of target Pitch, the list of guess Pitch.
-}
correctPitch :: [Pitch] -> [Pitch] -> Int
correctPitch target guess = length (samePart target guess)

{-|
    The 'samePart' function returns the same part between the 2 arguments.
-}
samePart :: [Pitch] -> [Pitch] -> [Pitch]
samePart target guess = filter(\g -> elem g target ) guess

{-|
    The 'restPart' function returns the complement set of the first argument
        within the second argument.
    It takes 2 arguments: a sublist of the list, the list.
-}
restPart :: [Pitch] -> [Pitch] -> [Pitch]
restPart same origin = filter (not . (\o -> elem o same)) origin

{-|
    These 2 functions returns the Note part from a list of Pitch
-}
getNotes :: [Pitch] -> [Note]
getNotes ps = map toNote ps 

toNote :: Pitch -> Note
toNote (Pitch note octave) = note

{-|
    These 2 functions returns the Octave part from a list of Pitch
-}
getOctaves :: [Pitch] -> [Octave]
getOctaves ps = map toOctave ps

toOctave :: Pitch -> Octave
toOctave (Pitch note octave) = octave


{-|
    The 'correctNote' function returns the number of correct pitches.
    It takes 2 arguments: the list of target Pitch, the list of guess Pitch.
-}
correctNote :: [Pitch] -> [Pitch] -> Int
correctNote target guess = countSamePart 
    (sort (getNotes (restPart (samePart target guess) target))) 
    (sort (getNotes (restPart (samePart target guess) guess)))

{-|
    The 'correctOctave' function returns the number of correct pitches.
    It takes 2 arguments: the list of target Pitch, the list of guess Pitch.
-}
correctOctave :: [Pitch] -> [Pitch] -> Int
correctOctave target guess = countSamePart 
    (sort (getOctaves (restPart (samePart target guess) target))) 
    (sort (getOctaves (restPart (samePart target guess) guess)))

{-|
    The 'countSamePart' function returns the number of the same part.
    This function solved the problem that a list contains duplicated elements.
-}
countSamePart :: Ord a => [a] -> [a] -> Int
countSamePart [] ys = 0
countSamePart xs [] = 0
countSamePart (x:xs) (y:ys) 
    | x == y = 1 + countSamePart xs ys
    | x < y = countSamePart xs (y:ys)
    | otherwise = countSamePart (x:xs) ys

{-|
    The 'initGameState' function generate all possible chord and return it.
    It takes no arguments.
    The definition of chord is actually 3 distinct Pitches.
-}
initGameState :: GameState
initGameState = [[p1,p2,p3] | 
    p1 <- allPitch, p2 <- allPitch, p3 <- allPitch, 
    p1 /= p2, p2 /= p3, p1 /= p3]
    where allPitch = [(Pitch note octave) | 
                    note <- ['A'..'G'], octave <- ['1', '2', '3']]

{-|
    The 'initialGuess' returns the first guess and the initial game state.
    It takes no arguments.
-}
initialGuess :: ([Pitch], GameState)
initialGuess = ([fromJust (toPitch "A1"), 
                fromJust (toPitch "B2"), 
                fromJust (toPitch "C3")], 
                initGameState)

{-|
    The 'possibleTargets' function is used to find out all possible guesses 
        which are consistent with the feedback from previous guess 
        within the game state.
    It takes 2 arguements: 
        a pair of the previous guess and the current game state; 
        and the feedback of the previous guess.
-}
possibleTargets :: ([Pitch], GameState) -> (Int, Int, Int) -> GameState
possibleTargets (guess, gameState) fb = 
    filter (\gs -> feedback guess gs == fb) gameState

{-|
    The 'expectedValue' return a pair of a guess(chord) and its expected value
    It takes 2 inputs: The guess, and the current game state
-}
expectedValue :: [Pitch] -> GameState -> ([Pitch], Float)
expectedValue guess gameState = (guess, expVal)
    where 
    expVal = foldr (\x acc -> fromIntegral x^2 / 
                    fromIntegral (sum count) + acc) 0 count
    count = map length (possibleFeedbacks guess gameState)

{-|
    The 'possibleFeedbacks' function returns all possible feedbacks 
        within the current game state, and these feedbacks should be 
        as same as the possible feedback in a specific guess.
    It takes 2 arguments: a guess, and a game state
-}  
possibleFeedbacks :: [Pitch] -> GameState -> [[(Int, Int, Int)]]
possibleFeedbacks guess gameState = group sortedFeedback
    where sortedFeedback = sort (map (\gs -> feedback guess gs) gameState)

{-|
    The 'chooseChord' function is used for choosing the guess(chord) 
        with the smallest expected value
-}
chooseChord :: GameState -> [Pitch]
chooseChord gameState = 
    fst $ minimumBy (compare `on` snd) remainingPossibleTargets
    where remainingPossibleTargets = 
                map (\gs -> expectedValue gs gameState) gameState

{-|
    The 'nextGuess' function returns a pair of next guess and game state
    It takes as input a pair of the previous guess and game state,
        and the feedback to this guess 
        as a triple of correct Pitches, Notes, and Octaves.
-}    
nextGuess :: ([Pitch], GameState) -> (Int, Int, Int) -> ([Pitch], GameState)
nextGuess (guess, gameState) fb = (newGuess, newGameState)
    where 
    remainingTargets = possibleTargets (guess, gameState) fb
    newGuess = chooseChord remainingTargets
    newGameState = delete newGuess remainingTargets