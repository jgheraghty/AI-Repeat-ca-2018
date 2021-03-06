% 1.

% Prolog representation of Graph

node('a','b',2).
node('a','c',2).
node('b','e',4).
node('e','b',4).
node('c','d',1).
node('c','x',3).
node('x','g',1).
node('b','g',5).
node('e','g',1).

% Prolog representation of Heuristic Table

h('a',9).
h('b',4).
h('c',3).
h('d',8).
h('e',4).
h('g',0).
h('x',2).

% Goal node - variable 'g'

goal('g').

% 5. Askable fact

% askable(screens_connected(_)).

% 2. Depth First Search

solve(Node, Solution) :-
  dfs([], Node, Solution). % Each node is added to the empty list

dfs(Path, Node, [Node | Path]) :-
   goal(Node). % If it does not reach the goal node, it continues to the next dfs

dfs(Path, Node, Solution) :-
  node(Node, NextNode,_),
  \+ member( NextNode, Path), % stops path going back on itself
  dfs([Node|Path], NextNode, Solution).

% 5. Askable meta level prover (aprove)

% `<-' is the object-level `if' - it is an infix meta-level predicate
:- op(1150, xfx, <- ).

% `&' is the object level conjunction.
% It is an infix meta-level binary function symbol:
:- op(950,xfy, &).

a <- b & c.
b <- true.
c <- true.

aprove(true).
aprove((A & B)) :-
aprove(A),
aprove(B).
aprove(G) :-
askable(G),
answered(G,yes). % The question is answered? True
aprove(G) :-
askable(G),
unanswered(G), % The question is not answered? No
ask(G,Ans), % Then, ask question!
assert(answered(G,Ans)),
Ans=yes.
aprove(H) :-
(H <- B),
aprove(B).

% answered(G,Ans) is dynamically added to the database.
:- dynamic answered/2.

% unanswered(G) is true if G has not be answered
unanswered(G) :- \+ answered(G).   % negation as failure
answered(G) :- answered(G,_).

% ask(G,Ans) asks the user G, and the user relies with Ans
ask(G,Ans) :-
writeln(['Is',G,'true?']), % G is the state e.g. screens_connected(2). ?
read(Ans).

% writeln(L) writes each element of list L
writeln([]) :- nl.
writeln([H|T]) :-
write(H),
writeln(T).

% 4. Meta Level Facts based on Rules

% The PC is on
on(screen) <- true.

% The PC has power
power(pc) <- true.

% Two screens - asked
askable(screens_connected(_)).

% The problem is a screen connection if the pc has power and the screen
% is on or
problem(one_screen) <- on(screen) & power(pc) & screens_connected(1).

% The problem is a screen connection if the PC has power and the screen
% is on and 2 screens are connected
problem(two_screens) <- power(pc) & on(screen) & screens_connected(2).

% The solution to problem is a screen connection is to Check connection
% between Computer Base and Screen
solution('Check connection between Computer Base and Screen') <- problem(one_screen).

% The solution to problem is a screen connection is to Press start
% button and P on the computer and check the Project settings
solution('Press start button and P on the computer and check the Project settings') <- problem(two_screens).


% Joanne Heraghty
% S00154277









