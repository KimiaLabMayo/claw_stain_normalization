function [X_n,SSIM,PCC] = Transform_SFMSN(S,T,Mu_t,Sigma_t,Lambda_t,Mu_s,Sigma_s,Lambda_s,Gam,id_s,id_t,NCluster)
T_hsd = RGB2HSD(T);
TD = T_hsd(:,:,1);
S_hsd=RGB2HSD(S);
SD = S_hsd(:,:,1);
for i=1:NCluster
la_t(i) = mean2(TD(id_t==i));
la_s(i) = mean2(SD(id_s==i));
end
[~,i_t] = sort(la_t);
[~,i_s] = sort(la_s);


[h,w,d] = size(S);
XG_n = zeros(h*w,d,NCluster);

for j=1:NCluster
    S_n = S - reshape(repmat(Mu_s(:,i_s(j))',h*w,1),h,w,d);
    Z = (Sigma_s(:,:,i_s(j))^(-0.5))*reshape(S_n,h*w,d)'-sqrt(2/pi)*(Lambda_s(:,i_s(j))/sqrt(1+Lambda_s(:,i_s(j))'*Lambda_s(:,i_s(j))));
    XG_n(:,:,j) = repmat(Gam(:,i_s(j)),1,d).*((Sigma_t(:,:,i_t(j))^0.5)*(Z+sqrt(2/pi)*(Lambda_t(:,i_t(j))/sqrt(1+Lambda_t(:,i_t(j))'*Lambda_t(:,i_t(j)))))+Mu_t(:,i_t(j)))';
end
x_0 = sum(XG_n,3);
X_n = zeros(h,w,d);
for l=1:d
Temp=x_0(:,l);
Temp(Temp>1)=1;
Temp(Temp<0)=0;
X_n(:,:,l) = reshape(Temp,h,w);
end
R   = corrcoef(X_n,S);
PCC = R(1,2);

X_n = uint8(X_n.*255);
S   = uint8(S.*255);
SSIM   = ssim(X_n,S);
