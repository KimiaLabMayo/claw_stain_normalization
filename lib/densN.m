function [PJ, Z] = densN(Data, Mu, Sigma,P)
% This function computes the Probability Density Function (PDF) of the components of a
% multivariate Gaussian mixture model.
% Inputs -----------------------------------------------------------------
%  o Data:  D x N array representing N datapoints of D dimensions.
%  o Mu:    D x k array representing the mean vectors of the components.
%  o Sigma: DxDxk array representing the covariance matrices of the components.
% Outputs ----------------------------------------------------------------
%   o Z:  N x K array representing the probabilities for the 
%            N datapoints.     
N=size(Data,2);
nbStates = size(Sigma,3);
PJ=zeros(N,nbStates);
for j=1:nbStates
% Compute probability p(j)p(x|j)
PJ(:,j) = P(:,j).*PDFN(Data, Mu(:,j), Sigma(:,:,j)); 
end
PDF=sum(PJ,2);
Z=PJ./repmat(PDF,1,nbStates);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function prob = PDFN(Data, Mu, Sigma)
% This function computes the Probability Density Function (PDF) of a
% multivariate Gaussian distribution
[nbVar,nbData] = size(Data);
D = Data - repmat(Mu,1,nbData);
prob0 = sum((D'/Sigma).*D', 2);
prob = exp(-0.5*prob0) / (sqrt((2*pi)^nbVar*det(Sigma))+1e-30);
