function [ registered ] = register( fixed, moving, modality )
if strcmp(modality,'monomodal')
    % Show the images
    figure();
    imshowpair(moving,fixed,'montage')
    title('Unregistered')
    
    figure();
    imshowpair(moving,fixed)
    title('Unregistered')
    
    % Get optimizer and metric based on modality.
    % Here optimizer  is RegularStepGradientDescent
    [optimizer,metric] = imregconfig(modality)
    tformSimilarity = imregtform(moving,fixed,'similarity',optimizer,metric);
    % Get coordinates of fixed image
    Rfixed = imref2d(size(fixed));
    % Apply transformation to moving image
    movingRegisteredRigid = imwarp(moving,tformSimilarity,'OutputView',Rfixed);
    registered = movingRegisteredRigid;
    
    % Show results
    figure();
    imshowpair(movingRegisteredRigid, fixed)
    title('Registration Based on Similarity Transformation Model')
    
elseif strcmp(modality,'multimodal')
    % Show the images
    figure();
    imshowpair(moving,fixed,'montage')
    title('Unregistered')
    figure();
    imshowpair(moving,fixed)
    title('Unregistered')
    
    % Get optimizer and metric based on modality.
    % Here optimizer  is  OnePlusOneEvolutionary
    [optimizer,metric] = imregconfig(modality)
    % Register images
    movingRegisteredDefault = imregister(moving,fixed,'affine',optimizer,metric);
    % Show result
    figure();
    imshowpair(movingRegisteredDefault,fixed)
    title('Default Registration')
    
    % Modify radius of the optimizer
    optimizer.InitialRadius = optimizer.InitialRadius/3.5;
    % Register images
    movingRegisteredAdjustedInitialRadius = imregister(moving,fixed,'affine',optimizer,metric);
    
    % Show result
    figure();
    imshowpair(movingRegisteredAdjustedInitialRadius,fixed)
    title('Adjusted InitialRadius')
    % Modify iterations of the optimizer
    optimizer.MaximumIterations = 300;
    movingRegisteredAdjustedInitialRadius300 = imregister(moving,fixed,'affine',optimizer,metric);
    
    % Show result
    figure();
    imshowpair(movingRegisteredAdjustedInitialRadius300,fixed)
    title('Adjusted InitialRadius, MaximumIterations = 300')
    
    % Get transformation based on similarity model
    tformSimilarity = imregtform(moving,fixed,'similarity',optimizer,metric);
    Rfixed = imref2d(size(fixed));
    movingRegisteredRigid = imwarp(moving,tformSimilarity,'OutputView',Rfixed);
    registered = movingRegisteredRigid;
    
    % Show result
    figure();
    imshowpair(movingRegisteredRigid, fixed);
    title('Registration Based on Similarity Transformation Model')
%     figure();
%     imshowpair(movingRegisteredAdjustedInitialRadius300, movingRegisteredRigid,'montage')
%     title('Affine (L) vs. Similarity (R)')
else
    disp('Modality not valid. Only monomodal or multimodal.');
    registered = [];
end

end

