clc; clear;

alpha = 0.05;
FirstNFrames = 50;

disp('Training to optimize model parameters..');

obj = mmreader('../data/traffic-1540.mov');
video = read(obj);

vidFrame = size(video, 4);
vidHeight = size(video, 1);
vidWidth = size(video, 2);
vidCh = size(video, 3);

% Create mean and variance matrices for each of video channel-R,G,B-
chMeans = cell(1, vidCh);
chVariances = cell(1, vidCh);

% Evaluate initial means&variances for each channel by first N frames.
for c=1:vidCh
    chMeans{c} = zeros(vidHeight, vidWidth);
    chVariances{c} = zeros(vidHeight, vidWidth);
    for h=1:vidHeight
        for w=1:vidWidth
            chMeans{c}(h,w) = mean(single(video(h,w,c,1:FirstNFrames)));
            chVariances{c}(h,w) = var(single(video(h,w,c,1:FirstNFrames)));
        end
    end
end

% For the rest of frames, update running average iteratively
for f=FirstNFrames+1:vidFrame
    for c=1:vidCh
        chMeans{c} = alpha * single(video(:,:,c,f)) + (1-alpha) * chMeans{c};
        chVariances{c} = ...
            alpha * power(single(video(:,:,c,f))-chMeans{c}, 2) + (1-alpha) * chVariances{c};
    end
end

disp('Writing model parameters to files..');
for c=1:vidCh
    dlmwrite(sprintf('mean-ch-%i.dat', c), chMeans{c});
    dlmwrite(sprintf('variance-ch-%i.dat', c), chVariances{c});
end