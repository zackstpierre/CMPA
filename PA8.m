%PA8
%Zachary St. Pierre
%101094217

clear
close all
clc

Is = 0.01e-12;
Ib = 0.1e-12;
Vb = 1.3;
Gp = 1/0.1;


V = linspace(-1.95,0.7,200);

for i=1:length(V)
    
    I(i) = Is * exp((1.2/0.025)*V(i)-1) + Gp * V(i) - Ib *  exp((-1.2/0.025)*(V(i)+Vb)-1);

end

randvar = rand(1,length(I)) *0.4 + 0.8;
I_20 = I .* randvar;

figure()
plot(V,I_20)


p1=polyfit(V,I_20,4);
p2 = polyfit(V,I_20,8);

V2 = linspace(-1.95,0.7);
I2 = polyval(p1,V2);

I3 = polyval(p2,V2);

figure()

plot(V2,I2)
hold on
plot(V2,I3)


fo = fittype("A.*(exp(1.2*x/25e-3)-1) + (1/0.1).*x - C*(exp(1.2*(-(x+1.3))/25e-3)-1)");
ff = fit(V',I_20',fo);
f = ff(V);

fo2 = fittype("A.*(exp(1.2*x/25e-3)-1) + B.*x - C*(exp(1.2*(-(x+1.3))/25e-3)-1)");
ff2 = fit(V',I_20',fo2);
f2 = ff(V);

fo3 = fittype("A.*(exp(1.2*x/25e-3)-1) + B.*x - C*(exp(1.2*(-(x+D))/25e-3)-1)");
ff3 = fit(V',I_20',fo3);
f3 = ff(V);

figure()
plot(f)
hold on
plot(f2)
hold on
plot(f3)

inputs = V.';
targets = I.';
hiddenLayerSize = 10;
net = fitnet(hiddenLayerSize);
net.divideParam.trainRatio = 70/100;
net.divideParam.valRatio = 15/100;
net.divideParam.testRatio = 15/100;
[net,tr] = train(net,inputs,targets);
outputs = net(inputs);
errors = gsubtract(outputs,targets);
performance = perform(net,targets,outputs)
view(net)
Inn = outputs

