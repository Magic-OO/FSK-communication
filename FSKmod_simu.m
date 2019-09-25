%--------------------------------------------------------------------------
% FSK_mod_simu.m
% Description : A MATLAB program to simulate FSK modulation
% Input       : None
% Output      : None
% Author      : KouXin                                              
%--------------------------------------------------------------------------
clc
clear
close all

%% 系统配置
sampleRate = 2000;                          % 采样率
dt = 1 / sampleRate;                        % 采样时间间隔
SimBitsNum = 20;                            % 模拟比特数
bitTime = 1;                                % 1bit持续的时间
bitSampleNum = sampleRate * bitTime;        % 1bit的采样点数
totalTime = bitTime * SimBitsNum;           % 总时间
totalSampleNum = sampleRate * totalTime;    % 采样点的个数
t = 0:dt:(totalTime - dt);                  % SimBitsNum个比特所持续的时间
t = t';                                     % 转置成列向量'
f1 = 60;                                    % 载频1的模拟频率(Hz)
f2 = 300;                                   % 载频2的模拟频率(Hz)
SNR = 2;                                    % 信噪比（单位：dB）

%% 产生发送比特
rng(1e3)
sendBits = round(rand(1, SimBitsNum));              % 模拟发送的比特
sendBitsReverse = ~sendBits;

% 根据产生的比特生成相应的方波
sendBitsSample = (ones(1, bitSampleNum))' * sendBits; %'
sendBitsSample = sendBitsSample(:);                 % 转换成列向量
sendBitsReverseSample = (ones(1, bitSampleNum))' * sendBitsReverse; %'
sendBitsReverseSample = sendBitsReverseSample(:);   % 转换成列向量
 
%% FSK调制
fsk1 = sendBitsSample .* cos(2 * pi * f1 .* t);
fsk2 = sendBitsReverseSample .* cos(2 * pi * f2 .* t);
fsk = fsk1 + fsk2;
figure
subplot(211)
plot(fsk)
axis([0 totalSampleNum min(fsk)-0.2 max(fsk)+0.2]);
grid on
title('FSK调制之后的时域波形')
 
%% 添加噪声
% ====== AWGN noise ====== 
noisePower  = 10^(-SNR/10);
noise       = sqrt(noisePower) * (randn(length(fsk), 1));
fskSigWithNoise = fsk + noise;
subplot(212)
plot(fskSigWithNoise)
axis([0 totalSampleNum min(fskSigWithNoise)-0.2 max(fskSigWithNoise)+0.2]);
grid on
title('添加噪声之后的时域波形')
