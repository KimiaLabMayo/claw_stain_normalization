function [Mu,Sigma,Lambda,P,Z,Seg,Ind] = SFMSN(PARA,I,Mu,Sigma,Lambda,P)
obj_fcn=zeros(PARA.epochs,1);
nbStep = 1;
[h,v,d]=size(I);
X = reshape(I,h*v,d)';
[~,Z]=densFMSN(X,Mu,Sigma,Lambda,P);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Delta = zeros(d, PARA.class_n);
GAmma = zeros(d, d, PARA.class_n);
for j=1:PARA.class_n
Delta(:,j)=(Sigma(:,:,j)^(1/2))*(Lambda(:,j)/sqrt(1+Lambda(:,j)'*Lambda(:,j)));
GAmma(:,:,j)=Sigma(:,:,j)-Delta(:,j)*Delta(:,j)';  
end

F = ones(PARA.win,PARA.win);
h1 = filter2(F, ones(h,v));
beta=PARA.beta; 
theta = zeros(h*v,PARA.class_n);
for j=1:PARA.class_n
w = filter2(F, reshape(Z(:,j)+P(:,j),h,v));
theta(:,j) = exp(beta.*w(:)./h1(:));    
end

while 1 
P = (theta+Z)./(sum(theta+Z,2).*ones(1,PARA.class_n));
for j=1:PARA.class_n     
%% E-step %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
D=X-repmat(Mu(:,j),1,h*v);      
A= real((Lambda(:,j)'/(Sigma(:,:,j)^(1/2)))*D);
M2=( 1+(Delta(:,j)'/ GAmma(:,:,j) )*Delta(:,j) )^(-1);
m=((M2*Delta(:,j)')/GAmma(:,:,j))*D;

Tau=normpdf(A)./(normcdf(A)+1e-20);
XI=(m+sqrt(M2)*Tau)';
Omega=(sqrt(M2)*m.*Tau+M2+m.^2)';
%% M Step: Update the parameters
Mu(:,j) = ((X-Delta(:,j)*XI')*Z(:,j)) /sum(Z(:,j));
Data_tmp1 = (X-repmat(Mu(:,j),1,h*v));
Delta(:,j) = (Data_tmp1*(Z(:,j).*XI))/sum(Z(:,j).*Omega); 
GAmma(:,:,j) = (( (repmat(Z(:,j)',d, 1).* Data_tmp1)*Data_tmp1'-(Data_tmp1*(Z(:,j).*XI))*Delta(:,j)'-(Delta(:,j)*(Z(:,j).*XI)')*Data_tmp1'+(Delta(:,j)*Delta(:,j)')*sum(Z(:,j).*Omega ) )/sum(Z(:,j)))+ 1E-5.*diag(ones(d,1));
Sigma(:,:,j) = GAmma(:,:,j)+Delta(:,j)*Delta(:,j)'+ 1E-5.*diag(ones(d,1));
Lambda(:,j) = (Sigma(:,:,j)^(1/2)\Delta(:,j))/sqrt(1-(Delta(:,j)'/Sigma(:,:,j))*Delta(:,j));
end
[pdf,Z]=densFMSN(X,Mu,Sigma,Lambda,P);

for j=1:PARA.class_n
w = filter2(F, reshape(Z(:,j)+P(:,j) ,h,v));
theta(:,j) = exp(beta.*w(:)./h1(:));    
end

obj_fcn(nbStep) = sum(mylog(sum(pdf,2)))-sum(sum(theta.*mylog(theta./P)));

%  check termination condition 
if(mod(nbStep,50)==0)
    fprintf('Iteration = %d, fcn = %f\n', nbStep, obj_fcn(nbStep));  
end

if nbStep > 10
    if  abs((obj_fcn(nbStep)/obj_fcn(nbStep-1))-1) < PARA.loglik_threshold     %  
        break;
    end
end

nbStep = nbStep+1;
if  nbStep>PARA.epochs
   break;
end    


end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[~, Ind]=max(Z,[],2);
Seg = reshape(Ind,h,v);