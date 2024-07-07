function table_descriptive_stats
% 主体×signal数

% mean
M=[];
% std
S=[];
% autocorri
A=[];

% data import
load PriceSetUp PriceSetUp
load Subject Subject 
numb_signals=[1,1,4,4,8,8;8,8,1,1,4,4;4,4,8,8,1,1];

for cs=1:length(Subject)
    Sig1M=[];Sig4M=[];Sig8M=[];
    Sig1S=[];Sig4S=[];Sig8S=[];
    Sig1A=[];Sig4A=[];Sig8A=[];
    for cpath=1:length(Subject(cs).Path)        
        if(rem(Subject(cs).subject_id,3)==0)
            numb_info=numb_signals(3,cpath);
        else
            numb_info=numb_signals(rem(Subject(cs).subject_id,3),cpath);
        end       
        inv=Subject(cs).Path(cpath).investment_rate_sequ'; 
        [acf,lags] = autocorr(inv);
        if(numb_info==1)
            Sig1M=[Sig1M,nanmean(inv)];
            Sig1S=[Sig1S,nanstd(inv)];
            Sig1A=[Sig1A,acf(2)];%autocorri lag=1
        elseif(numb_info==4)
            Sig4M=[Sig4M,nanmean(inv)];
            Sig4S=[Sig4S,nanstd(inv)];
            Sig4A=[Sig4A,acf(2)];%autocorri lag=1
        elseif(numb_info==8)
            Sig8M=[Sig8M,nanmean(inv)];
            Sig8S=[Sig8S,nanstd(inv)];
            Sig8A=[Sig8A,acf(2)];%autocorri lag=1
        end
    end
    M(cs,1)=mean([Sig1M,Sig4M,Sig8M]);
    M(cs,2)=mean([Sig1M]);
    M(cs,3)=mean([Sig4M]);
    M(cs,4)=mean([Sig8M]);
    S(cs,1)=mean([Sig1S,Sig4S,Sig8S]);
    S(cs,2)=mean([Sig1S]);
    S(cs,3)=mean([Sig4S]);
    S(cs,4)=mean([Sig8S]);
    A(cs,1)=mean([Sig1A,Sig4A,Sig8A]);
    A(cs,2)=mean([Sig1A]);
    A(cs,3)=mean([Sig4A]);
    A(cs,4)=mean([Sig8A]);
end
M(length(Subject)+1,:)=mean(M);
S(length(Subject)+1,:)=mean(S);
A(length(Subject)+1,:)=mean(A);

xlswrite('descriptiveStats.xlsx',M,'descriptive stats mean')
xlswrite('descriptiveStats.xlsx',S,'descriptive stats std')
xlswrite('descriptiveStats.xlsx',A,'descriptive stats autocorri')

        