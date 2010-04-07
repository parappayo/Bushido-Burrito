%
%  ramble.pl
%
%  Fun with grammars in Prolog
%
%  Usage examples:
%      noun_phrase(X, []).
%      verb_phrase(X, []).
%

noun( [X | Rest], Rest) :-
	random_member(
		[
			ninja,
			cheeze,
		       	fart,
		        program,
		       	ukulele
		],
		X).

adjective( [X | Rest], Rest) :-
	random_member(
		[
	       		violent,
		       	rancid,
		       	eloquent,
		       	silly,
		       	jazzy
		],
		X).

determiner( [X | Rest], Rest) :-
	random_member(
		[
	       		a,
		       	the
		],
		X).

verb( [X | Rest], Rest) :-
	random_member(
		[
	       		embrace,
		       	destroy,
		       	admire,
		       	critique,
		       	abolish
		],
		X).

noun_phrase --> determiner, adjective, noun.
verb_phrase --> verb, noun_phrase.

% nth - find the indexed member of a list
nth( [First | _], 0, First).
nth( [_ | Rest], Index, X) :-
	Index > 0,
	Index1 is Index-1,
	nth(Rest, Index1, X).

% random_member - X is a randomly chosen member in List
random_member( List, X ) :-
	length(List, Len),
	R is random(Len),
	nth(List, R, X).

