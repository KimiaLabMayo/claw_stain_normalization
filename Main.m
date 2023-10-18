close all; clear; addpath('lib'); clc
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
PARA.epochs = 500;             %  Number of iterations for EM algorithm
PARA.loglik_threshold = 1e-5;  %  Stop criterion
PARA.class_n = 3;              %  Number of classes
PARA.win = 3;                  %  Size of window
PARA.beta = 20;                %  Temperature value
Path = '.\CLAW stain normalization\img\';

%% ------------------------ Target image
T = double(imread([Path,'target.tif']))/255;
[h_t,v_t,d] = size(T); 
data = reshape(T,h_t*v_t,3);
%% the initialization of parameters
[PI0_t,MU0_t,Sigma0_t,C_t] = KM(data,PARA.class_n); % Applying K-Means to initilize MU, Sigma, and Pi
Lambda0_t = zeros(d,PARA.class_n);  % Lambda initilization (method 1)
% Initialization of Lambda using skewness of observations (method 2)
for k = 1:PARA.class_n
    Lambda0_t(:,k) = (skewness(data(C_t==k,:)));  
end
%% ------------------------- Source image
S = double(imread(fullfile(Path,'Tv67.tif')))/255;
[h_s,v_s,d] = size(S); 
data_s = reshape(S,h_s*v_s,3);
%% the initialization of parameters
[PI0_s,MU0_s,Sigma0_s,C_s] = KM(data_s,PARA.class_n);  % Applying K-Means to initilize MU, Sigma, and Pi
Lambda0_s = zeros(d,PARA.class_n);    % Lambda initilization (method 1)
% Initialization of Lambda using skewness of observations (method 2)
for k = 1:PARA.class_n
    Lambda0_s(:,k) = (skewness(data_s(C_s==k,:))); 
end

%% ------------------------- parameter estimation and stain transformation using SGMM model
%
%
%% Parameter estimation of the target image
[m_t,sig_t,P_t,~,~,C_SGMM_t] = SGMM(PARA,T,MU0_t,Sigma0_t,PI0_t.*ones(h_t*v_t,1));
%% Parameter estimation of the source image
[m_s,sig_s,P_s,Z_SGMM,~,C_SGMM_S] = SGMM(PARA,S,MU0_s,Sigma0_s,PI0_s.*ones(h_s*v_s,1));
%% Stain transformation
[X_SGMM,SSIM(1),PCC(1)] = Transform_SGMM(S,T,m_t',sig_t,m_s',sig_s,Z_SGMM,C_SGMM_S,C_SGMM_t,PARA.class_n);
%% imshow normalized imacge
figure; imshow(X_SGMM, []); title("SGMM")

%------------------------- parameter estimation and stain transformation using SFMSN model
%
%
%% Parameter estimation of the target image
[Mu_t,Sigma_t,Lambda_t,~,~,~,C_SFMSN_t] = SFMSN(PARA,T,m_t,sig_t,Lambda0_t,P_t);
%% Parameter estimation of the source image
[Mu_s,Sigma_s,Lambda_s,~,Z_SFMSN,~,C_SFMSN_s] = SFMSN(PARA,S,m_s,sig_s,Lambda0_s,P_s);
%% Stain transformation
[X_SFMSN,SSIM(2),PCC(2)] = Transform_SFMSN(S,T,Mu_t,Sigma_t,Lambda_t,Mu_s,Sigma_s,Lambda_s,Z_SFMSN,C_SFMSN_s,C_SFMSN_t,PARA.class_n);
%% imshow normalized image
figure; imshow(X_SFMSN, []); title("SFMSN")
