function fig_m_beta_ARDkernel

% data import
load PriceSetUp PriceSetUp
load Subject Subject 
numb_signals=[1,1,4,4,8,8;8,8,1,1,4,4;4,4,8,8,1,1];
beta_ptn=[-0.7,-0.5,-0.3,-0.1,0.1,0.3,0.5,0.7];
numb_path=6;

for cbp=1:length(beta_ptn)
     bptn_AAm{cbp}=[];
end
for cs=1:length(Subject)
    for cpath=1:numb_path

        if(rem(Subject(cs).subject_id,3)==0)
            numb_s=numb_signals(3,cpath);
        else
            numb_s=numb_signals(rem(Subject(cs).subject_id,3),cpath);
        end  

        if(numb_s==8)
            clear diff_f
            diff_f=nanmean(abs(Subject(cs).Path(cpath).SKernel_ARD.diff_f));
            for cbp=1:length(beta_ptn)
                bptn=beta_ptn(cbp);
                for csig=1:numb_s   
                    if(PriceSetUp(cpath).beta(csig)==bptn)
                        bptn_AAm{cbp}=[bptn_AAm{cbp} diff_f(csig)];
                    end
                end
            end
        end
    end
end
for cbp=1:8
    average_diff_signal8(1,cbp)=nanmean(bptn_AAm{cbp});
end

figure
bar(beta_ptn,average_diff_signal8)
