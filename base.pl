% ignore warnings
:- discontiguous(holds/2).
:- discontiguous(is_conditional_negative_effect/3).
:- discontiguous(is_conditional_positive_effect/3).

%% GENERAL SITUATION (problem-specific)
% colors available for rob and bor
color(rob, B) :- member(B, [blue]).
color(bor, B) :- member(B, [red]).

%% TEST SITUATION (problem-specific)
block(B) :- member(B,[a,b,c,d,e,f,g]).
holds(F,s0) :- member(F,[clear(a),on(a,b),on(b,c),ontable(c),ontable(d),on(e,d),on(f,e),clear(f),ontable(g),clear(g)]).
holds(color(B,white),s0) :- block(B).

%% BASE SITUATION (problem-specific)
% block(B) :- member(B, [a, b, c, d]).
% holds(F, s0) :- member(F, [on(a, b), on(b, c), ontable(c), ontable(d), clear(a), clear(d)]).
% holds(color(B, white), s0) :- block(B).

%%%%%%%%%%%%%%%%%%%%%%%%% A S T A R   P A R T  <BONUS> %%%%%%%%%%%%%%%%%%%%%%%%%

%% goal states
%goal_state([on(b,d),on(c,b),on(a,c)]).                             % 1
%goal_state([on(b,d),on(c,b),on(a,c),color(a,red)]).                % 2
goal_state([on(b,d),color(b,blue),on(c,b),on(a,c),color(a,red)]).   % 3

%% TIME
% 1
%   goal_counting:        % 2,500,257 inferences, 0.710 CPU in 0.734 seconds (97% CPU, 3519105 Lips)
%   goal_counting_plus:   % 230,582 inferences, 0.077 CPU in 0.081 seconds (95% CPU, 2983220 Lips)
% 2
%   goal_counting:        % 3,041,925 inferences, 0.866 CPU in 0.892 seconds (97% CPU, 3513281 Lips)
%   goal_counting_plus:   % 341,316 inferences, 0.102 CPU in 0.107 seconds (95% CPU, 3340668 Lips)
% 3
%   goal_counting:        % 4,223,665 inferences, 1.167 CPU in 1.207 seconds (97% CPU, 3620708 Lips)
%   goal_counting_plus:   % 606,858 inferences, 0.162 CPU in 0.169 seconds (96% CPU, 3745575 Lips)

%% heuristics for A*
null_heuristic(_, 0).
goal_counting(State, N) :-
  goal_state(Goal),
  findall(F, (member(F, Goal), \+ member(F, State)), L),
  length(L, N).
goal_counting_plus(State, N) :-
  goal_state(Goal),
  findall(on(A, B),(member(on(A, B), Goal), \+ member(on(A, B), State), member(on(_, B), State)), L1),
  findall(F, (member(F, Goal), \+ member(F, State)), L2),
  append(L1, L2, L),
  length(L, N).
  %write(N), nl.

%astar_heuristic(S, H) :- null_heuristic(S, H).
%astar_heuristic(S, H) :- goal_counting(S, H).
astar_heuristic(S, H) :- goal_counting_plus(S, H).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%% F I R S T   P A R T %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Blocks World Preconditions (domain-specific)

poss(move_to_block(X, Z), S) :-
  holds(clear(X), S),
  holds(clear(Z), S),
  X \= Z.

poss(move_to_table(X), S) :-
  holds(clear(X), S),
  \+ holds(ontable(X), S).

poss(paint(rob, B, C), S) :-
  color(rob, C),
  holds(clear(B), S).

poss(paint(bor, B, C), S) :-
  color(bor, C),
  holds(ontable(B), S).

%% Blocks World Effects (domain-specific)

% move_to_block/2
is_conditional_negative_effect(move_to_block(X, _), on(X, Y), on(X, Y)).
is_conditional_negative_effect(move_to_block(X, _), ontable(X), ontable(X)).
is_conditional_negative_effect(move_to_block(_, Z), true, clear(Z)).

is_conditional_positive_effect(move_to_block(X, _), on(X, Z), clear(Z)).
is_conditional_positive_effect(move_to_block(X, Y), true, on(X, Y)).

% move_to_table/1
is_conditional_negative_effect(move_to_table(X), on(X, Y), on(X, Y)).

is_conditional_positive_effect(move_to_table(X), on(X, Z), clear(Z)).
is_conditional_positive_effect(move_to_table(X), true, ontable(X)).

% paint/3
is_conditional_negative_effect(paint(_, B, C), color(B, L), color(B, L)):-
  C \= L.

is_conditional_positive_effect(paint(_, B, C), true, color(B, C)).

%% Situations' dynamic facts

% "true" always holds
holds(true, s0).

holds(F, do(A, S)) :-
    holds(F, S),
    \+ (is_conditional_negative_effect(A, C, F), holds(C, S)).

holds(F, do(A, S)) :-
    is_conditional_positive_effect(A, C, F), holds(C, S).

% S is legal if it is the result of performing executable actions
legal(s0).
legal(do(A, S)) :-
    legal(S),
    poss(A, S).

%%%%%%%%%%%%%%%%%%%%%%%%%%%% S E C O N D   P A R T %%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Responsabilities (problem-specific)

controllable(A) :-
  member(A, [move_to_block(_, _), move_to_table(_), paint(rob, _, _)]).

uncontrollable(A) :-
  member(A, [paint(bor, _, _)]).

%% Situations' preconditions (domain-specific)

possAll(_, []).
possAll(A, [S|SSet]) :-
  poss(A, S), possAll(A, SSet).

holdsAll(_, []).
holdsAll(F, [S|SSet]) :-
  holds(F, S), holdsAll(F, SSet).

%% Execute turns

turn(agent, Actions, NewActions, SitSet, SitSet2) :-
  controllable(Act), possAll(Act, SitSet),
  findall(do(Act, S), member(S, SitSet), SitSet2),
  append(Actions, [Act], NewActions).

turn(env, SitSet, SitSet2) :-
  findall(do(A, S), (member(S, SitSet), uncontrollable(A), poss(A, S)), SitSetp),
  append(SitSetp, SitSet, SitSet2).

%% Manage execution

plies([], [s0]).
plies(Actions, SitSet) :-
  plies(Acts, SS),
  turn(agent, Acts, Actions, SS, SitSetp),
  turn(env, SitSetp, SitSet).
