function draw_Dartboard( feats,superior_title )
%DRAW MFVEP DARTBOARD
%   Draws a MFVEP Dartboard with an array of features inputs. Divides from
%   inner rings (R1 and R2) and outer rings (R3, R4, R5 and R6).
%% Preprocess the input superior_title
sup_title = 'MFVEP Dartboard';
if nargin < 2
    superior_title = '';
end
%% Divides the features in inner and outer features
% Corresponding to the inner and outer rings in the dartboard.
inner_ft_mtx = feats(feats < 13);
outer_ft_mtx = feats(feats >= 13);
%% Outer rings of the dartboard
N=6;
r = (2:N)'/N;
t = pi*(-N:N)/N;
x = r*cos(t);
y = r*sin(t);
M = ones(size(x));
%% Maps the outer inputs
if ~isempty(outer_ft_mtx)
    outer_outer_idx = [6,5,4,3,2,1,12,11,10,9,8,7];
    for i=1:length(outer_ft_mtx)
        if outer_ft_mtx(i) < 25
            L = 1;
            soma = 12;
            M(L,outer_outer_idx(outer_ft_mtx(i) - soma)) = 0;
        elseif outer_ft_mtx(i) < 37
            L = 2;
            soma = 24;
            M(L,outer_outer_idx(outer_ft_mtx(i) - soma)) = 0;
        elseif outer_ft_mtx(i) < 49
            L = 3;
            soma = 36;
            M(L,outer_outer_idx(outer_ft_mtx(i) - soma)) = 0;
        else
            L = 4;
            soma = 48;
            M(L,outer_outer_idx(outer_ft_mtx(i) - soma)) = 0;
        end
    end
end
%% Inner rings of the dartboard
x1 = [-0.3333 -0.2277 0 0.2277 0.3333 0.2277 0 -0.2277 -0.3333;
      -0.1666 -0.0834 0 0.0834 0.1666 0.0834 0 -0.0834 -0.1666;
      -0.1666 -0.1666 0 0 0.1666 0.1666 0 0 -0.1666;
      0 0 0 0 0 0 0 0 0;];
y1 = [0 -0.2277 -0.3333 -0.2277 0 0.2277 0.3333 0.2277 0;
      0 -0.0834 -0.1666 -0.0834 0 0.0834 0.1666 0.0834 0;
      0 0 -0.1666 -0.1666 0 0 0.1666 0.1666 0;
      0 0 0 0 0 0 0 0 0;];
M1 = ones(size(x1));
%% Maps the inner inputs
if ~isempty(inner_ft_mtx)
    inner_idx = [4,2,8,6];
    outer_idx = [4,3,2,1,8,7,6,5];
    for i=1:length(inner_ft_mtx)
        if inner_ft_mtx(i) < 5
            L = 3;
            M1(L,inner_idx(inner_ft_mtx(i))) = 0;
        else
            L = 1;
            soma = 4;
            M1(L,outer_idx(inner_ft_mtx(i) - soma)) = 0;
        end
    end
end
%% Plots the two parts of the dartboard in the same figure
figure;
h1 = subplot(1,2,1);
pcolor(x,y,M)
colormap(gray(2)), axis equal tight
title('Outer Rings [R3, R4, R5, R6]','FontSize',16);
ax1 = get(h1,'Position');
ax1(3) = ax1(3)+0.1;
set(h1, 'Position', ax1);
axis off

h2 = subplot(1,2,2);
pcolor(x1,y1,M1)
colormap(gray(2)), axis equal tight
title('Inner Rings [R1, R2]','FontSize',16);
ax2 = get(h2,'Position');
ax2(3) = ax2(3)-0.2;
ax2(1) = ax2(1)+0.15;
set(h2, 'Position', ax2);
axis off

suptitle(strcat(sup_title,superior_title));
set(findobj('type','text'),'fontsize',18);
%% Clear variables
clear inner_ft_mtx outer_ft_mtx r t x y M N L soma outer_outer_idx x1 ...
    y1 M1 inner_idx outer_idx h1 ax1 h2 ax2 figure
end

