/*Find and Replace or Insert*/
find_replace_insert(Var, Value, [], [Var/Value]).
find_replace_insert(Var, Value, [Var/_|Vars], [Var/Value|Vars]):- !.
find_replace_insert(Var, Value, [DVar/DValue|Vars], [DVar/DValue|NVars]):- find_replace_insert(Var, Value, Vars, NVars).

/*Boolean Constants*/
logic_const(true).
logic_const(false).

/*Boolean Definitions*/
and_d(false, true, false).
and_d(false, false, false).
and_d(true, false, false).
and_d(true, true, true).

or_d(false, true, true).
or_d(false, false, false).
or_d(true, false, true).
or_d(true, true, true).

non_d(true, false).
non_d(false, true).

/*Boolean Expression Evaluation*/
eval(X, X):- logic_const(X).
eval(and(X, Y), R):- eval(X, XV), eval(Y, YV), and_d(XV, YV, R).
eval(or(X, Y), R):- eval(X, XV), eval(Y, YV), or_d(XV, YV, R).
eval(not(X), R):- eval(X, XV), non_d(XV, R).

/*Expression Evaluation*/
eval(A * B, CV, Vars):- eval(A, AV, Vars), eval(B, BV, Vars), CV is AV * BV.
eval(A + B, CV, Vars):- eval(A, AV, Vars), eval(B, BV, Vars), CV is AV + BV.
eval(A - B, CV, Vars):- eval(A, AV, Vars), eval(B, BV, Vars), CV is AV - BV.
eval(Num, Num, _):- number(Num).
eval(Var, Value, Vars):- atom(Var), member(Var/Value, Vars).

/*Conditional Expression Evaluation*/
eval(A == B, true, Vars):- eval(A, CV1, Vars), eval(B, CV2, Vars), CV1 == CV2.
eval(A == B, false, Vars):- eval(A, CV1, Vars), eval(B, CV2, Vars), CV1 =\= CV2.
eval(A > B, true, Vars):- eval(A, CV1, Vars), eval(B, CV2, Vars), CV1 > CV2.
eval(A > B, false, Vars):- eval(A, CV1, Vars), eval(B, CV2, Vars), CV1 =< CV2.
eval(A < B, true, Vars):- eval(A, CV1, Vars), eval(B, CV2, Vars), CV1 < CV2.
eval(A < B, false, Vars):- eval(A, CV1, Vars), eval(B, CV2, Vars), CV1 >= CV2.
eval(A >= B, true, Vars):- eval(A, CV1, Vars), eval(B, CV2, Vars), CV1 >= CV2.
eval(A >= B, false, Vars):- eval(A, CV1, Vars), eval(B, CV2, Vars), CV1 < CV2.
eval(A =< B, true, Vars):- eval(A, CV1, Vars), eval(B, CV2, Vars), CV1 =< CV2.
eval(A =< B, false, Vars):- eval(A, CV1, Vars), eval(B, CV2, Vars), CV1 > CV2.

/*Assignment Evaluation*/
eval(assign(X, Y), OVars, NVars):- eval(Y, Val, OVars), find_replace_insert(X, Val, OVars, NVars).

/*If-else Evaluation*/
eval(ifthenelse(Expr, compound(X), compound(_)), OVars, NVars):- eval(Expr, Boolval, OVars), 
		Boolval == true, eval(compound(X), OVars, NVars), !.
eval(ifthenelse(Expr, compound(_), compound(Y)), OVars, NVars):- eval(Expr, Boolval, OVars), 
		Boolval == false, eval(compound(Y), OVars, NVars).

/*While Evaluation*/
eval(while(A, compound(_)), OVars, OVars):- eval(A, Boolval, OVars), Boolval == false, !.
eval(while(A, compound(X)), OVars, NVars):- eval(A, Boolval, OVars), Boolval == true, eval(compound(X), OVars, IVars), 
		eval(while(A, compound(X)), IVars, NVars).

/*Print Evaluation*/
eval(print(A), OVars, OVars):- eval(A, Val, OVars), write(Val).
eval(print(\A), OVars, OVars):- write(A).

/*Compound statement Evaluation*/
eval(compound([]), Var, Var).
eval(compound([A|B]), OVars, NVars):- eval(A, OVars, IVars), eval(compound(B), IVars, NVars).

/*TODO: if possible support brackets*/
/*TODO: if possible support single if statement whithout else*/