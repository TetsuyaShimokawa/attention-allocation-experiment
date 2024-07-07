function fig_m_entropy_trend_ARDkernel

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
            
            clear diff_f
            diff_f=abs(Subject(cs).Path(cpath).SKernel_ARD.diff_f);
            
            clear prob_m
            for ct=1:length(diff_f(:,1))
                if(ct<=0)
                    ent(ct)=nan;
                else
                    prob_m=diff_f(ct,:)/sum(diff_f(ct,:));
                    ent(ct)=0;                                               
                        for csig=1:length(prob_m)
                            if(prob_m(csig)~=0)
                                ent(ct)=ent(ct)+(-prob_m(csig)*log(prob_m(csig)));
                            end
                        end
                end
            end
            if(isempty(find(ent==0)))
                counter=counter+1;
                E(counter,:)=ent;
            end
            clear ent
        end
    end
end
figure
plot(nanmean(E))
nanmean(E)
mean(nanmean(E(:,[end-10:end])))
                    
