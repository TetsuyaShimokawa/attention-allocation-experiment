function fig_m_beta_slope_ARDkernel

% data import
load PriceSetUp PriceSetUp
load Subject Subject 
numb_signals=[1,1,4,4,8,8;8,8,1,1,4,4;4,4,8,8,1,1];
beta_ptn=[-0.7,-0.5,-0.3,-0.1,0.1,0.3,0.5,0.7];
numb_path=6;

slop=[];
for cs=1:length(Subject)
    Bt=[];AA=[];
    for cpath=1:numb_path

        if(rem(Subject(cs).subject_id,3)==0)
            numb_s=numb_signals(3,cpath);
        else
            numb_s=numb_signals(rem(Subject(cs).subject_id,3),cpath);
        end  


        if(Subject(cs).Path(cpath).SKernel_ARD.exitsig>0)
            clear diff_f
            diff_f=nanmean(Subject(cs).Path(cpath).SKernel_ARD.diff_f);

            for csig=1:numb_s  
                Bt=[Bt,abs(PriceSetUp(cpath).beta(csig))];
                AA=[AA, diff_f(csig)];
            end
        end
    end
    slop(cs) = Bt'\AA';
end

figure
histogram(slop,20)
[nanmean(slop),nanstd(slop),nanmean(slop)/nanstd(slop)]