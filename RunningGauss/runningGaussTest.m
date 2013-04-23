clc; clear;

k = 10;
alpha = 0.05;
ColorFactor = 255;

obj = mmreader('../data/traffic-1146.mov');
video = read(obj);
vidOut = video;

vidFrame = size(video, 4);
vidHeight = size(video, 1);
vidWidth = size(video, 2);
vidCh = size(video, 3);

chMeans = cell(1, vidCh);
chVariances = cell(1, vidCh);
chThresholds = cell(1, vidCh);

mov(1:vidFrame)=...
    struct('cdata', zeros(vidHeight, vidWidth, 3, 'uint8'),...
    'colormap', []);

disp('Getting model parameters..');
for c=1:vidCh
    chMeans{c} = dlmread(sprintf('mean-ch-%i.dat', c));
    chVariances{c} = dlmread(sprintf('variance-ch-%i.dat', c));
    chThresholds{c} = k * sqrt(chVariances{c});
end

disp('Testing model with test video..');
for f=2:vidFrame
    for c=1:vidCh
        vidOut(:, :, c, f) = ...
            uint8((abs(single(video(:, :, c, f)) - chMeans{c}) > chThresholds{c}) * ColorFactor);
    end
    mov(f).cdata = vidOut(:, :, :, f);
end

hf = figure;
set(hf, 'position', [0 300 vidWidth vidHeight]);

%movie(hf, mov, 1, obj.FrameRate);