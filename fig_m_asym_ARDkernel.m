function fig_m_asym_ARDkernel

% data import
load PriceSetUp PriceSetUp
load Subject Subject 
numb_signals=[1,1,4,4,8,8;8,8,1,1,4,4;4,4,8,8,1,1];
beta_ptn=[-0.7,-0.5,-0.3,-0.1,0.1,0.3,0.5,0.7];
numb_path=6;

for cbp=1:0.5*length(beta_ptn)
     Asym{cbp}=[];
end
for cs=1:length(Subject)
    for cpath=1:numb_path
        for cbp=1:length(beta_ptn)
             bptn_AAm{cbp}=[];
        end

        if(rem(Subject(cs).subject_id,3)==0)
            numb_s=numb_signals(3,cpath);
        else
            numb_s=numb_signals(rem(Subject(cs).subject_id,3),cpath);
        end  

        if(Subject(cs).Path(cpath).SKernel_ARD.exitsig>0)
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
        Asym{1}=[Asym{1},bptn_AAm{8}-bptn_AAm{1}];
        Asym{2}=[Asym{2},bptn_AAm{7}-bptn_AAm{2}];
        Asym{3}=[Asym{3},bptn_AAm{6}-bptn_AAm{3}];
        Asym{4}=[Asym{4},bptn_AAm{5}-bptn_AAm{4}];
    end
end

for ca=1:4
    figure
    histogram(Asym{ca},20)
    [nanmean(Asym{ca}),nanstd(Asym{ca}),nanmean(Asym{ca})/nanstd(Asym{ca})]
end
figure
all=[Asym{1},Asym{2},Asym{3},Asym{4}];
histogram(all,20)
[nanmean(all),nanstd(all),nanmean(all)/nanstd(all)]
