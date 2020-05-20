close all;
clearvars; clc
addpath(genpath('../functions'));

% Inputs
k0 = 2*pi;                              % / lambda    |  wave number
rho= 4e10 / 4.2^3;                      % / lambda^3  |  concentration of particles
Ys = 0.6;                               % * lambda    |  Y size of the sampling region
Zs = 0.3;                               % * lambda    |  Z size of the sampling region
Mij_case = 'load';                      % 'generate' Mij by parameters, or 'load' example Mij
alpha_e = 4.42e-10 + 4.42e-11i;         % * lambda^3  |  electric polarizability
alpha_m = 4.42e-11 + 4.42e-12i;         % * lambda^3  |  magnetic polarizability
n0_re =  0.5:3.5;
n0_im = -1.5:1.5;
n0_sweep = reshape( repmat(n0_re, [size(n0_im, 2) 1]) + 1i*repmat(n0_im.', [1 size(n0_re,2)]), [1 size(n0_re, 2)*size(n0_im, 2)]);

% Calculate Mij
switch Mij_case
    case 'generate'
        L  = 2;                   % * lambda    |  side length of the cubic simulation region
        D1 = 0.001;               % * lambda    |  side length of a Lv1 voxel
        D2 = 0.01;                % * lambda    |  side length of a Lv2 voxel
        dF = 0.1;                 % * lambda    |  far field limit
        Mij_row = hier_grouping(L, D1, D2, dF);
        % save('example_Mij/Mij_exmpl2.mat', 'L', 'D1', 'D2', 'dF', 'Mij_row');
    case 'load'
        load('example_Mij/Mij_exmpl1'); 
        % 'Mij_exmpl1': L  = 4.2, D1 = 0.0015, D2 = 0.03, dF = 0.1
        % 'Mij_exmpl2': L  = 2  , D1 = 0.001 , D2 = 0.01, dF = 0.1
end

n   = zeros(1, size(n0_sweep,2));
eta = zeros(1, size(n0_sweep,2));
K   = zeros(1, size(n0_sweep,2));
for i=1:size(n0_sweep,2)
    [n(i), eta(i), E, K(i)] = Iteration(Mij_row, k0, rho, alpha_e, alpha_m, L, D2, Ys, Zs, n0_sweep(i));
end

