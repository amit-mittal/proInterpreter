/*Boolean Constants*/
logic_const(true).
logic_const(false).

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
