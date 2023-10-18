function [PJ, Z] = densFMSN(Data, Mu, Sigma, Lambda, P)
% This function computes the Probability Density Function (PDF) of the components of a
% multivariate Skew normal mixture
% Inputs -----------------------------------------------------------------
%  o Data:  D x N array representing N datapoints of D dimensions.
%  o Mu:    D x k array representing the location vectors of the SN components.
%  o Sigma: DxDxk array representing the dispersion matrices of the SN components.
%  o Lambda: D x K array representing the skewness parameter vector of the SN components.
% Outputs ----------------------------------------------------------------
%   o Z:  N x K array representing the probabilities for the 
%            N datapoints.     
N=size(Data,2);
nbStates = size(Sigma,3);
PJ=zeros(N,nbStates);
for j=1:nbStates
% Compute probability p(j)p(x|j)
PJ(:,j) = P(:,j).*skgaussPDF(Data, Mu(:,j), Sigma(:,:,j), Lambda(:,j));  
end
PDF=sum(PJ,2);
Z=PJ./repmat(PDF,1,nbStates);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function prob = skgaussPDF(Data, Mu, Sigma, Lambda)
% This function computes the Probability Density Function (PDF) of a
% multivariate Skew normal distribution
% Inputs -----------------------------------------------------------------
%  o Data:  D x N array representing N datapoints of D dimensions.
%  o Mu:    D x 1 array representing the location vector of the SN distribution.
%  o Sigma: D x D array representing the dispersion matrix of the SN
%                 distribution.
%  o Lambda: D x 1 array representing the skewness parameter vector of the
%                  SN distribution.
% Outputs ----------------------------------------------------------------
%   o prob:  N x 1 array representing the PDF values for the 
%            N datapoints.     
[nbVar,nbData] = size(Data);
D = Data - repmat(Mu,1,nbData);
prob0 = sum((D'/Sigma).*D', 2);
prob1 = exp(-0.5*prob0) / (sqrt((2*pi)^nbVar*det(Sigma))+1e-30);
LSD  = real((Lambda'/(Sigma^(1/2)))*D);
prob = real( 2*prob1.*normcdf(LSD)' );

