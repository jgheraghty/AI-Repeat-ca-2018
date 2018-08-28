% 1

node('a','b',2).
node('a','c',2).
node('b','e',4).
node('e','b',4).
node('c','d',1).
node('c','x',3).
node('x','g',1).
node('b','g',5).
node('e','g',1).

h('a',9).
h('b',4).
h('c',3).
h('d',8).
h('e',4).
h('g',0).
h('x',2).

goal('g').

% `<-' is the object-level `if' - it is an infix meta-level predicate
:- op(1150, xfx, <- ).

% `&' is the object level conjunction.
% It is an infix meta-level binary function symbol:
:- op(950,xfy, &).

% bprove(G,D) is true if G can be proven with depth no more than D

prove(true).
prove((A & B)) :-
   prove(A),
   prove(B).
prove(H) :-
   (H <- B),
   prove(B).

% 2

solve(Node, Solution) :-
  dfs([], Node, Solution).

dfs(Path, Node, [Node | Path]) :-
   goal(Node).

dfs(Path, Node, Solution) :-
  node(Node, NextNode,_),
  \+ member( NextNode, Path), % stops path going back on itself
  dfs([Node|Path], NextNode, Solution).

% 4
a <- b & c.
b <- true.
c <- true.

on(screen) <- true.
power(pc) <- true.
problem(screen_connection) <- on(screen)& power(pc).
problem(screen_connection) <- power(pc) & on(screen) & screens_connected(2).
solution('Check connection between Computer Base and Screen') <- problem(screen_connection).
solution('Press start button and P on the computer and check the Project settings') <- problem(screen_connection).










