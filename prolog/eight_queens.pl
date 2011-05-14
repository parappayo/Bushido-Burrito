%
%  From my blog post - http://www.elenkist.com/bushido_burrito/blog/?p=10
%

% determines if the given position is a valid position for a queen
 
queen_position([X, Y]) :-
    member(X, [1, 2, 3, 4, 5, 6, 7, 8]),
    member(Y, [1, 2, 3, 4, 5, 6, 7, 8]).
 
% determines if the given list is a proper format to be a solution
% to the Eight Queens Puzzle
 
solution_format([ [1, _], [2, _],  [3, _],  [4, _],
                  [5, _], [6, _],  [7, _],  [8, _] ]).
 
% determines if the given positions are not attacking each other
 
not_pos_attacking([X1, Y1], [X2, Y2]) :-
    Y1 =\= Y2,
    Y2 - Y1 =\= X2 - X1,
    Y2 - Y1 =\= X1 - X2.

% no_attack_list determines if any combination of queen positions
% in the list can attack each other and passes only if none can
 
no_attack_list([]).
 
no_attack_list([First | Rest]) :-
    no_attack_list(Rest),
    no_attack_check(First, Rest).
 
% no_attack_check checks the queen position in the first argument
% against the list of queen positions in the second argument and
% passes only if the first argument cannot attack any of the
% positions in the given list
 
no_attack_check(_, []).
 
no_attack_check(First, [Second | Rest]) :-
    no_attack_check(First, Rest),
    queen_position(First),
    queen_position(Second),
    not_pos_attacking(First, Second).
 
% determines if the given list solves the Eight Queens Puzzle
 
eight_queens(S) :- 
    solution_format(S),
    no_attack_list(S).

