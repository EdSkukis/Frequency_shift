
clear;
clc;

path = 'C:\';
rangeStart = -Inf;
rangeEnd = Inf;

%==========================================================================

filelist = dir(path);
filelist = {filelist.name}';

N = [];
for i = length(filelist):-1:1
    filename = filelist{i};
    if (length(filename) < 6) || ~strcmp(filename((end-4):end), 'N.txt')
        filelist(i) = [];
    else
        if strcmp(filename((end-5):end), 'kN.txt')
            strN = strsplit(filename, '-');
            strN = strN{end};
            N(end+1) = str2num(strN(1:(end-6))) * 1000;
        elseif strcmp(filename((end-4):end), 'N.txt')
            strN = strsplit(filename, '-');
            strN = strN{end};
            N(end+1) = str2num(strN(1:(end-5)));
        end
    end
end

N = N(length(N):-1:1);
[N, idx] = sort(N);
filelist = filelist(idx);

figure;
hold all;

sumShift = 0;
for i = 2:length(N)
    data1 = load([path '\' filelist{i-1}]);
    data2 = load([path '\' filelist{i}]);
    
    idx = (data1(:,1) >= rangeStart) & (data1(:,1) <= rangeEnd);
    data1 = data1(idx,:);
    idx = (data2(:,1) >= rangeStart) & (data2(:,1) <= rangeEnd);
    data2 = data2(idx,:);
    
    maxminFreq = max([min(data1(:,1)) min(data2(:,1))]);
    minmaxFreq = min([max(data1(:,1)) max(data2(:,1))]);
    idx = (data1(:,1) >= maxminFreq) & (data1(:,1) <= minmaxFreq);
    data1 = data1(idx,:);
    idx = (data2(:,1) >= maxminFreq) & (data2(:,1) <= minmaxFreq);
    data2 = data2(idx,:);
    
    if i == 2
        plot(data1(:,1), data1(:,2), 'r');
    end
    
    step = data1(2,1) - data1(1,1);
    bestMSE = Inf;
    bestShift = 0;
    
    for iShift = (0 : floor(length(data1)*0.2))
        tmp1 = data1((1+iShift):end,2);
        tmp2 = data2(1:(end-iShift),2);
        %tmp1 = [data1(:,2); zeros(iShift,1)];
        %tmp2 = [zeros(iShift,1); data2(:,2)];
        %tmp1 = data1(:,2);
        %tmp2 = [zeros(iShift,1); data2(1:(end-iShift),2)];
        MSE = mean((tmp1 - tmp2) .^ 2);
        if MSE < bestMSE
            bestMSE = MSE;
            bestShift = iShift;
        end
    end
    
    sumShift = sumShift + bestShift;
    shift = sumShift * step;
    
    %fprintf('%d\t%f\n', N(i), shift); % raada gan N, gan shift
    fprintf('%f\n', shift); % raada tikai shift
    
    plot(data2(:,1) + shift, data2(:,2));
end
shifty.m
Отображается файл "shifty.m"
