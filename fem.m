clear; clc;
%..........................................................
% 1a. Input and Initiatlization
%..........................................................

%Reading input.txt file
fileID = fopen('input.txt','r');
data_input = fscanf(fileID,'%g',[15 Inf]);
fclose(fileID);
data_input=data_input.';

NUMEL = data_input(1,1);   % No. of elements
No_Nodes=data_input(1,2);  % No. of nodes

%DOF initialisation
dof=No_Nodes*2;   %Degree of freedom (No_Nodes*3 if 3D)
activedof=zeros(1,dof)+1;
 
%Element Stiffness values - E, A, L, orientation(alpha)
for i=2:NUMEL+1
    el(i-1,1)=data_input(i,2);
    el(i-1,2)=data_input(i,3);
    fxi(i-1)=data_input(i,4);
    fyi(i-1)=data_input(i,5);
    fxj(i-1)=data_input(i,7);
    fyj(i-1)=data_input(i,8);
    E(i-1)=data_input(i,10);
    A(i-1)=data_input(i,11);
    L(i-1)=data_input(i,13);
    alpha(i-1)=data_input(i,15);
end

%..........................................................
% 2. Element stiffness computation and assembly
%..........................................................

Kg=zeros(No_Nodes*2); %Declaring Global K matrix
Rg=zeros(No_Nodes*2,1); %Declaring Global K matrix

%Finding local K matrices
for i = 1:NUMEL
    Kl=zeros(No_Nodes*2); %Declaring K matrix for that element
    Rl=zeros(No_Nodes*2,1);%Declaring R matrix 
    fprintf('________________________________________________\n');
    fprintf('[k] for El-no: %2i and alpha: %6.1f\n',i,alpha(i));
    fprintf('................................................\n');
    fprintf('................................................\n');
    k_prime =zeros(2); k = zeros(4); % initialize the local matrices
    
    % Self explanatory
    a = A(i)*E(i)/L(i);
    c = cosd(alpha(i));
    s = sind(alpha(i));
    
    % 1D transformation matrix
    T(1,1)=c;T(1,2)=s;T(1,3)=0;T(1,4)=0;
    T(2,1)=0;T(2,2)=0;T(2,3)=c;T(2,4)=s;
    
    % Element stiffness matrix in local coordinates
    k_prime(1,1)=a ;k_prime(1,2)=-a;
    k_prime(2,1)=-a;k_prime(2,2)= a;
    
    % Element stiffness matrix in global coordinates
    k = T'*k_prime*T;
    
    for j=1:4
        fprintf('%1.3g %1.3g %1.3g %1.3g \n',k(j,1),k(j,2),k(j,3),k(j,4));
    end
    
    %Consistent Nodal force vector
    r=[fxi(i);fyi(i);fxj(i);fyj(i)];
    
    m=el(i,1);n=el(i,2);
    for j=1:2
        for q=1:2
            Kl((m-1)*2+j,(m-1)*2+q)=Kl((m-1)*2+j,(m-1)*2+q)+k(j,q);
            Kl((m-1)*2+j,(n-1)*2+q)=Kl((m-1)*2+j,(n-1)*2+q)+k(j+2,q);
            Kl((n-1)*2+j,(m-1)*2+q)=Kl((n-1)*2+j,(m-1)*2+q)+k(j,q+2);
            Kl((n-1)*2+j,(n-1)*2+q)=Kl((n-1)*2+j,(n-1)*2+q)+k(j+2,q+2);
        end
        Rl((m-1)*2+j)=r(j);
        Rl((n-1)*2+j)=r(j+2);
    end
    Kg=Kg+Kl;
    Rg=Rg+Rl;
end
    fprintf('________________________________________________\n');
Kg
    fprintf('________________________________________________\n');
Rg
    fprintf('________________________________________________\n');

%..........................................................
% 3. Imposing BCs
%..........................................................

%Reading bc file
fileID = fopen('boundary_conditions.txt','r');
data_bc = fscanf(fileID,'%u',[3 Inf]);
fclose(fileID);
data_bc=data_bc.';

nbc=data_bc(1,1);    %No of boundary conditions
nadof=dof-nbc;
for i=2:nbc+1
    activedof(1,(data_bc(i,1)-1)*2+data_bc(i,2))=0;
end
%Kg_BC=(transpose(activedof)*activedof).*Kg;
%Rg_BC=Rg.*transpose(activedof);

%..........................................................
% 4. Solve
%..........................................................
m=1;n=1;
for i=1:dof
    if(activedof(1,i))    
        for j=1:dof
            if(activedof(1,j))
                Kg_BC(m,n)=Kg(i,j);
                n=n+1;
            end
        end
        Rg_BC(m)=Rg(i);
        m=m+1;
        n=1;
    end
end

Kg_BC
Rg_BC=transpose(Rg_BC);
D_BC=linsolve(Kg_BC,Rg_BC)
j=1;
for i=1:dof
    if(activedof(1,i)==1)
        D(i)=D_BC(j);
        j=j+1;
    else
        D(i)=0;
    end
end
D=D.';
%..........................................................
% 5. Postprocessing
%..........................................................

for i = 1:NUMEL
    fprintf('________________________________________________\n');
    m=el(i,1);n=el(i,2);
    u1=D((m-1)*2+1,1);
    v1=D((m-1)*2+2,1);
    u2=D((n-1)*2+1,1);
    v2=D((n-1)*2+2,1);
    strain(i,1)=((u2-u1)*cosd(alpha(i))+(v2-v1)*sind(alpha(i))/L(i));
    stress(i,1)=E(i)*strain(i,1);
    fprintf('El. no. %d:  Stress= %1.3g and Strain= %1.3g \n',i,stress(i,1),strain(i,1));
end
fprintf('________________________________________________\n');
