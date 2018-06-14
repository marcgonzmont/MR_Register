clear all; close all; clc;

% Load images and convert to gray
fixed=load_untouch_nii('..\Data\P2\mr1.nii');
fixed=mat2gray(fixed.img(:,:,199));
moving=load_untouch_nii('..\Data\P2\ct.nii');
moving=mat2gray(moving.img(:,:,199));
% Set modality
modality = 'multimodal';    % monomodal or multimodal
% Apply register algorithm
registered = register(fixed, moving, modality);