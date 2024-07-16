function subject_files_combine

% load Subject Subject
% count1=1;
% count2=1;
% count3=1;
% for cs=1:length(Subject)
%     if(cs<=10)
%         Subject10(cs)=Subject(cs);
%     elseif(cs>10)&&(cs<=20)
%         Subject20(count1)=Subject(cs);
%         count1=count1+1;
%     elseif(cs>20)&&(cs<=30)
%         Subject30(count2)=Subject(cs);
%         count2=count2+1;
%     elseif(cs>30)&&(cs<=42)
%         Subject40(count3)=Subject(cs);
%         count3=count3+1;
%     end
% end
% 
% save Subject10 Subject10
% save Subject20 Subject20
% save Subject30 Subject30
% save Subject40 Subject40

load Subject10 Subject10
load Subject20 Subject20
load Subject30 Subject30
load Subject40 Subject40
count=1;
for cs=1:length(Subject10)
    Subject(count)=Subject10(cs);
    count=count+1;
end
for cs=1:length(Subject20)
    Subject(count)=Subject20(cs);
    count=count+1;
end
for cs=1:length(Subject30)
    Subject(count)=Subject30(cs);
    count=count+1;
end
for cs=1:length(Subject40)
    Subject(count)=Subject40(cs);
    count=count+1;
end

save Subject Subject
        