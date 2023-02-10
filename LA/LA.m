% Thalia Hartwig - PA 4
set(0,'DefaultFigureWindowStyle','docked')
set(0,'defaultaxesfontsize',18)
set(0,'defaultaxesfontname','Times New Roman')

close all
clear

% Simulation Parameters
nx = 100 + 2; % size includes boundary conditions
ny = 100 + 2; % size includes boundary conditions
ni = 10000;   % number of iterations
V  = zeros(nx,ny);

% Boundary Conditions
xbc_min = 1;
xbc_max = nx;
ybc_min = 1;
ybc_max = ny;

% Boundary Excitations
t_exc = 0; % top
b_exc = 0; % bot
l_exc = 1; % left
r_exc = 1; % right

% Simulation Setup
V(xbc_min,:) = t_exc; % top
V(xbc_max,:) = b_exc; % bottom
V(:,ybc_min) = l_exc; % left
V(:,ybc_max) = r_exc; % right

Vf = V; % duplicating V for usage with 'imboxfilt'

% Simulation - Laplace Transform --------------------------------------
insulate_en = 1; % sets dV/dy = 0 if true 
figure('name', 'Surface')
for k = 1:ni
  for i = 2:nx-1
    for j = 2:ny-1
      V(i,j) = 0.25*(V(i+1,j) + V(i-1,j) + (V(i,j+1) + V(i,j-1)));
      if insulate_en
          if i == 2
              V(i-1,j) = V(i,j);
          end
          V(i+1,j) = V(i,j); % do no require conditional here
      end
    end
  end
  if mod(k,50) == 0
    surf(V(2:nx-1,2:ny-1));
    pause(0.05);
  end 
end

[Ex, Ey] = gradient(V(2:nx-1,2:ny-1));

figure('name','Gradient - Quiver')
quiver(-Ey',-Ex',1);

% Simulation - Laplace Transform --------------------------------------
% Implementation using 'imboxfilt'
figure('name', 'Surface - imboxfilt(Vf)')
for k = 1:ni
  Vf = imboxfilt(Vf);
  % resetting boundary conditions
  Vf(:,ybc_min) = l_exc; % left
  Vf(:,ybc_max) = r_exc; % right
  if insulate_en
    for i = 2:nx -1
      for j = 2:ny-1
        if i == 2
          Vf(i-1,j) = Vf(i,j);
        end
        Vf(i+1,j) = Vf(i,j);
      end
    end
  else
    Vf(xbc_min,:) = t_exc; % top
    Vf(xbc_max,:) = b_exc; % bottom
  end

  if mod(k,50) == 0
    surf(Vf(2:nx-1,2:ny-1));
    pause(0.05);
  end 
end

[Exf,Eyf] = gradient(Vf(2:nx-1,2:ny-1));

figure('name','Gradiant - Quiver (imboxfilt(Vf)')
quiver(-Eyf',-Exf',1);


