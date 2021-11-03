function BGG = BGGEngine(varargin)
% BGG Egnine
% Made by Amang Kim


%------------------------------------
inputs={'Tau_nu_1', 'Anu_1', 'Hnu_1', 'LamA', 'LamH', 'Delta', 'Nodes', 'Backup'};
MLEBGG_setup;
LamA = lambda_A;
LamH = lambda_H;
Delta = delta;
Nodes = M;
Backup = ceil(M/2);

for n=1:nargin
    if(~isempty(varargin{n}))
        eval([inputs{n} '=varargin{n};'])
    end
end
%------------------------------------

tau_1 = Tau_nu_1;
M = Nodes;
Mo2 = M/2;
B = Backup;

Offset = -1;
OffsetArray = [];

Xk = LamA*Delta;
Yk = LamH*Delta;

A_nu = Anu_1 + Xk;
H_nu = Hnu_1+ Yk;
tau_nu = tau_1 + Delta; 

if (A_nu < Mo2)
    Offset = 0; %--- OverProvisioned
    OffsetArray = [1 0 0];
else
    if(A_nu < Mo2+B || H_nu > Mo2)
        Offset = 1;  %--- Safety Sucess
        OffsetArray = [0 1 0];
    else
        Offset = 2;  %--- Burst
        OffsetArray = [0 0 1];
    end
end

S.Offset = Offset;
S.OffSetArray = OffsetArray;
S.Nu = ceil(tau_nu/Delta);
S.A_nu = A_nu;
S.H_nu = H_nu;
S.Tau_nu = tau_nu;

BGG = S;
end

