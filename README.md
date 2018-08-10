# Bloques Cooperativos y Competitivos

**Autor:** Franco Méndez Zamorano

**Fecha:** 2017-2

---

- Parte 1 :white_check_mark:
- Parte 2 :white_check_mark:
- Bonus   :white_check_mark::grin:

## Tests

```prolog
%% Object Declaration (problem-specific)
block(B) :- member(B,[a,b,c,d,e,f,g]).

color(rob, B) :- member(B, [blue]).
color(bor, B) :- member(B, [red]).

%% Initial Situation (problem-specific)
holds(F,s0) :- member(F,[clear(a),on(a,b),on(b,c),ontable(c),ontable(d),on(e,d),on(f,e),clear(f),ontable(g),clear(g)]).
holds(color(B,white),s0) :- block(B).
```

### Parte 1

```prolog
?- time((legal(S),holds(on(b,d),S),holds(on(c,b),S),holds(on(a,c),S))).
% 116,540 inferences, 0.022 CPU in 0.023 seconds (98% CPU, 5278797 Lips)
S = do(move_to_block(a, c), do(move_to_block(c, b), do(move_to_block(b, d), do(move_to_table(a), s0)))) ;
% 331,773 inferences, 0.069 CPU in 0.070 seconds (98% CPU, 4837117 Lips)
S = do(move_to_block(a, c), do(move_to_block(c, b), do(move_to_block(b, d), do(move_to_table(a), do(move_to_block(a, d), s0))))) .
```

```prolog
?- time((legal(S),holds(color(d,blue),S),holds(on(b,d),S),holds(color(b,red),S),holds(ontable(d),S))).
% 1,898,805 inferences, 0.373 CPU in 0.376 seconds (99% CPU, 5089170 Lips)
S = do(move_to_block(b, d), do(paint(bor, b, red), do(paint(rob, d, blue), do(move_to_table(b), do(move_to_table(a), s0))))) ;
% 124,785 inferences, 0.023 CPU in 0.024 seconds (99% CPU, 5310678 Lips)
S = do(move_to_block(b, d), do(paint(rob, d, blue), do(paint(bor, b, red), do(move_to_table(b), do(move_to_table(a), s0))))) .
```

```prolog
?- time((legal(S),holds(color(c,blue),S),holds(on(b,c),S),holds(color(b,red),S),holds(color(d,red),S))).
% 9,833,734 inferences, 1.896 CPU in 1.907 seconds (99% CPU, 5186785 Lips)
S = do(move_to_block(b, c), do(paint(bor, b, red), do(paint(bor, d, red), do(paint(rob, c, blue), do(move_to_table(b), do(move_to_block(a, d), s0)))))) ;
% 8,329 inferences, 0.002 CPU in 0.002 seconds (97% CPU, 3943655 Lips)
S = do(paint(bor, d, red), do(move_to_block(b, c), do(paint(bor, b, red), do(paint(rob, c, blue), do(move_to_table(b), do(move_to_block(a, d), s0)))))) .
```

### Parte 2

```prolog
?- time((plies(Actions,SitSet),holdsAll(color(c,blue),SitSet))).
% 567,975 inferences, 0.110 CPU in 0.112 seconds (98% CPU, 5150346 Lips)
Actions = [move_to_block(a, d), move_to_block(b, a), move_to_block(c, b), paint(rob, c, blue)],
SitSet = [do(paint(bor, d, red), do(paint(rob, c, blue), do(paint(bor, d, red), do(move_to_block(c, b), do(paint(bor, c, red), do(move_to_block(b, a), do(paint(bor, c, red), do(move_to_block(..., ...), s0)))))))), do(paint(bor, d, red), do(paint(rob, c, blue), do(paint(bor, d, red), do(move_to_block(c, b), do(paint(bor, d, red), do(move_to_block(b, a), do(paint(..., ..., ...), do(..., ...)))))))), do(paint(bor, d, red), do(paint(rob, c, blue), do(paint(bor, d, red), do(move_to_block(c, b), do(paint(bor, c, red), do(move_to_block(..., ...), do(..., ...))))))), do(paint(bor, d, red), do(paint(rob, c, blue), do(paint(bor, d, red), do(move_to_block(c, b), do(paint(..., ..., ...), do(..., ...)))))), do(paint(bor, d, red), do(paint(rob, c, blue), do(paint(bor, d, red), do(move_to_block(..., ...), do(..., ...))))), do(paint(bor, d, red), do(paint(rob, c, blue), do(paint(..., ..., ...), do(..., ...)))), do(paint(bor, d, red), do(paint(..., ..., ...), do(..., ...))), do(paint(..., ..., ...), do(..., ...)), do(..., ...)|...] ;
% 1,358,244 inferences, 0.265 CPU in 0.269 seconds (98% CPU, 5119364 Lips)
Actions = [move_to_block(a, d), move_to_table(b), move_to_block(c, a), paint(rob, c, blue)],
SitSet = [do(paint(bor, d, red), do(paint(rob, c, blue), do(paint(bor, d, red), do(move_to_block(c, a), do(paint(bor, c, red), do(move_to_table(b), do(paint(bor, c, red), do(move_to_block(..., ...), s0)))))))), do(paint(bor, b, red), do(paint(rob, c, blue), do(paint(bor, d, red), do(move_to_block(c, a), do(paint(bor, c, red), do(move_to_table(b), do(paint(..., ..., ...), do(..., ...)))))))), do(paint(bor, d, red), do(paint(rob, c, blue), do(paint(bor, b, red), do(move_to_block(c, a), do(paint(bor, c, red), do(move_to_table(...), do(..., ...))))))), do(paint(bor, b, red), do(paint(rob, c, blue), do(paint(bor, b, red), do(move_to_block(c, a), do(paint(..., ..., ...), do(..., ...)))))), do(paint(bor, d, red), do(paint(rob, c, blue), do(paint(bor, d, red), do(move_to_block(..., ...), do(..., ...))))), do(paint(bor, b, red), do(paint(rob, c, blue), do(paint(..., ..., ...), do(..., ...)))), do(paint(bor, d, red), do(paint(..., ..., ...), do(..., ...))), do(paint(..., ..., ...), do(..., ...)), do(..., ...)|...] .
```

```prolog
?- time((plies(Actions,SitSet),holdsAll(color(c,blue),SitSet))).
% 12,202,176 inferences, 2.325 CPU in 2.377 seconds (98% CPU, 5247501 Lips)
Actions = [move_to_block(a, f), move_to_block(b, a), move_to_block(c, g), paint(rob, c, blue)],
SitSet = [do(paint(bor, d, red), do(paint(rob, c, blue), do(paint(bor, d, red), do(move_to_block(c, g), do(paint(bor, c, red), do(move_to_block(b, a), do(paint(bor, c, red), do(move_to_block(..., ...), s0)))))))), do(paint(bor, g, red), do(paint(rob, c, blue), do(paint(bor, d, red), do(move_to_block(c, g), do(paint(bor, c, red), do(move_to_block(b, a), do(paint(..., ..., ...), do(..., ...)))))))), do(paint(bor, d, red), do(paint(rob, c, blue), do(paint(bor, g, red), do(move_to_block(c, g), do(paint(bor, c, red), do(move_to_block(..., ...), do(..., ...))))))), do(paint(bor, g, red), do(paint(rob, c, blue), do(paint(bor, g, red), do(move_to_block(c, g), do(paint(..., ..., ...), do(..., ...)))))), do(paint(bor, d, red), do(paint(rob, c, blue), do(paint(bor, d, red), do(move_to_block(..., ...), do(..., ...))))), do(paint(bor, g, red), do(paint(rob, c, blue), do(paint(..., ..., ...), do(..., ...)))), do(paint(bor, d, red), do(paint(..., ..., ...), do(..., ...))), do(paint(..., ..., ...), do(..., ...)), do(..., ...)|...] .
```

```prolog
?- time((legal(S), holds(on(b,d),S),holds(on(c,b),S),holds(on(a,c),S))).
% 247,833,541 inferences, 44.712 CPU in 45.048 seconds (99% CPU, 5542887 Lips)
S = do(move_to_block(a, c), do(move_to_block(c, b), do(move_to_block(b, d), do(move_to_block(e, f), do(move_to_table(f), do(move_to_block(a, g), s0)))))) .
```

## Bonus

```prolog
%% goal states
%goal_state([on(b,d),on(c,b),on(a,c)]).                             % 1
%goal_state([on(b,d),on(c,b),on(a,c),color(a,red)]).                % 2
%goal_state([on(b,d),color(b,blue),on(c,b),on(a,c),color(a,red)]).   % 3

%% TIME
% 1
%   goal_counting:        % 2,500,257 inferences, 0.710 CPU in 0.734 seconds (97% CPU, 3519105 Lips)
%   goal_counting_plus:   % 230,582 inferences, 0.077 CPU in 0.081 seconds (95% CPU, 2983220 Lips)
% 2
%   goal_counting:        % 3,041,925 inferences, 0.866 CPU in 0.892 seconds (97% CPU, 3513281 Lips)
%   goal_counting_plus:   % 341,316 inferences, 0.102 CPU in 0.107 seconds (95% CPU, 3340668 Lips)
% 3
%   goal_counting:        % 4,223,665 inferences, 1.167 CPU in 1.207 seconds (97% CPU, 3620708 Lips)
%   goal_counting_plus:   % 606,858 inferences, 0.162 CPU in 0.169 seconds (96% CPU, 3745575 Lips)
```
