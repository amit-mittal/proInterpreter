/*Expression Evaluation*/
eval(A * B, CV, Vars):- eval_v(A, AV, Vars), eval_v(B, BV, Vars), CV is AV * BV.
eval(A + B, CV, Vars):- eval_v(A, AV, Vars), eval_v(B, BV, Vars), CV is AV + BV.
eval(A - B, CV, Vars):- eval_v(A, AV, Vars), eval_v(B, BV, Vars), CV is AV - BV.
eval(Num, Num, Vars):- number(Num).
eval(Var, Value, Vars):- atom(Var), member(Var/Value, Vars).