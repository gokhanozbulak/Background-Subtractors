clc; clear;

Threshold = 30;
ColorFactor = 255;

obj = mmreader('data/traffic-1146.mov');
video = read(obj);
vidOut = video;

vidFrame = size(video, 4);
vidHeight = size(video, 1);
vidWidth = size(video, 2);
vidCh = size(video, 3);

Th = ones(vidHeight, vidWidth) * Threshold;

mov(1:vidFrame)=...
    struct('cdata', zeros(vidHeight, vidWidth, 3, 'uint8'),...
    'colormap', []);

for f=2:vidFrame
    for c=1:vidCh
        vidOut(:, :, c, f) = ...
            uint8((abs(video(:, :, c, f) - video(:, :, c, f-1)) > Th) * ColorFactor);
    end
    mov(f).cdata = vidOut(:, :, :, f);
end

%hf = figure;
%set(hf, 'position', [0 300 vidWidth vidHeight]);

%movie(hf, mov, 1, obj.FrameRate);