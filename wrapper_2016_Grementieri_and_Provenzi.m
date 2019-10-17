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

function [output,E] = wrapper_2016_Grementieri_and_Provenzi(input,mask,phi,w,rho)

offset = 1/255; % positive offset
u    = input+offset;
[m,n,c] = size(u);

PHI = {'Identity', 'log', 'Michelson'};
W = {'g','l'};

switch find(strcmpi(phi,PHI))
    case 1
        phifunc = @(x,y) max(x,y)./min(x,y);
    case 2
        phifunc = @(x,y) log(max(x,y)./min(x,y));
    case 3
        phifunc = @(x,y) abs(x-y)./(x+y);
end

switch find(strcmpi(w,W))
    case 1 
        weight = @(x,y,rho) sum(exp(-(pdist2(x, y,'euclidean').^2)./(2*rho^2)),2);
    case 2
        weight = @(x,y,rho) sum(1-rho*pdist2(x, y,'euclidean'),1);
end

LAMBDA = [1:256]/256;
E = Inf(255,size(u,3));

% compute w
%[x(:,1),x(:,2)] = ind2sub([m,n],find(mask(:,:,1)==0));

cutoff = double(imdilate(mask(:,:,1)>0,ones(61)) & mask(:,:,1)==0);
idx_x = find(cutoff==1);
idx_y = find(mask(:,:,1)>0);

[x(:,1),x(:,2)] = ind2sub([m,n],idx_x);
[y(:,1),y(:,2)] = ind2sub([m,n],idx_y);

D = zeros(m,n);
D(idx_x) = weight(x,y,rho);
D = D./sum(sum(D)); % weight normalisation

% compute s
for l = 1:numel(LAMBDA)
    s = repmat(D,1,1,size(u,3)).*phifunc(u,LAMBDA(l)*ones(m,n,c));
    E(l,:) = squeeze(sum(sum(s))).';
end

[~,pos] = min(E,[],1);

lambdamap = cat(3,LAMBDA(pos(1))*ones(m,n),LAMBDA(pos(2))*ones(m,n),LAMBDA(pos(3))*ones(m,n));

output = u;
output(mask>0) = lambdamap(mask>0);
output = output-offset;

end
