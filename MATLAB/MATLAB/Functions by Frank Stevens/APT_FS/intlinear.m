%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% intlinear.m
%
%[A,B] = intlinear(x,y)
%
% Realiza a regressao linear (minimos quadrados) dos dados fornecidos (x,y)
% devolvendo os valores de A e B, sendo (y = A + B*x).

function    [A,B] = intlinear(x,y)

mx = mean(x);        my = mean(y);
mx2 = mean(x.^2);    my2 = mean(y.^2);
mxy = mean(x.*y);
A = (mx2*my-mx*mxy)/(mx2-mx^2);
B = (mxy - (mx*my))/(mx2-mx^2);
