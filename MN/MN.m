% PA 7 - MNA Building
clear
close all;
% Parameter Definition
G1 = 1; Ca = 0.25; G2 = 1/2; L = 0.2; G3 = 1/10;
a = 100; G4 = 1/0.1; G0 = 1/1000;

% Derived Equations:
% [1] N1 = Vin
% [2] (N1 - N2)G1 + Cd(N1 - N2)/dt - N2G2 - I3 = 0
% [3] I3 - N3G3 = 0
% [4] N2 -N3 - L(dI3/dt) = 0
% [5] N4 - aI3 = 0
% [6] (N4 - N5)G4 - N5G0 = 0
% [7] N5 - V0 = 0

% Matrices
% Equation form: C(dV/dt) + GV + B = F
Vin = -10:1:10;

%  V = [N1 N2 I3 N3 N4 N5 V0]
G = [ 1 0 0 0 0 0 0;
      G1 -(G1+G2) -1 0 0 0 0;
      0 0 1 -G3 0 0 0;
      0 1 0 -1 0 0 0;
      0 0 -a 0 1 0 0;
      0 0 0 0 G4 -(G4+G0) 0;
      0 0 0 0 0 1 -1];

%  V = [N1 N2 I3 N3 N4 N5 V0]
C = [ 0 0 0 0 0 0 0;
      Ca -Ca 0 0 0 0 0;
      0 0 0 0 0 0 0;
      0 0 -L 0 0 0 0;
      0 0 0 0 0 0 0;
      0 0 0 0 0 0 0;
      0 0 0 0 0 0 0];


Vin = -10:1:10;
for i = 1:length(Vin)
    F = [Vin(i) 0 0 0 0 0 0]';
    V(:,i) = (C + G)\F;
end

figure('name', 'PA 7')
subplot(2,2,1);
plot(Vin, V(4,:), 'b', Vin, V(7,:))
title('DC Sweep');
xlabel('V_I_N');
ylabel('V')
legend('V_3', 'V_O');

Vin = 10;
w = 0:100;
for i = 1:length(w)
    F = [Vin 0 0 0 0 0 0]';
    V(:,i) = (1i*w(i)*C + G)\F;
end

Gain_V0 = V(7,:)./Vin;
Gain_V3 = V(4,:)./Vin;
subplot(2,2,2);
plot( w, (abs(Gain_V3)), 'b', w, (abs(Gain_V0)));
title('AC Sweep');
xlabel('\omega');
ylabel('|V|')
legend('V_3/V_I_N', 'V_O/V_I_N');


nSamp = 500;
std = 0.05;
Cap = std.*randn(nSamp,1) + Ca;
w = 3*pi;
nbins = 10; 
F = [Vin 0 0 0 0 0 0]';


subplot(2,2,3);
histogram(Cap,nbins);
title('C Pertrubation');
xlabel('C');
ylabel('Number');

for i = 1:nSamp
    C = [ 0 0 0 0 0 0 0;
      Cap(i) -Cap(i) 0 0 0 0 0;
      0 0 0 0 0 0 0;
      0 0 -L 0 0 0 0;
      0 0 0 0 0 0 0;
      0 0 0 0 0 0 0;
      0 0 0 0 0 0 0];
    V(:,i) = (1i*w*C + G)\F;
end


Gain = abs(V(7,:)./Vin);
subplot(2,2,4);
histogram(Gain,nbins);
title('Magnitude Distribution');
xlabel('V_O/V_I_N');
ylabel('Number')













