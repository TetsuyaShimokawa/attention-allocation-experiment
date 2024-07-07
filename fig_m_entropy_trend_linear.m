function fig_m_entropy_trend_linear

% data import
load PriceSetUp PriceSetUp
load Subject Subject 
numb_signals=[1,1,4,4,8,8;8,8,1,1,4,4;4,4,8,8,1,1];
beta_ptn=[-0.7,-0.5,-0.3,-0.1,0.1,0.3,0.5,0.7];
numb_path=6;

E=[];counter=0;
for cs=1:length(Subject)
    for cpath=1:numb_path

        if(rem(Subject(cs).subject_id,3)==0)
            numb_s=numb_signals(3,cpath);
        else
            numb_s=numb_signals(rem(Subject(cs).subject_id,3),cpath);
        end  

        if(numb_s==8)
            counter=counter+1;
            clear m
            m=Subject(cs).Path(cpath).SKF.m;
            for ct=1:length(m(:,1))
                prob_m=m(ct,:)/sum(m(ct,:));
                ent(ct)=0;
                for csig=1:8
                    ent(ct)=ent(ct)+(-prob_m(csig)*log(prob_m(csig)));
                end
            end
            E(counter,:)=ent;
            clear ent
        end
    end
end
figure
plot(mean(E))
mean(E)
mean(mean(E(:,[end-10:end])))
                    

