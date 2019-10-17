% This is a MATLAB re-implementation of the paper
% "Selection of achromatic and non-neutral colors to fill lacunae 
% in frescoes guided by a variational model of perceived contrast"
% Luca Grementieri; Edoardo Provenzi
% Proceedings Volume 10225, Eighth International Conference on Graphic 
% and Image Processing (ICGIP 2016); 102251Z (2017) 
% https://doi.org/10.1117/12.2267773
% 8th Int. Conf. on Graphic and Image Processing, 2016, Tokyo, Japan
% 
% Author: Simone Parisotto, 16/10/2019
% e-mail: sp751 at cam dot ac dot uk

clear
close all
clc

namefile = 'peppers.png';
namemask = 'peppers_mask.png';

input = im2double(imread(namefile));
mask  = im2double(imread(namemask));

phi = 'Michelson'; % any between {'Identity', 'log', 'Michelson'}
w   = 'g';         % any between {'g','l'};
rho = 5;

%% core algorithm tested up to images 1000x1000
t_elapsed = cputime;
[output,E] = wrapper_2016_Grementieri_and_Provenzi(input,mask,phi,w,rho);
t_elapsed = cputime - t_elapsed;

%% plot
h1 = figure;
subplot(2,2,1)
imshow(input,[]), title('Input')
subplot(2,2,2)
imshow(mask,[]), title('Mask')
title('Energy')
subplot(2,2,4)
imshow(output,[]),title(['Output (',num2str(size(output,1)),'x',num2str(size(output,2)),'px) - cputime: ',num2str(t_elapsed),' (s.)'])

imwrite(output,'./results/output.png');

h2 = figure;
colors = {'r-','g-','b-'};
for c = 1:size(input,3)
    plot(E(:,c),colors{c}), hold on, xlim([0,255]), axis square
end