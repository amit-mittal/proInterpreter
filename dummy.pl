/*Helper Functions*/
/*
append([], L, L).
append([H|T], L2, [H|L3]):-  append(T, L2, L3).
*/

/*Find and Replace or Insert*/
find_replace_insert(Var, Value, [], [Var/Value]).
find_replace_insert(Var, Value, [Var/Oldval|Vars], [Var/Value|Vars]).
find_replace_insert(Var, Value, [DVar/DValue|Vars], [DVar/DValue|NVars]):- find_replace_insert(Var, Value, Vars, NVars).

/*Expression Evaluation*/
eval_v(A * B, CV, Vars):- eval_v(A, AV, Vars), eval_v(B, BV, Vars), CV is AV * BV.
eval_v(A + B, CV, Vars):- eval_v(A, AV, Vars), eval_v(B, BV, Vars), CV is AV + BV.
eval_v(A - B, CV, Vars):- eval_v(A, AV, Vars), eval_v(B, BV, Vars), CV is AV - BV.
eval_v(Num, Num, Vars):- number(Num).
eval_v(Var, Value, Vars):- atom(Var), member(Var/Value, Vars).

/*Boolean Constants*/
logic_const(true).
logic_const(false).

/*Boolean Definitions*/
and_d(false,true,false).
and_d(false,false,false).
and_d(true,false,false).
and_d(true,true,true).

or_d(false,true,true).
or_d(false,false,false).
or_d(true,false,true).
or_d(true,true,true).

non_d(true,false).
non_d(false,true).

/*Boolean Expression Evaluation*/
eval_b(X, X):- logic_const(X).
eval_b(X * Y, R):- eval_b(X, XV), eval_b(Y, YV), and_d(XV, YV, R).
eval_b(X + Y, R):- eval_b(X, XV), eval_b(Y, YV),or_d(XV, YV, R).
eval_b(- X, R):- eval_b(X, XV), non_d(XV, R).

/*Conditional Expression Evaluation*/
eval_b(A == B, R):- eval_v(A, CV1, _), eval_v(B, CV2, _), CV1 == CV2, R = true.
eval_b(A == B, R):- eval_v(A, CV1, _), eval_v(B, CV2, _), CV1 =\= CV2, R = false.

/*Assignment Evaluation*/
eval_a(assign(X, Y), OVars, NVars):- find_replace_insert(X, Y, OVars, NVars).
