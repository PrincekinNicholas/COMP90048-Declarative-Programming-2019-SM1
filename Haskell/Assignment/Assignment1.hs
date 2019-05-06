module Assignment1 (subst, interleave, unroll) where

subst :: Eq t => t -> t -> [t] -> [t]
subst a b [] = []
subst a b (x:xs) =
    if a == x then
        b:subst a b xs
    else
        x:subst a b xs

interleave :: [t] -> [t] -> [t]
interleave [] [] = []
interleave [] (x:xs) = x:interleave [] xs
interleave (x:xs) [] = x:interleave xs []
interleave (x:xs) (y:ys) = x:y:interleave xs ys

unroll :: Int -> [a] -> [a]
unroll 0 xs = []
unroll b [] = []
unroll b (x:xs) = tmp b (x:xs) (x:xs)

tmp :: Int -> [a] -> [a] -> [a]
tmp 0 xs ys = []
tmp b [] ys = tmp b ys ys
tmp b (x:xs) (y:ys) = x:tmp (b-1) xs (y:ys)