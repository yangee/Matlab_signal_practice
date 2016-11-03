%% Define Time Vector
samplingFrequency = 1000; %Hz
timeStep = 1/samplingFrequency; %sec
T= 1; %sec
S = T*samplingFrequency; %samples
samples = 1:S; % samples
time = samples*timeStep; %sec

%% Generate Square Wave
pulseFrequency = 5; %Hz
squareWave = square(time*pulseFrequency*2*pi);

%% Plot Square Wave
figure(1), plot(time,squareWave,'b')
title([num2str(pulseFrequency) 'Hz Square Pulse'])

%% Adjust Amplitude
squareWavePos = (squareWave+1)/2;
close(1)
figure(1), plot(time,squareWavePos,'r')
set(gca,'YLim',[-0.1 1.1])

%% Define Nyquist Sampling Time Vector
% 일정 부분 이상의 주파수대가 존재하지 않은 시간 신호에 대해 그 주파수대의 2배로 샘플링 하면, discrete time
% signal로 간주할 수 있다.(???) 
nsamplingFrequnecy = 2*pulseFrequency; % pulse freq 2 times
ntimeStep = 1/nsamplingFrequnecy; % sec
T = 1;
nS = T*nsamplingFrequnecy; % samples
nsamples = 1:nS; % samples
ntime = nsamples*ntimeStep; % sec
%% Generate Nyquist Sampling Square Wave
nsquareWave = square(ntime*pulseFrequency*2*pi); % time 에서 ntime으로 달라짐.
nsquareWavePos = (nsquareWave+1)/2; % 이건 그냥 값을 옮겨주기 위한 것 인듯. (-1 1 에서 옮기려고)

%% Plot Nyquist Square Wave
figure(2), plot(time,squareWavePos,'b',ntime,nsquareWavePos,'r')
legend('Extreme Oversampling', 'Nyquist Sampling')
set(gca,'YLim',[-0.1 1.1])

%% Define Undersampled Time Vector
usamplingFrequency = 1.7*pulseFrequency;
utimeStep = 1/usamplingFrequency; % sec
T = 1; % sec
uS = T*usamplingFrequency; % samples
usamples = 1:uS; % samples
utime = usamples*utimeStep; % sec

%% Generate Undersampled Square Wave
usquareWave = square(utime*pulseFrequency*2*pi);
usquareWavePos = (usquareWave+1)/2;

%% Plot Nyquist Square Wave Compared to Oversampled Square Wave
figure(2), plot(time,squareWavePos,'b',ntime,nsquareWavePos,'r',utime,usquareWavePos,'g')
legend('Extreme Oversampling', 'Nyquist Sampling','Undersampled')
set(gca,'YLim',[-0.1 1.1])

%% Convolution with Linear Decay Signal 
% 우하향으로 감소하는 신호와 convolution. 
%Generate Lienar Decay signals 
lds = fliplr(time)/sum(time);  %flip array left to right  (for convolution)
nlds = fliplr(ntime)/sum(ntime); 
ulds = fliplr(utime)/sum(utime); 

%Convolve Square Wave Signals with Linear Decay Signals 
squareWaveLDS  = conv(squareWavePos, lds);
nsquareWaveNLDS = conv(nsquareWavePos,nlds);
usquareWaveULDS = conv(usquareWavePos,ulds);

%Extend time vectors to match convolved signals
convtime = (-S:1:S)*timeStep;
nconvtime=(-nS:1:nS)*ntimeStep;
uconvtime= (-uS:1:uS)*utimeStep;

%Pad convolved signals with leading and trailing zero
squareWaveLDS = [0,squareWaveLDS,0];
nsquareWaveNLDS = [0,nsquareWaveNLDS,0];
usquareWaveULDS = [0,usquareWaveULDS,0,0]; % 억지로 0 추가하긴 했음..

figure(3), plot(convtime,squareWaveLDS,'b',nconvtime,nsquareWaveNLDS,'r',uconvtime,usquareWaveULDS,'g')
legend('Extreme Oversampling','Nyquist Sampling','Undersampled')

%% convolution with Exponential Decay
%Generate Exponential Decay Signals 
eds = exp(-time);
eds = eds/sum(eds); % normalize?
neds = exp(-ntime);
neds = neds/sum(neds);
ueds = exp(-utime);
ueds = ueds/sum(ueds);

%Convolve Square Wave signals with Exponential Decay Signals
squareWaveEDS = conv(squareWavePos,eds);
nsquareWaveNEDS = conv(nsquareWavePos, neds);
usquareWaveUEDS = conv(usquareWavePos,ueds);

%Pad convolved signals with leading and trailing zero
squareWaveEDS = [0, squareWaveEDS,0];
nsquareWaveNEDS = [0, nsquareWaveNEDS,0];
usquareWaveUEDS = [0, usquareWaveUEDS,0,0];

figure(4), plot(convtime,squareWaveEDS,'b',nconvtime,nsquareWaveNEDS,'r',uconvtime,usquareWaveUEDS,'g')
legend('Extreme Oversampling','Nyquist Sampling','Undersampled')
