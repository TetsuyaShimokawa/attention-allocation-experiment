function table_fitting_params

% data import
load PriceSetUp PriceSetUp
load Subject Subject 
numb_signals=[1,1,4,4,8,8;8,8,1,1,4,4;4,4,8,8,1,1];

Z=zeros(length(Subject),3);
R{1}=Z;R{2}=Z;L{1}=Z;L{2}=Z;L{3}=Z;K{1}=Z;K{2}=Z;K{3}=Z;K{4}=Z;
KA{1}=Z;KA{2}=Z;KA{3}=Z;KA{4}=Z;KA{5}=Z;KA{6}=Z;KA{7}=Z;KA{8}=Z;KA{9}=Z;KA{10}=Z;KA{11}=Z;
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
            R{1}(cs,sig_id)=R{1}(cs,sig_id) +(1/2)*Subject(cs).Path(cpath).R.gamma;
            R{2}(cs,sig_id)=R{2}(cs,sig_id) +(1/2)*Subject(cs).Path(cpath).R.sigma2;
        end
    
        if(Subject(cs).Path(cpath).SKF.exitsig>0)
            L{1}(cs,sig_id)=L{1}(cs,sig_id) +(1/2)*Subject(cs).Path(cpath).SKF.gamma;
            L{2}(cs,sig_id)=L{2}(cs,sig_id) +(1/2)*Subject(cs).Path(cpath).SKF.sigma2;
            L{3}(cs,sig_id)=L{3}(cs,sig_id) +(1/2)*Subject(cs).Path(cpath).SKF.kappa;
        end
    
        if(Subject(cs).Path(cpath).SKernel.exitsig>0)
            K{1}(cs,sig_id)=K{1}(cs,sig_id) +(1/2)*Subject(cs).Path(cpath).SKernel.gamma;
            K{2}(cs,sig_id)=K{2}(cs,sig_id) +(1/2)*Subject(cs).Path(cpath).SKernel.sigma2;
            K{3}(cs,sig_id)=K{3}(cs,sig_id) +(1/2)*Subject(cs).Path(cpath).SKernel.kappa;    
            K{4}(cs,sig_id)=K{4}(cs,sig_id) +(1/2)*Subject(cs).Path(cpath).SKernel.xi;
        end

        if(Subject(cs).Path(cpath).SKernel_ARD.exitsig>0)
            KA{1}(cs,sig_id)=KA{1}(cs,sig_id) +(1/2)*Subject(cs).Path(cpath).SKernel_ARD.gamma;
            KA{2}(cs,sig_id)=KA{2}(cs,sig_id) +(1/2)*Subject(cs).Path(cpath).SKernel_ARD.sigma2;
            KA{3}(cs,sig_id)=KA{3}(cs,sig_id) +(1/2)*Subject(cs).Path(cpath).SKernel_ARD.kappa; 
             if(numb_info==1)
                KA{4}(cs,sig_id)=KA{4}(cs,sig_id) +(1/2)*Subject(cs).Path(cpath).SKernel_ARD.xi(1);
            elseif(numb_info==4)
                KA{4}(cs,sig_id)=KA{4}(cs,sig_id) +(1/2)*Subject(cs).Path(cpath).SKernel_ARD.xi(1);
                KA{5}(cs,sig_id)=KA{5}(cs,sig_id) +(1/2)*Subject(cs).Path(cpath).SKernel_ARD.xi(2);
                KA{6}(cs,sig_id)=KA{6}(cs,sig_id) +(1/2)*Subject(cs).Path(cpath).SKernel_ARD.xi(3);
                KA{7}(cs,sig_id)=KA{7}(cs,sig_id) +(1/2)*Subject(cs).Path(cpath).SKernel_ARD.xi(4);
            elseif(numb_info==8)
                KA{4}(cs,sig_id)=KA{4}(cs,sig_id) +(1/2)*Subject(cs).Path(cpath).SKernel_ARD.xi(1);
                KA{5}(cs,sig_id)=KA{5}(cs,sig_id) +(1/2)*Subject(cs).Path(cpath).SKernel_ARD.xi(2);
                KA{6}(cs,sig_id)=KA{6}(cs,sig_id) +(1/2)*Subject(cs).Path(cpath).SKernel_ARD.xi(3);
                KA{7}(cs,sig_id)=KA{7}(cs,sig_id) +(1/2)*Subject(cs).Path(cpath).SKernel_ARD.xi(4);
                KA{8}(cs,sig_id)=KA{8}(cs,sig_id) +(1/2)*Subject(cs).Path(cpath).SKernel_ARD.xi(5);
                KA{9}(cs,sig_id)=KA{9}(cs,sig_id) +(1/2)*Subject(cs).Path(cpath).SKernel_ARD.xi(6);
                KA{10}(cs,sig_id)=KA{10}(cs,sig_id) +(1/2)*Subject(cs).Path(cpath).SKernel_ARD.xi(7);
                KA{11}(cs,sig_id)=KA{11}(cs,sig_id) +(1/2)*Subject(cs).Path(cpath).SKernel_ARD.xi(8);
             end    
        end
    end
end

% sig_id×params
R_sig_id_param=[mean(R{1},1)',mean(R{2},1)'];
L_sig_id_param=[mean(L{1},1)',mean(L{2},1)',mean(L{3},1)'];
K_sig_id_param=[mean(K{1},1)',mean(K{2},1)',mean(K{3},1)',mean(K{4},1)'];
KA_sig_id_param=[mean(KA{1},1)',mean(KA{2},1)',mean(KA{3},1)',mean(KA{4},1)',mean(KA{5},1)',...
    mean(KA{6},1)',mean(KA{7},1)',mean(KA{8},1)',mean(KA{9},1)',mean(KA{10},1)',mean(KA{11},1)'];
sig_id_param=[R_sig_id_param,L_sig_id_param,K_sig_id_param,KA_sig_id_param];
xlswrite('fiting_params.xlsx',sig_id_param,'signals param')

% subject×params
R_subj_param=[mean(R{1},2),mean(R{2},2)];
L_subj_param=[mean(L{1},2),mean(L{2},2),mean(L{3},2)];
K_subj_param=[mean(K{1},2),mean(K{2},2),mean(K{3},2),mean(K{4},2)];
KA_subj_param=[mean(KA{1},2),mean(KA{2},2),mean(KA{3},2),mean(KA{4},2),mean(KA{5},2),mean(KA{6},2),...
    mean(KA{7},2),mean(KA{8},2),mean(KA{9},2),mean(KA{10},2),mean(KA{11},2)];
subj_param=[R_subj_param,L_subj_param,K_subj_param,KA_subj_param];
xlswrite('fiting_params.xlsx',subj_param,'subjects param')

% average model×params
A=nan(3,11);
A(1,:)=[mean(R_subj_param),nan(1,9)];
A(2,:)=[mean(L_subj_param),nan(1,8)];
A(3,:)=[mean(K_subj_param),nan(1,7)];
A(4,:)=[mean(KA_subj_param)];
xlswrite('fiting_params.xlsx',A,'model param')
A([4],:)


