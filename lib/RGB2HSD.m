function X_HSD = RGB2HSD(X)
for i=1:3
    x = X(:,:,i);
    x(x==0) = 1e-10;
    X(:,:,i) = x;
end  
OD = -log(X/1);
D  = mean(OD,3);
D(D==0) = 1e-10;
    
cx = OD(:,:,1)./D - 1;
cy = (OD(:,:,2)-OD(:,:,3)) ./ (sqrt(3)*D);
            
X_HSD(:,:,1) = D;
X_HSD(:,:,2) = cx;
X_HSD(:,:,3) = cy;
end
    