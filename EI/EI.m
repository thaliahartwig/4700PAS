% Thalia Hartwig - PA 5
set(0,'DefaultFigureWindowStyle','docked')
set(0,'defaultaxesfontsize',18)
set(0,'defaultaxesfontname','Times New Roman')

close all
clear

ni = @(x,y,cs) y + (x - 1)*cs;
% Simulation Parameters
nx = 50;
ny = 50;
dl = 1; % = dx = dy

% Simulation Setup
G = sparse(nx*ny,nx*ny);
V = zeros(nx,ny); % solution space

% inclusion = 0; 

% Populating G
for i = 1:nx
  for j = 1:ny
    % Determining column-major addressing
    n   = ni(  i,  j,ny);
    
    if i == 1 % left boundary
      G(n,:) = 0;
      G(n,n) = 1;
    elseif i == nx % right boundary
      G(n,:) = 0;
      G(n,n) = 1;
    elseif j == 1 % boundary
      G(n,:) = 0;
      G(n,n) = 1;
    elseif j == ny % boundary
      G(n,:) = 0;
      G(n,n) = 1;
    else % bulk calculation
      nxp = ni(i+1,  j,ny);
      nxm = ni(i-1,  j,ny);
      nyp = ni(  i,j+1,ny);
      nym = ni(  i,j-1,ny);

      G(n,n) = - 4/power(dl,2);
      G(n,nxp) = 1/power(dl,2);
      G(n,nxm) = 1/power(dl,2);
      G(n,nyp) = 1/power(dl,2);
      G(n,nym) = 1/power(dl,2);
    end
  end
end

figure('name','G Matrix - spy(G)');
spy(G);

n_eigs = 9;
[E,D] = eigs(G,n_eigs,'SM'); % 'SM' means smallest magnitude

figure('name','EigenValues');
plot(diag(D), '*');



% Question: compare with 12.09
np = ceil(sqrt(n_eigs)); % number of plot grid
figure('name','EigenVectors - Modes');
for k = 1:n_eigs
  m = E(:,k); % eigenvector for specific mode
  for i = 1:nx
    for j = 1:ny
      n = ni(i,j,ny);
      V(i,j) = m(n);
    end
    subplot(np,np,k);
    surf(V,'linestyle','none');
    % surf(-V,'linestyle','none');
    title(['EV = ' num2str(D(k,k))]);
  end
end


