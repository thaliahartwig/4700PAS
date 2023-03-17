
close all
clear
clc

% Task 2 --------------------------------------------------------
Is = 0.01e-12;
Ib = 0.1e-12;
Vb = 1.3;
Gp = 0.1; % admittance

IC = @(Vi) Is.*(exp(Vi*1.2/0.025)-1) + Gp.*Vi - Ib.*(exp(-(Vi+Vb)*1.2/0.025)-1);
V = linspace(-1.95, 0.7, 200);
I = IC(V);
Ir = 0.2.*randn(1,200);
In = I + Ir;


% Task 3 --------------------------------------------------------
p4 = polyfit(V,In,4);
p8 = polyfit(V,In,8);

f4 = polyval(p4,V);
f8 = polyval(p8,V);

% Task 4 --------------------------------------------------------
f0 = fittype('A.*(exp(1.2*x/25e-3)-1) + B.*x - 0.1e-12*(exp(1.2*(-(x+1.3))/25e-3)-1)');
ff_AB = fit(V.',In.',f0);


f0 = fittype('A.*(exp(1.2*x/25e-3)-1) + B.*x - C*(exp(1.2*(-(x+1.3))/25e-3)-1)');
ff_ABC = fit(V.',In.',f0);

f0 = fittype('A.*(exp(1.2*x/25e-3)-1) + B.*x - C*(exp(1.2*(-(x+D))/25e-3)-1)');
ff_all = fit(V.',In.',f0);




% Task 5 --------------------------------------------------------
inputs = V.';
targets = In.';
hiddernLayerSize = 10;
net = fitnet(hiddernLayerSize);
net.divideParam.trainRatio = 70/100;
net.divideParam.valRatio = 15/100;
net.divideParam.testRatio = 15/100;
[net,tr] = train(net,inputs,targets);
outputs = net(inputs);
errors = gsubtract(outputs,targets);
performance = perform(net,targets, outputs);
view(net)
Inn = outputs;



% Final Plot ----------------------------------------------------
figure('name', 'PA 8 - Plots');
subplot(2,3,1);
plot(V, In, 'b'); hold on
plot(V,f4,'g',V,f8,'m');
title('polyfit() & polyval()')
xlabel('Voltage, V');
ylabel('Current, A');
legend('Noise','4^t^h order', '8^t^h order');
hold off;

subplot(2,3,4);
semilogy(V, abs(In), 'b'); hold on
semilogy(V,abs(f4),'g',V,abs(f8),'m');
legend('Noise','4^t^h order', '8^t^h order');
title('polyfit() & polyval()')
xlabel('Voltage, V');
ylabel('Current, A');
hold off;

subplot(2,3,2);
plot(V, In, 'b'); hold on
plot(V,ff_AB(V),'g',V,ff_ABC(V),'m',V, ff_all(V));
xlabel('Voltage, V');
ylabel('Current, A');
title('fittype() & fit()');
legend('Noise','2 parameter', '3 parameter','4 parameter');
hold off;

subplot(2,3,5);
semilogy(V, abs(In), 'b'); hold on
semilogy(V,abs(ff_AB(V)),'g',V,abs(ff_ABC(V)),'m',V, abs(ff_all(V)));
xlabel('Voltage, V');
ylabel('Current, A');
title('fittype() & fit()');
legend('Noise','2 parameter', '3 parameter','4 parameter');
hold off;

subplot(2,3,3);
plot(V, In, 'b'); hold on
plot(V,Inn);
xlabel('Voltage, V');
ylabel('Current, A');
title('NN');
legend('Noise','Neural');
hold off;

subplot(2,3,6);
semilogy(V, abs(In), 'b'); hold on
semilogy(V,abs(Inn));
xlabel('Voltage, V');
ylabel('Current, A');
title('NN');
legend('Noise','Neural');
hold off;


