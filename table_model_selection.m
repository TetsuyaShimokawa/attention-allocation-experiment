function table_model_selection

% data import
load PriceSetUp PriceSetUp
load Subject Subject 
numb_signals=[1,1,4,4,8,8;8,8,1,1,4,4;4,4,8,8,1,1];

Z=zeros(length(Subject),3);
R{1}=Z;R{2}=Z;L{1}=Z;L{2}=Z;K{1}=Z;K{2}=Z;KA{1}=Z;KA{2}=Z;
for cs=1:length(Subject)
    for cpath=1:length(Subject(cs).Path)       
        
        if(rem(Subject(cs).subject_id,3)==0)
            numb_info=numb_signals(3,cpath);
        else
            numb_info=numb_signals(rem(Subject(cs).subject_id,3),cpath);
        end 

        clear sig_id
        if(numb_info==1)
            sig_id=1;
        elseif(numb_info==4)
            sig_id=2;
        elseif(numb_info==8)
            sig_id=3;
        end
    
        if(Subject(cs).Path(cpath).R.exitsig>0)
            R{1}(cs,sig_id)=R{1}(cs,sig_id) +(1/2)*Subject(cs).Path(cpath).R.llh;
            R{2}(cs,sig_id)=R{2}(cs,sig_id) +(1/2)*Subject(cs).Path(cpath).R.aic;
        end
        if(Subject(cs).Path(cpath).SKF.exitsig>0)
            L{1}(cs,sig_id)=L{1}(cs,sig_id) +(1/2)*Subject(cs).Path(cpath).SKF.llh;
            L{2}(cs,sig_id)=L{2}(cs,sig_id) +(1/2)*Subject(cs).Path(cpath).SKF.aic;
        end
        if(Subject(cs).Path(cpath).SKernel.exitsig>0)
            K{1}(cs,sig_id)=K{1}(cs,sig_id) +(1/2)*Subject(cs).Path(cpath).SKernel.llh;
            K{2}(cs,sig_id)=K{2}(cs,sig_id) +(1/2)*Subject(cs).Path(cpath).SKernel.aic;
        end
        if(Subject(cs).Path(cpath).SKernel_ARD.exitsig>0)
            KA{1}(cs,sig_id)=KA{1}(cs,sig_id) +(1/2)*Subject(cs).Path(cpath).SKernel_ARD.llh;
            KA{2}(cs,sig_id)=KA{2}(cs,sig_id) +(1/2)*Subject(cs).Path(cpath).SKernel_ARD.aic;
        end

    end
end

% sig_id×aic
R_sig_id_aic=[nanmean(R{1},1)',nanmean(R{2},1)'];
L_sig_id_aic=[nanmean(L{1},1)',nanmean(L{2},1)'];
K_sig_id_aic=[nanmean(K{1},1)',nanmean(K{2},1)'];
KA_sig_id_aic=[nanmean(KA{1},1)',nanmean(KA{2},1)'];
sig_id_aic=[R_sig_id_aic,L_sig_id_aic,K_sig_id_aic,KA_sig_id_aic];
xlswrite('model_selection.xlsx',sig_id_aic,'signals aic')

% subject×aic
R_subj_aic=[nanmean(R{1},2),nanmean(R{2},2)];
L_subj_aic=[nanmean(L{1},2),nanmean(L{2},2)];
K_subj_aic=[nanmean(K{1},2),nanmean(K{2},2)];
KA_subj_aic=[nanmean(KA{1},2),nanmean(KA{2},2)];
subj_aic=[R_subj_aic,L_subj_aic,K_subj_aic,KA_subj_aic];
xlswrite('model_selection.xlsx',subj_aic,'subjects aic')

% average model×aic
A(1,:)=[nanmean(R_subj_aic)];
A(2,:)=[nanmean(L_subj_aic)];
A(3,:)=[nanmean(K_subj_aic)];
A(4,:)=[nanmean(KA_subj_aic)];
xlswrite('model_selection.xlsx',A,'model aic')



