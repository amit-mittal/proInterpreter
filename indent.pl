/*Boolean Constants*/
logic_const(true).
logic_const(false).

/*If possible try to keep track of TAB*/

/*Expression Indentation*/
indent(A * B):- indent(A), write(' '), write(*), write(' '), indent(B).
indent(A + B):- indent(A), write(' '), write(+), write(' '), indent(B).
indent(A - B):- indent(A), write(' '), write(-), write(' '), indent(B).
indent(Num):- number(Num), write(Num).
indent(Var):- atom(Var), write(Var).

/*Boolean Expression Indentation*/
indent(X):- logic_const(X), write(X).
indent(and(X, Y)):- indent(X), write(' '), write(and), write(' '), indent(Y).
indent(or(X, Y)):- indent(X), write(' '), write(or), write(' '), indent(Y).
indent(not(X)):- write(not), write(' '), indent(X).

/*Conditional Expression Evaluation*/
indent(A == B):- indent(A), write(' '), write(==), write(' '), indent(B).
indent(A > B):- indent(A), write(' '), write(>), write(' '), indent(B).
indent(A < B):- indent(A), write(' '), write(<), write(' '), indent(B).
indent(A >= B):- indent(A), write(' '), write(>=), write(' '), indent(B).
indent(A =< B):- indent(A), write(' '), write(<=), write(' '), indent(B).

/*Assignment Indentation*/
indent(assign(X, Y)):- indent(X), write(' '), write(=), write(' '), indent(Y).

/*If-else Indentation*/
indent(ifthenelse(Expr, compound(X), compound(Y), _)):- write(if), write(' '), 
		indent(Expr), nl, indent(compound(X)), write(else), nl, indent(compound(Y)).

/*While Indentation*/
indent(while(A, compound(X))):- write(while), write(' '), indent(A), nl, indent(compound(X)), nl, write(end).

/*Print Indentation*/
indent(print(A)):- write(print), write(' '), indent(A).

/*Compound statement Indentation*/
indent(compound([])).
indent(compound([A|B])):- indent(A), nl, indent(compound(B)).