% ref: https://kr.mathworks.com/help/images/ref/deconvwnr.html
%deconv_test
% deconvwnr: deconvolves img using the Wiener filter algorithm (I, PSF,
% NSR)
% PSF: point spread function which I was convolved
I = im2double(imread('Cameraman.bmp'));
imshow(I);
title('Original Image (courtesy of MIT)');
% simulate a motion blur
LEN = 21;
THETA = 11;
PSF = fspecial('motion', LEN, THETA);
blurred = imfilter(I, PSF, 'conv', 'circular');
figure, imshow(blurred)
% simulate additive noise
noise_mean = 0;
noise_var = 0.0001;
blurred_noisy = imnoise(blurred, 'gaussian', ...
                        noise_mean, noise_var);
figure, imshow(blurred_noisy)
title('Simulate Blur and Noise')
%try restoration assuming no noise
estimated_nsr = 0;
wnr2 = deconvwnr(blurred_noisy, PSF, estimated_nsr);
figure, imshow(wnr2)
title('Restoration of Blurred, Noisy Image Using NSR = 0')
%try restoration assuming better estimate - of the Noise to signal power
%ratio.
estimated_nsr = noise_var / var(I(:)); %?
wnr3 = deconvwnr(blurred_noisy, PSF, estimated_nsr);
figure, imshow(wnr3)
title('Restoration of Blurred, Noisy Image Using Estimated NSR');
