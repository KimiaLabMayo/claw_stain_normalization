function [Mu,Sigma,P,Z,Seg,Ind] = SGMM(PARA,I,Mu,Sigma,P)
obj_fcn=zeros(PARA.epochs,1);
nbStep = 1;
[h,v,d]=size(I);
X = reshape(I,h*v,d)';
[~,Z] = densN(X,Mu,Sigma,P);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
F = ones(PARA.win,PARA.win);
h1 = filter2(F, ones(h,v));
beta=PARA.beta; 
theta = zeros(h*v,PARA.class_n);
for j=1:PARA.class_n
w = filter2(F, reshape(Z(:,j)+P(:,j),h,v));
theta(:,j) = exp(beta.*w(:)./h1(:));    
end

while 1 
%% E-step %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
P = (theta+Z)./(sum(theta+Z,2).*ones(1,PARA.class_n));
for j=1:PARA.class_n     
%% M Step: Update the parameters
Mu(:,j) = (X*Z(:,j)) /sum(Z(:,j));
Data_tmp1 = (X-repmat(Mu(:,j),1,h*v));
Sigma(:,:,j) = (((repmat(Z(:,j)',d, 1).* Data_tmp1)*Data_tmp1')/sum(Z(:,j)))+ 1E-5.*diag(ones(d,1));
end
[pdf,Z]=densN(X,Mu,Sigma,P);

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