function logw = mylog(x)
x(x<1e-300) = 1e-300;
x(x>=1e300) = 1e300;
logw = log(x);
