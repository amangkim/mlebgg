% mlebgg_tauplot

AS = min(A_k_1);
AE = max(A_k_1);
HS = min(H_k_1);
HE = max(H_k_1);

A0 = mean(A00);
%AK = [AS:0.1:AE];
%HK = [HS:0.1:HE];

%eps = 10^(floor((log(AE)/log(10)))-3)
eps = 0.05;
AK = [AS:eps:AE];
HK = [HS:eps:HE];


tau_nu_1_map =[];

lenA = length(AK)
lenH = length(HK);
count = 0;

for i = 1:lenA
    for j = 1:lenH
        
        A_nu_1 = AK(i);
        H_nu_1 = HK(j);
        In_ML = [A0;A_nu_1;H_nu_1];
        tau_nu_1_map (i,j) = MLEBGGReg(In_ML);
        %count = count +1;
        %Progress = count/(lenA*lenH)
    end
end

figure
hold on
grid on
ax = gca;
%ax.ZLim = [0.9*min(min(tau_nu_1_map)) 1.1*max(max(tau_nu_1_map))];
title(['The moment of executing the safety mode']);
xlabel([{'Honest nodes', 'H_{nu-1}'}]);
ylabel({'Attack nodes', 'A_{nu-1}'});
zlabel({'Tau_{nu-1} (Time)'});

mesh(HK,AK,tau_nu_1_map)
%surf(HK,AK,tau_nu_1p)
hold off