function [Y,Xf,Af] = MLEBGGReg(X,~,~)
% MLEBGG Predictor which a 10-layered CNN
% Designed by Amang Kim
%

% Input 1
x1_step1.xoffset = [0;6;1];
x1_step1.gain = [0.333333333333333;0.111111111111111;0.0869565217391304];
x1_step1.ymin = -1;

% Layer 1
b1 = [3.771741488616147997;-3.2659512095309324309;-0.28583286042678657246;-1.2059095717080392518;-0.34425199519418614447;-1.9028954699788438454;0.16263105185445214662;-1.9054084188842088654;-1.3948316503642712583;-4.6841400047713346311];
IW1_1 = [-2.3369401657573285469 -1.7844000408352194142 3.0490185254236812362;0.61580617055358899403 -4.1597237321280600142 -2.9894496111966120111;0.69884505076413327984 -0.47986810342756952563 -1.5474469211556827197;-0.75511467832220102725 -3.5656339100501250883 -0.79195188527261084488;1.9406174284265209629 1.5288722842182673745 2.4387731224893647308;2.5012406651076437569 4.837032206431478798 4.153603263375456045;1.2651762601158571542 3.851829556305946145 -0.40285880927128081552;-0.70570210094539631562 -0.36785689792569425949 -0.078779385927863848638;-2.6973945012380609043 -2.0506384922385727521 2.5481607914377208957;-0.48876581187995055133 -2.0187960568218934476 -2.4221117982279118941];

% Layer 2
b2 = 0.87998176249500947854;
LW2_1 = [-0.75394016738232183528 0.15906215584273741825 -0.43983523967286181078 -0.11530330584996695276 -0.27704990170348375855 0.504512230335902645 -0.041448862981110577708 1.342299370299753658 0.036199600578349921953 -1.2205334320334195741];

% Output 1
y1_step1.ymin = -1;
y1_step1.gain = 0.104166666666667;
y1_step1.xoffset = 9.6;

% ===== SIMULATION ========

% Format Input Arguments
isCellX = iscell(X);
if ~isCellX
    X = {X};
end

% Dimensions
TS = size(X,2); % timesteps
if ~isempty(X)
    Q = size(X{1},2); % samples/series
else
    Q = 0;
end

% Allocate Outputs
Y = cell(1,TS);

% Time loop
for ts=1:TS
    
    % Input 1
    Xp1 = mapminmax_apply(X{1,ts},x1_step1);
    
    % Layer 1
    a1 = tansig_apply(repmat(b1,1,Q) + IW1_1*Xp1);
    
    % Layer 2
    a2 = repmat(b2,1,Q) + LW2_1*a1;
    
    % Output 1
    Y{1,ts} = mapminmax_reverse(a2,y1_step1);
end

% Final Delay States
Xf = cell(1,0);
Af = cell(2,0);

% Format Output Arguments
if ~isCellX
    Y = cell2mat(Y);
end
end

% ===== MODULE FUNCTIONS ========

% Map Minimum and Maximum Input Processing Function
function y = mapminmax_apply(x,settings)
y = bsxfun(@minus,x,settings.xoffset);
y = bsxfun(@times,y,settings.gain);
y = bsxfun(@plus,y,settings.ymin);
end

% Sigmoid Symmetric Transfer Function
function a = tansig_apply(n,~)
a = 2 ./ (1 + exp(-2*n)) - 1;
end

% Map Minimum and Maximum Output Reverse-Processing Function
function x = mapminmax_reverse(y,settings)
x = bsxfun(@minus,y,settings.ymin);
x = bsxfun(@rdivide,x,settings.gain);
x = bsxfun(@plus,x,settings.xoffset);
end
