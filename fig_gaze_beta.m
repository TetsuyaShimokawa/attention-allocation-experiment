function fig_gaze_beta

% data import
load Subject Subject 
beta_ptn=[-0.7,-0.5,-0.3,-0.1,0.1,0.3,0.5,0.7];

% bar plot
B=[];Bs=[];
for cs=1:length(Subject)
    size(cell2mat(Subject(cs).bptn_gaze_by_subject))
    B=[B;nanmean(cell2mat(Subject(cs).bptn_gaze_by_subject))];
    Bs=[Bs;nansum(cell2mat(Subject(cs).bptn_gaze_by_subject))];
end
size(B)
figure
Ba=nanmean(B);
Bsa=nanmean(Bs);
bar(beta_ptn,Ba./sum(Ba))%ratioにする
figure
bar(beta_ptn,Bsa./sum(Bsa))