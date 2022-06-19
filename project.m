close all
clear
clc

[signal, fs] = audioread('Lisa_noise.wav'); % 讀取得到取樣頻率 fs=44100Hz
signal = signal(:,1); % 由於音檔有多個相似頻道，為了降低計算，將其中一個頻道的訊號取出
% 2. 透過soundsc播放出音檔，由於音檔很長，為了減少播放時間，只取前100000個取樣點
soundsc(signal(1:100000),fs) 
% 設計 LPF
LPF = lowpass(signal,0.25); % 截止頻率為 0.25*44100/2 Hz
pause(2)
soundsc(LPF(1:100000),fs)

% 再次播放後雜訊仍無法消除
% 3. 試著將頻譜圖畫出分析雜訊性質
Sig = fftshift(fft(signal)); % 使用FFT計算頻譜值
freq_axis = linspace(-fs/2,fs/2,length(Sig)); % 設定繪圖頻率軸
% 將頻譜繪出
figure(1)
plot(freq_axis,abs(Sig))
xlabel('Hz')
ylabel('mag')
title('spectrum')

% 大約每300Hz就會有一個脈衝
% 找到左右兩邊的第一個脈衝大致位於21900Hz，因此
pulse = -21900:300:21900; % 將脈衝出現的位置找出來
for kk = 1:numel(pulse)
    [val,ind] = min(abs(freq_axis-pulse(kk))); % 藉由上面肉眼查看的脈衝位置將實際的軸座標索引找出
    reduction_ratio = 0.1; % 抑制強度，0.1表示該處頻率強度僅有原本0.1倍
    Sig(ind-7:ind+7) =  reduction_ratio*Sig(ind-7:ind+7); % 抑制該頻率附近的訊號以降低雜訊
end
% 畫出處理過後的頻譜
figure(2)
plot(freq_axis,abs(Sig))
xlabel('Hz')
ylabel('mag')
title('filtered signal')
signal = ifft(fftshift(Sig));
signal = real(signal);
pause(2)
% 播放處理後的聲訊
soundsc(signal,fs) 
% 由第一章圖可以知道雜訊參雜於訊號內，因此只能最大限度的去除雜訊，並無法完全消除，否則音樂會失真

% ouput to the .wav file : 
% the sampling frequency is 44100 1/s
% the bits revolution is : 16
Fs = 44.1E+3;         % Sampling Frequency
nBits = 16;           % Bit Resolution
audiowrite('Processed_Lisa.wav', signal, Fs, 'BitsPerSample', nBits, 'Comment','Lisa - Processed');

%%
clc
clear

A = [1 1 -2; 0 1 1; 0 0 1];
B = [1 0 1]';
C = [2 0 0];
k = [15 47 -8];
A_f = A - B*k;
s_model = ss(A_f, B, C, 0)
tf(s_model)

%%
% original plant

A = [1 1 -2; 0 1 1; 0 0 1];
B = [1 0 1]';
C = [2 0 0];
s_model = ss(A,B,C,0);
tf(s_model)


