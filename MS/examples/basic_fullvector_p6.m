% This example shows how to calculate and plot both the
% fundamental TE and TM eigenmodes of an example 3-layer ridge
% waveguide using the full-vector eigenmode solver.  

% Refractive indices:
n1 = 3.34;          % Lower cladding
n2 = linspace(3.305,3.44,10);          % Core - ridge index
n3 = 1.00;          % Upper cladding (air)

% Layer heights:
h1 = 2.0;           % Lower cladding
h2 = 1.3;           % Core thickness
h3 = 0.5;           % Upper cladding

% Horizontal dimensions:
rh = 1.1;           % Ridge height
rw = 1.0;           % Ridge half-width
side = 1.5;         % Space on side

% Grid size:
dx = 0.0125;        % grid size (horizontal)
dy = 0.0125;        % grid size (vertical)

lambda = 1.55;      % vacuum wavelength
nmodes = 1;         % number of modes to compute

neff = nan(10);


for i = 1:10
    % First consider the fundamental TE mode:
    [x,y,xc,yc,nx,ny,eps,edges] = waveguidemesh([n1,n2(i),n3],[h1,h2,h3], ...
                                            rh,rw,side,dx,dy); 

    [Hx,Hy,neff(i)] = wgmodes(lambda,n2(i),k,dx,dy,eps,'000A');
    
    fprintf(1,'neff = %.6f\n',neff(i));
    
    figure(i);
    subplot(121);
    contourmode(x,y,Hx(:,:,1)); % add index Hx(:,:,nmodes)
    title('Hx (TE mode)'); xlabel('x'); ylabel('y'); 
    for v = edges, line(v{:}); end
    hold off
    
    subplot(122);
    contourmode(x,y,Hy(:,:,1));
    title('Hy (TE mode)'); xlabel('x'); ylabel('y'); 
    for v = edges, line(v{:}); end
    hold off
    
end

figure(11);
plot(n2,neff);
grid on;
title('neff vs Ridge Index');
xlabel('Ridge Index');
ylabel('neff');
