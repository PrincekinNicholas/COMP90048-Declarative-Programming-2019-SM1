/**
 * 
 * Full Name: Nian Li
 * Student Id: 819497
 * Purpose of the file: 
 *     To solve the problem of math grid, as shown below:
 *     Here is an example puzzle as posed (left) and solved (right):
 *       ____ ____ ____ ____    ____ ____ ____ ____ 
 *      |    | 14 | 10 | 35 |  |    | 14 | 10 | 35 |
 *      | 14 |    |    |    |  | 14 |  7 |  2 |  1 |
 *      | 15 |    |    |    |  | 15 |  3 |  7 |  5 |
 *      | 28 |    |    |    |  | 28 |  1 |  1 |  7 |
 *       ____ ____ ____ ____    ____ ____ ____ ____   
 *     
 * details:
 * 
 *  A maths puzzle is a square grid of squares, each to be filled in 
 *          with a single digit 1 – 9 (zero is not permitted)
 *          satisfying these constraints:
 *  - each row and each column contains no repeated digits;
 *  - all squares on the diagonal line from upper left to lower right 
 *          contain the same value; and
 *  - the heading of reach row and column (leftmost square in a row and 
            topmost square in a column) holds either the sum or the product 
            of all the digits in that row or column.
 * 
 * Note that the row and column headings are not considered to be part of 
 *     the row or column, and so may be filled with a number larger than 
 *     a single digit. The upper left corner of the puzzle is not meaningful.
 *
 * When the puzzle is originally posed, most or all of the squares
 *     will be empty, with the headings filled in. The goal of the puzzle
 *     is to fill in all the squares according to the rules. 
 *     A proper maths puzzle will have at most one solution.
 * 
 */

:- use_module(library(clpfd)).


/*
The function puzzle_solution/1 takes a Puzzle 
    which includes an extra row and an extra column for headers,
    and information of grid which needs to follow some constraints.
The argument Puzzle is actually a list of lists.
The function puzzle_solution/1 would firstly ascertain 
    the equal length of the puzzle by using maplist/2. 
Then, making sure all elements in the Puzzle are digits 
    and obey the 3 constraints which are specified above.
Finally, grounding them if the variables are limited 
    to domains that satisfy these constraints.
*/
puzzle_solution(Puzzle):-
    maplist(same_length(Puzzle), Puzzle),
    diagonalRule(Puzzle),
    noRepeatRule(Puzzle),
    mathRule(Puzzle),
    termGround(Puzzle).

/*
This function is to ensure that all terms are ground.
the function termGround/1 takes a Puzzle 
and holds when all of the variables in the puzzle are ground.
*/
termGround([_Headingrow|Rows]) :- maplist(label, Rows).

/*
Both functions diagonalRule/1 and diagonalRuleHelper/3 are making sure 
    that all squares on the diagonal line from upper left 
    to lower right contain the same value.
*/
diagonalRule([_|Rest]):-
    diagonalRuleHelper(Rest, 1, _).

diagonalRuleHelper([],_,_).
diagonalRuleHelper([List|Rest], Index, Element):-
    nth0(Index, List, Element),
    NewIndex is Index +1,
    diagonalRuleHelper(Rest, NewIndex, Element).


/*
The following functions are implemented for the constraint that
    each row and each column contains no repeated digits.
*/
noRepeatRule(Ls):-
    checkCol(Ls),
    checkRow(Ls).

/*
The following 2 functions are checking cols and rows respectively.
*/
checkCol(Ls):-
    transpose(Ls, Transpose),
    checkRow(Transpose).

checkRow([_|Rest]):-
    removeFstElem(Rest).

/* the function removeFstElem/1 is to remove the header. */
removeFstElem([]).
removeFstElem([[_|Tail]|Rest]):-
    checkDiff(Tail),
    removeFstElem(Rest).
    
/*
The function checkDiff/1 takes a List as the arguement.
And it check that are all elements in the list different.
*/
checkDiff([]).    
checkDiff([First|Rest]):-
    different_from(Rest,First),
    checkDiff(Rest).

/*
This function different_from/2 takes a List and a Element.
It will check is this Element different with all elements within the List.
*/
different_from([], _).
different_from([H|T], E) :- E \= H, different_from(T, E).


/*
The following functions are implemented for the constraint that
    the heading of reach row and column 
    (leftmost square in a row and topmost square in a column) 
    holds either the sum or the product of all the digits 
    in that row or column.
*/
mathRule(Ls):-
    mathInCol(Ls),
    mathInRow(Ls).

/*
The following 2 functions are checking cols and rows respectively.
*/
mathInCol(Ls):-
    transpose(Ls, Transpose),
    mathInRow(Transpose).

mathInRow([_|Rest]):-
    sumOrProduct(Rest).

/*
The function sumOrProduct/1 is to check 
    wether Sum or Product operation are used.
*/
sumOrProduct([]).
sumOrProduct([[Header|Tail]|Rest]):-
    sumOfList(Tail, Header),
    sumOrProduct(Rest);
    productOfList(Tail, Header),
    sumOrProduct(Rest).

/*
The function sumOfList/2 takes a List and a Number.
It would sum all elements in the list,
    and check is it equal to the Number.
*/
sumOfList([Num], Num).
sumOfList([Num1, Num2| Rest], Total):-
    Sum is Num1+Num2,
    sumOfList([Sum| Rest], Total).

/*
The function productOfList/2 takes a List and a Number.
It would computer the product of all elements in the list,
    and check is it equal to the Number.
*/
productOfList([Num], Num).
productOfList([Num1, Num2| Rest], Total):-
    Product is Num1*Num2,
    productOfList([Product| Rest], Total).