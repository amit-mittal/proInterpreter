/*================INDENTATION================*/
/*Boolean Constants*/
logic_const(true).
logic_const(false).

/*Keeping track of TABs*/
handle_tabs(0).
handle_tabs(X):- number(X), X > 0, write('\t'), Y is X-1, handle_tabs(Y).

/*Expression Indentation*/
indent(A * B, _):- indent(A, _), write(' '), write(*), write(' '), indent(B, _).
indent(A + B, _):- indent(A, _), write(' '), write(+), write(' '), indent(B, _).
indent(A - B, _):- indent(A, _), write(' '), write(-), write(' '), indent(B, _).
indent(Num, _):- number(Num), write(Num).
indent(Var, _):- atom(Var), write(Var).

/*Boolean Expression Indentation*/
indent(X, _):- logic_const(X), write(X).
indent(and(X, Y), _):- indent(X, _), write(' '), write(and), write(' '), indent(Y, _).
indent(or(X, Y), _):- indent(X, _), write(' '), write(or), write(' '), indent(Y, _).
indent(not(X), _):- write(not), write(' '), indent(X, _).

/*Conditional Expression Evaluation*/
indent(A == B, _):- indent(A, _), write(' '), write(==), write(' '), indent(B, _).
indent(A > B, _):- indent(A, _), write(' '), write(>), write(' '), indent(B, _).
indent(A < B, _):- indent(A, _), write(' '), write(<), write(' '), indent(B, _).
indent(A >= B, _):- indent(A, _), write(' '), write(>=), write(' '), indent(B, _).
indent(A =< B, _):- indent(A, _), write(' '), write(<=), write(' '), indent(B, _).

/*Assignment Indentation*/
indent(assign(X, Y), Tabs):- handle_tabs(Tabs), indent(X, Tabs), write(' '), write(=), write(' '), indent(Y, Tabs).

/*If-else Indentation*/
indent(ifthenelse(Expr, compound(X), compound(Y)), Tabs):- handle_tabs(Tabs), write(if), write(' '), 
		indent(Expr, Tabs), nl, CTabs is Tabs+1, indent(compound(X), CTabs), handle_tabs(Tabs), write(else), nl, 
		indent(compound(Y), CTabs), handle_tabs(Tabs), write(end).

/*While Indentation*/
indent(while(A, compound(X)), Tabs):- handle_tabs(Tabs), write(while), write(' '), indent(A, Tabs), nl, 
		CTabs is Tabs+1, indent(compound(X), CTabs), handle_tabs(Tabs), write(end).

/*Print Indentation*/
indent(print(\A), Tabs):- handle_tabs(Tabs), write(print), write(' '), write('\''),write(A), write('\''), !.
indent(print(A), Tabs):- handle_tabs(Tabs), write(print), write(' '), indent(A, Tabs).

/*Compound statement Indentation*/
indent(compound([]), _).
indent(compound([A|B]), Tabs):- indent(A, Tabs), nl, indent(compound(B), Tabs).

/*Find and Replace or Insert*/
find_replace_insert(Var, Value, [], [Var/Value]).
find_replace_insert(Var, Value, [Var/_|Vars], [Var/Value|Vars]):- !.
find_replace_insert(Var, Value, [DVar/DValue|Vars], [DVar/DValue|NVars]):- find_replace_insert(Var, Value, Vars, NVars).

/*Pretty Print*/
pretty_print(A):- indent(A, 0).


/*================EVALUATION================*/
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

/*Init Evaluation*/
evaluation(A):- eval(A, [], _).