%Compare FEA solution for 1D HT with
% Analytic solution
xa=[0:.001:.8]';
A=1.270761662;
P=3.996105855;
k=134;
h=1225;
Tinf=295;
T0=418.9;
L=0.8;
m=sqrt(h*P/A/k);
term1=(cosh(m*(L-xa))+h/m/k*sinh(m*(L-xa)))/(cosh(m*L)+h/m/k*sinh(m*L));
Tt=(T0-Tinf)*term1+Tinf;

plot(xa,Tt,Nodes(:,1),T);
