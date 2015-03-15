%
%  fox_and_hounds.pl
%
%  Prolog code for solving the Fox & Hounds game:
%
%      http://en.wikipedia.org/wiki/Fox_games#Fox_and_Hounds
%

not_member(_, []).

not_member(X, [F | R]) :-
	not_member(X, R), X \== F.

substitute(_, _, [], []).

substitute(X, Y, [X | RX], [Y | RY]) :-
	substitute(X, Y, RX, RY).

substitute(X, Y, [Z | RX], [Z | RY]) :-
	X \= Z,
	substitute(X, Y, RX, RY).

board_position([X, Y]) :-
	member(X, [1, 2, 3, 4]),
	member(Y, [1, 2, 3, 4, 5, 6, 7, 8]).

board_position_list([]).

board_position_list([First | Rest]) :-
	board_position(First),
	board_position_list(Rest).

positions_uniq([]).

positions_uniq([First | Rest]) :-
	board_position(First),
	board_position_list(Rest),
	not_member(First, Rest),
	positions_uniq(Rest).

board_state([Fox, Hound1, Hound2, Hound3, Hound4]) :-
	positions_uniq([Fox, Hound1, Hound2, Hound3, Hound4]).

board_state_list([]).

board_state_list([First | Rest]) :-
	board_state(First),
	post_state_list(Rest).

%
%  in one variant, the fox's starting position is fixed
%
starting_state([ [1,8], [1,1], [2,1], [3,1], [4,1] ]).

%starting_state([ Fox | Hounds ]) :-
%	Hounds = [ [1,1], [2,1], [3,1], [4,1] ],
%	board_position(Fox),
%	not_member(Fox, Hounds).

%
%  some shared prereqs for valid moves by either player
%
valid_move_([OldPos, NewPos, BoardState]) :-
	board_state(BoardState),
	member(OldPos, BoardState),
	board_position(NewPos),
	OldPos \== NewPos,
	not_member(NewPos, BoardState).

hound_move_([[X1, Y1], [X2, Y2], BoardState]) :-
	valid_move_([[X1, Y1], [X2, Y2], BoardState]),
	Y2 =:= Y1 + 1,
	X2 =:= X1.

hound_move_([[X1, Y1], [X2, Y2], BoardState]) :-
	valid_move_([[X1, Y1], [X2, Y2], BoardState]),
	Y2 =:= Y1 + 1,
	Y1 mod 2 =:= 0,
	X2 =:= X1 - 1.

hound_move_([[X1, Y1], [X2, Y2], BoardState]) :-
	valid_move_([[X1, Y1], [X2, Y2], BoardState]),
	Y2 =:= Y1 + 1,
	Y1 mod 2 =:= 1,
	X2 =:= X1 + 1.

hound_move([Pos1, Pos2, [Fox | Hounds]]) :-
	hound_move_([Pos1, Pos2, [Fox | Hounds]]),
	member(Pos1, Hounds).

fox_move_(M) :-
	hound_move_(M).

fox_move_([[X1, Y1], [X2, Y2], BoardState]) :-
	valid_move_([[X1, Y1], [X2, Y2], BoardState]),
	Y2 =:= Y1 - 1,
	X2 =:= X1.

fox_move_([[X1, Y1], [X2, Y2], BoardState]) :-
	valid_move_([[X1, Y1], [X2, Y2], BoardState]),
	Y2 =:= Y1 - 1,
	Y1 mod 2 =:= 0,
	X2 =:= X1 + 1.

fox_move_([[X1, Y1], [X2, Y2], BoardState]) :-
	valid_move_([[X1, Y1], [X2, Y2], BoardState]),
	Y2 =:= Y1 - 1,
	Y1 mod 2 =:= 1,
	X2 =:= X1 - 1.

fox_move([Pos1, Pos2, [Fox | Hounds]]) :-
	board_state([Fox | Hounds]),
	Pos1 = Fox,
	fox_move_([Pos1, Pos2, [Fox | Hounds]]).

no_hounds_moves_left(BoardState) :-
	hound_move([_, _, BoardState]), !, fail ; true.

no_fox_moves_left(BoardState) :-
	fox_move([_, _, BoardState]), !, fail ; true.

linked_moves([]).

linked_moves([ [P1, P2, State1], [_, _, State2] | Rest ]) :-
	substitute(P1, P2, State1, State2),
	linked_moves(Rest).

alternating_moves([]).

% can end on a hound move if the fox has no moves left
alternating_moves([ Move ]) :-
	hound_move(Move),
	Move = [_, _, BoardState],
	no_fox_moves_left(BoardState).

alternating_moves([ First, Second | Rest ]) :-
	hound_move(First),
	fox_move(Second),
	linked_moves([ First, Second ]),
	alternating_moves(Rest).

game_sequence(S) :-
	S = [ [_, _, BoardState], _ | _ ],
	starting_state(BoardState),
	alternating_moves(S),
	linked_moves(S).

hounds_victory(S) :-
	game_sequence(S),
	last(S, [_, _, FinalState]),
	no_fox_moves_left(FinalState).

fox_victory(S) :-
	game_sequence(S),
	last(S, [_, _, FinalState]),
	no_hounds_moves_left(FinalState).

