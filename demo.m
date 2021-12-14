%% "Kaleidoscopic Structured Light"
% Compatible with MATLAB 2019b or higher (lower versions have not been tested)
% Email bahn@cmu.edu if you have any issues using this code

clear
close all
restoredefaultpath
addpath(genpath('lib'));

%% LOAD DATA
% set data
dataName = 'cat_brush'; % cat_brush, elephant, skeleton, skull, treble_clef
dir_head = sprintf('data/scan/real/%s', dataName);

% load data and calibration
load(sprintf('%s/data.mat', dir_head));
load('data/calibration/virtual_system.mat');

%% RUN EPIPOLAR LABELING
[label, data] = runEpipolarLabeling(data, virtual);

%% RUN TRIANGULATION
[points, label] = runTriangulation(data, label, virtual);

%% RUN SURFACE RECONSTRUCTION
% PCA normal
points = runPCAnormal(points, data, label, virtual);

% Poisson surface reconstruction (https://github.com/mkazhdan/PoissonRecon)