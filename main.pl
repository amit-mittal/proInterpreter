/*Helper Functions*/


/*Find and Replace or Insert*/
find_replace_insert(Var, Value, [], [Var/Value]).
find_replace_insert(Var, Value, [Var/Oldval|Vars], [Var/Value|Vars]).
find_replace_insert(Var, Value, [DVar/DValue|Vars], [DVar/DValue|NVars]):- find_replace_insert(Var, Value, Vars, NVars).

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

/*If-else Declaration*/
ifthenelse(true, X, Y, X).
ifthenelse(false, X, Y, Y).

/*Expression Evaluation*/
eval(A * B, CV, Vars):- eval(A, AV, Vars), eval(B, BV, Vars), CV is AV * BV.
eval(A + B, CV, Vars):- eval(A, AV, Vars), eval(B, BV, Vars), CV is AV + BV.
eval(A - B, CV, Vars):- eval(A, AV, Vars), eval(B, BV, Vars), CV is AV - BV.
eval(Num, Num, Vars):- number(Num).
eval(Var, Value, Vars):- atom(Var), member(Var/Value, Vars).

/*Boolean Expression Evaluation*/
eval(X, X):- logic_const(X).
eval(and(X, Y), R):- eval(X, XV), eval(Y, YV), and_d(XV, YV, R).
eval(or(X, Y), R):- eval(X, XV), eval(Y, YV), or_d(XV, YV, R).
eval(not(X), R):- eval(X, XV), non_d(XV, R).

/*Conditional Expression Evaluation*/
eval(A == B, R, Vars):- eval(A, CV1, Vars), eval(B, CV2, Vars), CV1 == CV2, R = true.
eval(A == B, R, Vars):- eval(A, CV1, Vars), eval(B, CV2, Vars), CV1 =\= CV2, R = false.
/*Similarly add other conditional operators*/

/*Assignment Evaluation*/
eval(assign(X, Y), OVars, NVars):- eval(Y, Val, OVars), find_replace_insert(X, Val, OVars, NVars).

/*Compound statement Evaluation*/
eval(compound([]), Var, Var).
eval(compound([A|B]), OVars, NVars):- eval(A, OVars, IVars), eval(compound(B), IVars, NVars).

/*If-else Evaluation*/
eval(ifthenelse(Expr, compound(X), compound(Y), compound(Z)), OVars, NVars):- eval(Expr, Boolval), 
		ifthenelse(Boolval, compound(X), compound(Y), compound(Z)), eval(compound(Z), OVars, NVars).

/*While Evaluation*/
eval(while(A, compound(X)), OVars, NVars):- eval(A, false, OVars), NVars = OVars.
eval(while(A, compound(X)), OVars, NVars):- eval(A, true, OVars), eval(compound(X), OVars, NVars), 
		eval(while(A, compound(X)), NVars, _).