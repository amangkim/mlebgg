% MLEBGG Testing Demo v0.1
%
% Training Set Information
%   Lambda_A:  0.5167
%   Lambda_H:  0.4833
%       Delta: 1.2000
%           M: 25
%       ENu_1: 20
%          A0: [1×1000 double]
%      A_nu_1: [1×1000 double]
%      A_nu_0: [1×1000 double]
%      H_nu_1: [1×1000 double]
%      H_nu_0: [1×1000 double]
%        Nu_1: [1×1000 double]
%           B: [0 2 3 13]
%       alpha: [0 0.1600 0.2400 1.0400]


clear all
S = load('MLEBGG_testing_set_v01.mat');
M=S.M;
Mo2 = S.M/2;

%B = 2*S.B(3)
B = 3*3 % Determined from Training
alpha = B/Mo2

A00 = S.A0;
A_k_1 = S.A_nu_1;
H_k_1 = S.H_nu_1;
A_k_0 = S.A_nu_0;
H_k_0 = S.H_nu_0;
Nu_1 = S.Nu_1;
LamA = S.Lambda_AH(1);
LamH = S.Lambda_AH(2);
delta = S.Delta;
TestTrial = length(A_k_1);
S_p = [];
S_r = [];
TestResult = [];
Burstcount = 0;


for i = 1:TestTrial
    
    SafetyMode = -1;
    
    A0 = A00(i);
    A_nu_1 = A_k_1(i);
    H_nu_1 = H_k_1(i);
    A_nu = A_k_0(i);
    H_nu = H_k_0(i);
    nu_1 = Nu_1(i);
    tau_nu_1r = nu_1 * delta;
    
    if A_nu<Mo2
        %SM_Real = 0;
        SM_Real = [1 0 0];
    elseif A_nu>=Mo2 && A_nu<=Mo2+B
        %SM_Real = 1;
        SM_Real = [0 1 0];
    else
        %SM_Real = 2;
        SM_Real = [0 0 1];
        Burstcount = Burstcount+1; 
    end
    
    In_ML = [A0;A_nu_1;H_nu_1];
    tau_nu_1p = MLEBGGReg(In_ML);
    
    BGG = BGGEngine(tau_nu_1p,A_nu_1,H_nu_1,LamA, LamH, delta, M, B);
    SM_Predict = BGG.OffSetArray;
   
        
    if SM_Real == SM_Predict
        flag = 1;
    else
        flag =0;
    end
    S_r = [S_r; SM_Real];
    S_p = [S_p; SM_Predict];
    TestResult = [TestResult; flag];
    
end


figure
CM = plotconfusion(S_r',S_p');


Accuracy = sum(TestResult)
Burstcount
mlebgg_tauplot