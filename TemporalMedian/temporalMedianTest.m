clc; clear;

alpha = 0.05;
Threshold = 30;
ColorFactor = 255;

obj = mmreader('../data/traffic-1146.mov');
video = read(obj);
vidOut = video;

vidFrame = size(video, 4);
vidHeight = size(video, 1);
vidWidth = size(video, 2);
vidCh = size(video, 3);

chBackgrounds = cell(1, vidCh);

mov(1:vidFrame)=...
    struct('cdata', zeros(vidHeight, vidWidth, 3, 'uint8'),...
    'colormap', []);

disp('Getting model parameter..');
for c=1:vidCh
    chBackgrounds{c} = dlmread(sprintf('background-ch-%i.dat', c));
end

disp('Testing model with test video..');

Th = ones(vidHeight, vidWidth) * Threshold;
for f=2:vidFrame
    for c=1:vidCh
        vidOut(:, :, c, f) = ...
            uint8((abs(single(video(:, :, c, f)) - chBackgrounds{c}) > Th) .* ColorFactor);
    end
    mov(f).cdata = vidOut(:, :, :, f);
end

hf = figure;
set(hf, 'position', [0 300 vidWidth vidHeight]);

%movie(hf, mov, 1, obj.FrameRate);