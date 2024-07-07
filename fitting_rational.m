function Subject = fitting_rational
% Attention allocation rational belief model のfitting

% data import
load PriceSetUp PriceSetUp
load Subject Subject 
numb_signals=[1,1,4,4,8,8;8,8,1,1,4,4;4,4,8,8,1,1];

for cs=1:length(Subject)
    for cpath=1:length(Subject(cs).Path)
%         try
        tic
        [cs,cpath]
        
        if(rem(Subject(cs).subject_id,3)==0)
            numb_info=numb_signals(3,cpath);
        else
            numb_info=numb_signals(rem(Subject(cs).subject_id,3),cpath);
        end       
        
        clear inv price target_rtn info_rtn beta tau02 eta2 params
        inv=Subject(cs).Path(cpath).diff_investment_rate_sequ'; 
 

        price=PriceSetUp(cpath).target_price.sequ(1,[119:198])';
        target_rtn=PriceSetUp(cpath).target_rtn([119:198],1);
        x_mat=PriceSetUp(cpath).info_rtn([119:198],[1:numb_info]);%info_rtn
        beta=PriceSetUp(cpath).beta([1:numb_info]);
        tau02=PriceSetUp(cpath).tau02;
        eta2=PriceSetUp(cpath).eta2([1:numb_info]);

        % sig_ss, sig_rs, g, sig_G
        clear sig_ss sig_rs g sig_G
        for cs1=1:numb_info
            for cs2=1:numb_info
                if(cs1==cs2)
                    sig_ss(cs1,cs2)=beta(cs1)*beta(cs2)*tau02 + eta2(cs1);
                else
                    sig_ss(cs1,cs2)=beta(cs1)*beta(cs2)*tau02;
                end
            end
        end
        for csg=1:numb_info
            sig_rs(1,csg)=beta(csg)*tau02;
        end
        g=sig_rs*pinv(sig_ss);
        for cs1=1:numb_info
            for cs2=1:numb_info
                sig_G(cs1,cs2)=(tau02*g(cs1)*beta(cs1))*(tau02*g(cs2)*beta(cs2));
            end
        end

        % rational belief
        clear omega_r tau2
        omega_r=g*x_mat';
        omega_r=omega_r';%T×1
        tau2=tau02-(sig_rs*pinv(sig_ss)*sig_rs');%1×1

        % fitting ⇒ gamma, sigma2
        clear ln_gamma ln_sigma2 opt_mllh aic
        params0=zeros(1,2);
        optnew = optimset('Display','notify','MaxFunEvals',500,'TolFun',1e-6);  
        func=@(params)llh_rational(price,x_mat,inv,omega_r,tau02,params);
        [params_ml, opt_mllh, exitsig] = fminunc(func,params0,optnew);
        
        %params
        ln_gamma=params_ml(1);
        ln_sigma2=params_ml(2);
        %aic
        aic=2*opt_mllh+2*2;%gamma,sigma2

        % results
        Subject(cs).Path(cpath).R.kappa=0;
        Subject(cs).Path(cpath).R.gamma=exp(ln_gamma);
        Subject(cs).Path(cpath).R.sigma2=exp(ln_sigma2);
        Subject(cs).Path(cpath).R.llh=-opt_mllh;
        Subject(cs).Path(cpath).R.aic=aic;
        Subject(cs).Path(cpath).R.m=ones(1,numb_info);
        Subject(cs).Path(cpath).R.exitsig=exitsig;
        
%         catch
%             disp('fitting error: cs path=')
%             [cs cpath]            
%         end
    end
end
end

function mllh = llh_rational(price,x_mat,inv,omega_r,tau2,params)
ln_gamma=params(1);
ln_sigma2=params(2);
gamma=exp(ln_gamma);
sigma2=exp(ln_sigma2);

% m llh
numb_s=length(x_mat(1,:));
llh=0;
for ct=1:length(price)
    diff=inv(ct,1)-(omega_r(ct,1)/(gamma*price(ct,1)*tau2));%%%%%%%%%
    llh=llh + (-(1/2)*log(2*pi*sigma2)-(1/sigma2)*(diff^2));
end

mllh=-llh;%out put minus log liklyhood
end

