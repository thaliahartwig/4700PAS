winstyle = 'docked';
% winstyle = 'normal';

set(0,'DefaultFigureWindowStyle',winstyle)
set(0,'defaultaxesfontsize',18)
set(0,'defaultaxesfontname','Times New Roman')
% set(0,'defaultfigurecolor',[1 1 1])

% clear VARIABLES;
clear
close all

% declares constants as global parameters
global spatialFactor;
global c_eps_0 c_mu_0 c_c c_eta_0
global simulationStopTimes;
global AsymForcing
global dels
global SurfHxLeft SurfHyLeft SurfEzLeft SurfHxRight SurfHyRight SurfEzRight



dels = 0.75;
spatialFactor = 1;

c_c = 299792458;                  % speed of light
c_eps_0 = 8.8542149e-12;          % vacuum permittivity
c_mu_0 = 1.2566370614e-6;         % vacuum permeability
c_eta_0 = sqrt(c_mu_0/c_eps_0);


tSim = 200e-15;       % simulation time 
f = 150e12; %230e12; % Part 4c
lambda = c_c/f;       % wavelength

xMax{1} = 20e-6;
nx{1} = 200;         % describes the number of x points in the inclusion region
ny{1} = 0.75*nx{1};  % describes the number of y points in the inclusion region

Reg.n = 1; 
mu{1} = ones(nx{1},ny{1})*c_mu_0;    % sets a constant permeability

epi{1} = ones(nx{1},ny{1})*c_eps_0;  % sets a constant permitivity
% The 'inclusion'  (Part 3c.i) 
% By commenting out the inclusion region the code still works, the only
% difference is gaussian pulse continues proagation without reflection.
epi{1}(125:150,55:95)= c_eps_0*11.3;
% epi{1}(125:150,5:)= c_eps_0*11.3;

% creating another inclusion region
epi{1}(100:125,70:80)= c_eps_0*11.3;
epi{1}(75:100,55:69)= c_eps_0*11.3; % Part 5a
epi{1}(75:100,81:95)= c_eps_0*11.3; % Part 5a

sigma{1} = zeros(nx{1},ny{1});
sigmaH{1} = zeros(nx{1},ny{1});

dx = xMax{1}/nx{1};
dt = 0.25*dx/c_c;
nSteps = round(tSim/dt*2);
yMax = ny{1}*dx;
nsteps_lamda = lambda/dx

movie = 1;
Plot.off = 0;
Plot.pl = 0;
Plot.ori = '13';
Plot.N = 100;
Plot.MaxEz = 1.1;
Plot.MaxH = Plot.MaxEz/c_eta_0;
Plot.pv = [0 0 90];
Plot.reglim = [0 xMax{1} 0 yMax];

% Part 3c.ii - The 'bc' struct is used for boundary conditions of the simulation
bc{1}.NumS = 2;
% Part 3c.iii - The 'bc.s(1)' sets up the source location of the source
bc{1}.s(1).xpos = nx{1}/(4) + 1; % changes the position of the source
bc{1}.s(1).type = 'ss';
bc{1}.s(1).fct = @PlaneWaveBC;
% mag = -1/c_eta_0;
% Part 5b
bc{1}.s(2).xpos = nx{1}/(2) + 1; % changes the position of the source
bc{1}.s(2).type = 'ss';
bc{1}.s(2).fct = @PlaneWaveBC;
mag = 1;
phi = 0;
omega = f*2*pi;
betap = 0;
t0 = 30e-15;
st = -0.05; %15e-15; % Part 4b - changes intensity
s = 0;
y0 = yMax/2;
sty = 1.5*lambda;
bc{1}.s(1).paras = {mag,phi,omega,betap,t0,st,s,y0,sty,'s'};
bc{1}.s(2).paras = {mag,phi,omega,betap,t0,st,s,yMax*0.80,sty,'s'};

Plot.y0 = round(y0/dx);

% Part 3c.iv - Theses define the material behaviour surrounding the sim
bc{1}.xm.type = 'a';
% when set to 'e' the positive x-axis boundary becomes reflective
bc{1}.xp.type = 'a';
bc{1}.ym.type = 'a';
bc{1}.yp.type = 'a';

pml.width = 20 * spatialFactor;
pml.m = 3.5;

Reg.n  = 1;
Reg.xoff{1} = 0;
Reg.yoff{1} = 0;

RunYeeReg






