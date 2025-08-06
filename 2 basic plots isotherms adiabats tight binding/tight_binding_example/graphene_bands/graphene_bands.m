%% set up
clear
a = 1;
kx=[-1.2:0.01:1.2].*pi()/a;
ky=[-1.2:0.01:1.2].*pi()/a;
% kx=([-0.5:0.01:0.5]).*pi()/a;
% ky=([-0.5:0.01:0.5]+(4/3)).*pi()/a;
alpha=0; % on site term
g1=1;    % nearest-neighbor transfer (gamma_0)
% g1=0;
g2=0.1;  % next-nearest-neighbor transfer (gamma_0_prime)
% g2=0;   
s12=0.1*g1;  % nearest-neighbor overlap
% s12=0;

f = @(k) 2*cos(k(2)*a*sqrt(3)) + 4*cos(k(1)*a*3/2)*cos(k(2)*a*sqrt(3)/2);

%% valence band

valenceband=@(k) (alpha - g2*f(k) - g1*sqrt(3 + f(k)) ) ...
    /(1 + s12*sqrt(3 + f(k)) );

for(j=1:length(kx))
    for(k=1:length(ky))
        vb(j,k)=valenceband([kx(j) ky(k)]);
    end
end

%% conduction band

conductionband=@(k) (alpha - g2*f(k) + g1*sqrt(3 + f(k)) ) ...
    /(1 - s12*sqrt(3 + f(k)) );

for(j=1:length(kx))
    for(k=1:length(ky))
        cb(j,k)=conductionband([kx(j) ky(k)]);
    end
end

%% plot vb
figure(1);clf
vbs=surf(kx/(pi()/a),ky/(pi()/a),vb');set(vbs,'edgecolor','none')
grid('off')
xlabel('x')
ylabel('y')
view(74,9)
% view(0,90);
xlim([-1.2 1.2]); ylim([-1.2 1.2]); axis square; caxis([-3 3]); colorbar; colormap('jet')
% vbcontour=contour3(gca,kx/(pi()/a),ky/(pi()/a),vb',20,'k-');
%% cb
hold on
cbs=surf(kx/(pi()/a),ky/(pi()/a),cb');set(cbs,'edgecolor','none')
% cbcontour=contour3(gca,kx/(pi()/a),ky/(pi()/a),cb',20,'k-');
% surf([-2:0.1:2],[-2:0.1:2],zeros(length([-2:0.1:2])),'edgecolor',[0.5 0.5 0.5],'facecolor','none')

zlim([-3.5 3.5])
%% pick a roll-up vector
a1=[a*3/2 a*sqrt(3)/2];
a2=[a*3/2 -a*sqrt(3)/2];
n=5;
m=2;
Ch=n*a1 + m*a2;

%% subbands
clear sbx sby sb sbc sbv q

figure(2);clf

for(q=-floor(sqrt(2)*norm(Ch)/(a*sqrt(3))):floor(sqrt(2)*norm(Ch)/(a*sqrt(3))))
    subband=@(t) [ (2*pi()*q*Ch(1)/norm(Ch)^2 - t*Ch(2)/norm(Ch)) ...
      (2*pi()*q*Ch(2)/norm(Ch)^2 + t*Ch(1)/norm(Ch)) ];
    % sb=@(t) conductionband([sbx(t) sby(t)]);
    % t=sqrt(2)*kx;
    t=sqrt(2)*[-2:0.01:2].*pi()/(a*sqrt(3));
    for(j=1:length(t))
        sbx(j)=subband(t(j))*[1;0];
        sby(j)=subband(t(j))*[0;1];
        sbc(j)=conductionband(subband(t(j)));
        sbv(j)=valenceband(subband(t(j)));
    end
    foo=sbx(:)>min(kx) & sbx(:)<max(kx) & sby(:)>min(ky) & sby(:)<max(ky);
    sbx=sbx(foo);
    sby=sby(foo);
    sbc=sbc(foo);
    sbv=sbv(foo);
    t=t(foo);
    if(length(t)>0)
        figure(1);
        hold on
        plot3(sbx/(pi()/a),sby/(pi()/a),sbc,'k-',sbx/(pi()/a),sby/(pi()/a),sbv,'k-')
        figure(2);
        hold on
        plot(t/(pi()/a),sbv,'k-',t/(pi()/a),sbc,'b-');
    end
end

%% subbands in BZ
clear sbx sby sb sbc sbv q

% figure(2);clf

for(q=-floor(sqrt(2)*norm(Ch)/(a*sqrt(3))):floor(sqrt(2)*norm(Ch)/(a*sqrt(3))))
    subband=@(t) [ (2*pi()*q*Ch(1)/norm(Ch)^2 - t*Ch(2)/norm(Ch)) ...
      (2*pi()*q*Ch(2)/norm(Ch)^2 + t*Ch(1)/norm(Ch)) ];
    % sb=@(t) conductionband([sbx(t) sby(t)]);
    % t=sqrt(2)*kx;
    t=sqrt(2)*[-2:0.01:2].*pi()/(a*sqrt(3));
    for(j=1:length(t))
        sbx(j)=subband(t(j))*[1;0];
        sby(j)=subband(t(j))*[0;1];
        sbc(j)=conductionband(subband(t(j)));
        sbv(j)=valenceband(subband(t(j)));
    end
    foo=sbx(:)>min(kx) & sbx(:)<max(kx) & sby(:)>min(ky) & sby(:)<max(ky);
    foo=foo & ( abs(sbx(:)) <= (2/sqrt(3))*pi()/(a*sqrt(3)) ) & ...
        ( abs(sbx(:))*(1/sqrt(3)) + abs(sby(:)) <= (4/3)*pi()/(a*sqrt(3)) );
    sbx=sbx(foo);
    sby=sby(foo);
    sbc=sbc(foo);
    sbv=sbv(foo);
    t=t(foo);
    figure(1);
    hold on
    h=plot3(sbx/(pi()/a),sby/(pi()/a),sbc,'k-',sbx/(pi()/a),sby/(pi()/a),sbv,'k-');
    set(h,'linewidth',2)
    figure(2);
    hold on
    h=plot(t/(pi()/a),sbv,'k-',t/(pi()/a),sbc,'b-');
    set(h,'linewidth',3)
end


