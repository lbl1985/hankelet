function visualTrajectories(word, trajectory, frameId, isRecord)
% isRecord = 1;
% load word_8_DF2.mat
% trajectory = readTxt2Var('out.features');

% frameId = trajectory(:, 1);     
% trajectory = trajectory(:, (8 : 37));
nFrameVis = max(frameId);

% baseFolder = getProjectBaseFolder();
videoFolder = fullfile('/Users/herbert19lee/Documents/MATLAB/work/hankelet/', 'data');
videoVar = video.movie2var(fullfile(videoFolder, 'person01_boxing_d1_uncomp.mp4'), 1, 1);
h = figure(1);
if isRecord
    s1 = video.videoSaver(fullfile(baseFolder, '20kmeans', 'DF2EightWordColored.avi'), 11);
    s1.fig = h;
end
%%
for i = min(frameId) : nFrameVis
    figure(h); imshow(videoVar(:, :, i)); 
    trajIdSel = frameId == i;
    traj = trajectory(trajIdSel, :);
    tmpWord = word(trajIdSel);
    nNumerics = size(traj, 2);
    nTraj = size(traj, 1);
    ColorSet = varycolor(max(word));
    hold on
    for j = 1 : size(traj, 1)
%         plotTrajectory(h, traj(j, :));
        plot(traj(j, 1 : 2 : nNumerics), traj(j, 2 : 2 : nNumerics), '-', ...
            'Color', ColorSet(tmpWord(j), :));
        plot(traj(j, nNumerics-1), traj(j, nNumerics), 'x', 'Color', ColorSet(tmpWord(j), :));        
    end
    hold off; title(['Frame # ' num2str(i)]);
    pause(1/11);
    if isRecord
        s1.saveCore();
    end
end

if isRecord
    s1.saveClose;
end