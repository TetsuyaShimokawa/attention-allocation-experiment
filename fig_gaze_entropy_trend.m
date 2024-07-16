function fig_gaze_entropy_trend

% data import
load Subject Subject 

% Entropy in each span
spn{1}=[1:10];
spn{2}=[11:20];
spn{3}=[21:30];
spn{4}=[31:40];
spn{5}=[41:50];
spn{6}=[51:60];
spn{7}=[61:70];
spn{8}=[71:80];

Ent=[];
for cs=1:length(Subject)  
    clear bptn_gaze_by_subject
    bptn_gaze_by_subject=cell2mat(Subject(cs).bptn_gaze_by_subject);
    size(bptn_gaze_by_subject)
    for cspn=1:length(spn)
        E=[];
        for cp=spn{cspn}
            E=[E;bptn_gaze_by_subject(cp,:)];
        end
        prob=nanmean(E)./sum(nanmean(E));
        ent=0;
        for csig=1:length(E(1,:))
            if(prob(csig)~=0)
                ent=ent+(-prob(csig)*log(prob(csig)));
            end
        end
        Subject(cs).gaze_entropy(cspn)=ent;
        Ent(cs,cspn)=ent;
    end
end
figure
plot(Ent')
figure
plot(nanmean(Ent))
nanmean(Ent(:,8))

figure
boxplot(Ent,'Notch','on','Labels',{'1-10','11-20','21-30','31-40','41-50','51-60','61-70','71-80'})
title('Entropy of Gaze Distribution')

% Entropy trends in each individual
counter=0;
for cs=1:length(Subject)
    periods=[1:length(Ent(cs,:))];
    ent=Ent(cs,:);
    X=[ones(length(Ent(cs,:)),1),periods'];
    trend = X\ent';
    if(trend(2,1)<=0)
        counter=counter+1;
    end
end
[counter,length(Subject)]