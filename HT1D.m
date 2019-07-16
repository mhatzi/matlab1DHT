%Script HT1D.m
%ENGR430 Finite Element Analysis
Nodes =load('nodesP73.txt');
Boundaries = load('boundaryP73.txt');
%Boundaries(3) is now an element number for A,H,and Tinf
Elements = readtable('elementsP73_2.txt','Format','%f%f%f%f%f%f');
% Elements is now a table that contains two node numbers then a function
% A,K,P,H,Tinf
%return
OrigData = [418.9;366.5;336.9;319.5;308.4;303.3;300.2;298.5;296.0];

numnodes = size(Nodes,1);
K = zeros(numnodes,numnodes);
T = zeros(numnodes,1);
fb = zeros(numnodes,1);
%Assemble the global stiffness matrix 
for ie= 1 : size(Elements,1)
        DOFs = [Elements.Node1(ie),Elements.Node2(ie)];
        X1 = Nodes(Elements.Node1(ie),1);
        X2 = Nodes(Elements.Node2(ie),1);
        Le = X2-X1;
        k = Elements.k(ie)*Elements.A(ie)/Le;
        K(DOFs,DOFs)=K(DOFs,DOFs)+[k -k;-k k];
        %convection part
        k = h*Elements.P(ie)*Le/6;
        K(DOFs,DOFs)=K(DOFs,DOFs)+[2*k k; k 2*k];
        fb(DOFs)=fb(DOFs)+h*Elements.P(ie)*Elements.Tinf(ie)*Le/2 ;

end 

Kreduced = K;
F=fb;
%Start with global K then reduce it with boundaries

for ib = 1 : size(Boundaries,1)
    nd = Boundaries(ib,1);
       %Check if essential
       if(Boundaries(ib,2) == 0)
          Kreduced(nd,1:numnodes) = zeros(1,numnodes);
          Kreduced(nd,nd)=1 ;
          F(nd)=Boundaries(ib,3);
       else
             %Handle the convection from the free end
             el = Boundaries(ib,3);
             F(Boundaries(ib,1))=F(Boundaries(ib,1))+...
                 Elements.A(el)*h*Elements.Tinf(el);
       K(nd,nd)=K(nd,nd)+Elements.A(el)*h;
       Kreduced(nd,nd)=K(nd,nd);
       
       end       
end
       %Have reduced K and F Matrix solve for U
       %Instead of gaussolve
       
       T = Kreduced \ F; % This is matlabs vastly superior gaussolve
       %Find actual forces
       Fact = K*T;
       
       %Find HT from base
       Qact =fb-Fact;

       

       
              Error(i) = sum((T-OrigData).^2);
     
