function fit=mymodel(X,irf,time,fit_times)

A(1)=X(1);
tau(1)=X(2);
A(2)=X(3);
tau(2)=X(4);
c=X(5);

% calculate proposed response
R=ones(size(time));

for(j=1:length(time))
    for(k=1:length(A))
        R(j)=R(j)+A(k)*exp(-(time(j))/tau(k));
    end
end

% convolve and add background
fit=c+conv(R,irf./sum(irf));
% fit=irf;

% crop to desired time region
fit=fit(fit_times);
