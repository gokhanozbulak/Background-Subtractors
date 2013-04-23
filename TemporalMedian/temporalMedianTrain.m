clc; clear;

alpha = 0.05;
% This must be an odd value to get median -midpoint- value in sorted seq.
FirstNFrames = 51;

disp('Training to optimize background parameter..');
obj = mmreader('../data/traffic-1540.mov');
video = read(obj);

vidFrame = size(video, 4);
vidHeight = size(video, 1);
vidWidth = size(video, 2);
vidCh = size(video, 3);

% Create background matrices for each of video channel-R,G,B-
chBackgrounds = cell(1, vidCh);

% Evaluate initial background model for each channel by first N frames.
for c=1:vidCh
    chBackgrounds{c} = zeros(vidHeight, vidWidth);
    for h=1:vidHeight
        for w=1:vidWidth
            chBackgrounds{c}(h,w) = ...
                median(single(video(h,w,c,1:FirstNFrames)));
        end
    end
end

% For the rest of frames, update running average iteratively
for f=FirstNFrames+1:vidFrame
    for c=1:vidCh
        chBackgrounds{c} = ...
            alpha * single(video(:,:,c,f)) + (1-alpha) * chBackgrounds{c};
    end
end

disp('Writing model parameters to files..');
for c=1:vidCh
    dlmwrite(sprintf('background-ch-%i.dat', c), chBackgrounds{c});
end