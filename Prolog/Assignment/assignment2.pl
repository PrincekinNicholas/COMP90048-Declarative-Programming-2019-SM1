:- use_module(library(clpfd)).

correspond(E1, [E1|_], E2, [E2|_]).
correspond(E1, [_|XS], E2, [_|YS]):-
    correspond(E1, XS , E2, YS).


% interleave([[]|_], []).
% interleave(Ls, L):-
%     sameLengthHelper(Ls, _),
%     helper(Ls, Col, Rest),
%     interleave(Rest, List),
%     append(Col, List, L).

% helper([], [], []).
% helper([[HH| HT]| T], [HH| Col], [HT|Rest]):-
%     helper(T, Col, Rest).

interleave(Ls, L):-
    sameLengthHelper(Ls, _),
    transpose(Ls, List),
    flatten(List, L),!.

sameLengthHelper([],_).
sameLengthHelper([H|T], Length):-
    length(H, Length),
    sameLengthHelper(T, Length).


partial_eval(Num, _ , _, Num):- 
    number(Num).

partial_eval(Var, Var, Val, Val):-
    atom(Var).
partial_eval(Exp, Var, _, Exp):-
    atom(Exp),
    Exp \= Var.

partial_eval(X+Y, Var, Val, Exp):-
    partial_eval(X, Var, Val, Ex),
    partial_eval(Y, Var, Val, Ey),
    number(Ex),
    number(Ey),!,
    Exp is Ex + Ey.
partial_eval(X+Y, Var, Val, Exp):-
    partial_eval(X, Var, Val, Ex),
    partial_eval(Y, Var, Val, Ey),
    Exp = Ex + Ey.

partial_eval(X-Y, Var, Val, Exp):-
    partial_eval(X, Var, Val, Ex),
    partial_eval(Y, Var, Val, Ey),
    number(Ex),
    number(Ey),!,
    Exp is Ex - Ey.
partial_eval(X-Y, Var, Val, Exp):-
    partial_eval(X, Var, Val, Ex),
    partial_eval(Y, Var, Val, Ey),
    Exp = Ex - Ey.

partial_eval(X*Y, Var, Val, Exp):-
    partial_eval(X, Var, Val, Ex),
    partial_eval(Y, Var, Val, Ey),
    number(Ex),
    number(Ey),!,
    Exp is Ex * Ey.
partial_eval(X*Y, Var, Val, Exp):-
    partial_eval(X, Var, Val, Ex),
    partial_eval(Y, Var, Val, Ey),
    Exp = Ex * Ey.

partial_eval(X/Y, Var, Val, Exp):-
    partial_eval(X, Var, Val, Ex),
    partial_eval(Y, Var, Val, Ey),
    number(Ex),
    number(Ey),!,
    Exp is Ex / Ey.
partial_eval(X/Y, Var, Val, Exp):-
    partial_eval(X, Var, Val, Ex),
    partial_eval(Y, Var, Val, Ey),
    Exp = Ex / Ey.

partial_eval(X//Y, Var, Val, Exp):-
    partial_eval(X, Var, Val, Ex),
    partial_eval(Y, Var, Val, Ey),
    number(Ex),
    number(Ey),!,
    Exp is Ex // Ey.
partial_eval(X//Y, Var, Val, Exp):-
    partial_eval(X, Var, Val, Ex),
    partial_eval(Y, Var, Val, Ey),
    Exp = Ex // Ey.

