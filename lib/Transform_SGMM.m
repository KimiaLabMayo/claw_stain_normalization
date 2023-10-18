function [X_n,SSIM,PCC] = Transform_SGMM(S,T,M_t,S_t,M_s,S_s,Gam,id_s,id_t,NCluster)
T_hsd=RGB2HSD(T);
TD = T_hsd(:,:,1);
S_hsd=RGB2HSD(S);
SD = S_hsd(:,:,1);
for i=1:NCluster
lab_t(i) = mean2(TD(id_t==i));
lab_s(i) = mean2(SD(id_s==i));
end
[~,i_t] = sort(lab_t);
[~,i_s] = sort(lab_s);

[h,w,d] = size(S);
XG_n = zeros(h*w,d,NCluster);
for j=1:NCluster
    S_n = S - reshape(repmat(M_s(i_s(j),:),h*w,1),h,w,d);
    Z = (S_s(:,:,i_s(j))^(-0.5))*reshape(S_n,h*w,d)';
    XG_n(:,:,j) = repmat(Gam(:,i_s(j)),1,d).*((S_t(:,:,i_t(j))^0.5)*Z+M_t(i_t(j),:)')';
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
S = uint8(S.*255);
SSIM   = ssim(X_n,S);

