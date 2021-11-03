% MLEBGG setup
% Initial values for MLEBGG
% This set up could be applied for either Training or Testing or both
% Made by Amang Kim


Trial = 100;
H_0 = 0;

%-------------------Ethereum nodes
%M = 11259; % Ethereum nodes
%delta = 12; % Ethereum PoW [sec]
%lambda_A = 3.3;
%lambda_H = 3;
%A_0 = 5;
%---------------------------------

%------------------------- Bitcoin
%M = 83000; % Bitcoin nodes
%delta = 10; % Bitcoin PoW [min]
%lambda_A = 3.3*60;
%lambda_H = 3*60;
%A_0 = 5*60;
%---------------------------------

%--------------------------- EBIoV
%M = 250; % EBIoV nodes
M=25;
delta = 1.2; % Observation [min]
lambda_A = 3.3;
lambda_H = 3;
lambda_A = 31/60;
lambda_H = 29/60;
A_0 = 5;
%---------------------------------


%--------------------
Mo2 = (M/2);

Nubar_0 = ceil(Mo2/(lambda_A*delta));
Nubar_1 = Nubar_0-1;
TauBar_1 = delta*Nubar_1;
%pause;
%---------------------




