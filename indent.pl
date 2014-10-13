/*Boolean Constants*/
logic_const(true).
logic_const(false).

/*Keeping track of TABs*/
handle_tabs(0).
handle_tabs(X):- number(X), X>0, write('\t'), Y is X-1, handle_tabs(Y).

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
indent(ifthenelse(Expr, compound(X), compound(Y), _), Tabs):- handle_tabs(Tabs), write(if), write(' '), 
		indent(Expr, Tabs), nl, CTabs is Tabs+1, indent(compound(X), CTabs), handle_tabs(Tabs), write(else), nl, 
		indent(compound(Y), CTabs).

/*While Indentation*/
indent(while(A, compound(X)), Tabs):- handle_tabs(Tabs), write(while), write(' '), indent(A, Tabs), nl, 
		CTabs is Tabs+1, indent(compound(X), CTabs), handle_tabs(Tabs), write(end).

/*Print Indentation*/
indent(print(A), Tabs):- handle_tabs(Tabs), write(print), write(' '), indent(A, Tabs).

/*Compound statement Indentation*/
indent(compound([]), _).
indent(compound([A|B]), Tabs):- indent(A, Tabs), nl, indent(compound(B), Tabs).