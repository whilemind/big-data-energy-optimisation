clear all;
clc;

analysis = [];
tmp = load('../data/out/ana/ANA_2017-18_Q_1-4_1.mat');
analysis = [analysis; tmp.analysis];

tmp = load('../data/out/ana/ANA_2017-18_Q_1-4_2.mat');
analysis = [analysis; tmp.analysis];

tmp = load('../data/out/ana/ANA_2017-18_Q_1-4_3.mat');
analysis = [analysis; tmp.analysis];

tmp = load('../data/out/ana/ANA_2017-18_Q_1-4_4.mat');
analysis = [analysis; tmp.analysis];

%gradeCode = '13142H'; %count 100
%gradeCode = '13154'; %count 100
gradeCode = '13132H'; %count 49

bad_reel = load('../data/out/ana/ANA_2017-18_Q_1-4_bad_reel.mat');
badR = [];
x1 = [];
y1 = [];
j = 1;
for i = 1:length(bad_reel.bad_reel_analysis)
    if strcmp(bad_reel.bad_reel_analysis(i).qa_data.grade_code, gradeCode)
        disp(i + " >> " + bad_reel.bad_reel_analysis(i).qa_data.grade_code);
        x1(j) = bad_reel.bad_reel_analysis(i).M1_Moisture_Profile;
        y1(j) = bad_reel.bad_reel_analysis(i).M1_Grammage_Profile;
        badR = [badR; str2num(bad_reel.bad_reel_analysis(i).reel_id)];
        j = j + 1;
    end
end

j = 1;
len = length(badR);
x = [];
y = [];
for i = 1:length(analysis)
    reel = str2num(analysis(i).reel_id);
    for k = 1: len
        breel = badR(k);
        if(breel ==  reel)
            break;
        end
    end
    if(k == len && strcmp(analysis(i).qa_data.grade_code, gradeCode))
%         disp(analysis(i).steam);
        x(j) = analysis(i).M1_Moisture_Profile;
        y(j) = analysis(i).M1_Grammage_Profile;
        j = j + 1;
    else
        continue;
    end
    % z(i) = analysis(i).M1_Moisture_Profile;
end

y = zeros(length(x));
y1 = ones(length(x1));

figure;
plot(x, y, '*');
hold on;
plot(x1, y1, 'o');
