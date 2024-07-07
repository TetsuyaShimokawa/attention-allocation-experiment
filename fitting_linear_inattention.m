function Subject  = fitting_linear_inattention
% Attention allocation linear sparse model のfitting

% data import
load PriceSetUp PriceSetUp
load Subject Subject 
numb_signals=[1,1,4,4,8,8;8,8,1,1,4,4;4,4,8,8,1,1];

AICcheck=[];
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
        omega_r=g*x_mat';%T×1
        omega_r=omega_r';%T×1
        tau2=tau02-(sig_rs*pinv(sig_ss)*sig_rs');%1×1

        % fitting ⇒ gamma, kappa/sita, sigma2
        clear ln_kappa ln_gamma ln_sigma2 opt_mllh aic
        params0=zeros(1,3);
        optnew = optimset('Display','notify','MaxFunEvals',500,'TolFun',1e-6);  
        func=@(params)llh_linear_sparse(price,x_mat,inv,omega_r,tau02,g,sig_G,params);
        [params_ml, opt_mllh, exitsig] = fminunc(func,params0,optnew);
        
        %params
        ln_kappa=params_ml(1);
        ln_gamma=params_ml(2);
        ln_sigma2=params_ml(3);

        %aic
        aic=2*opt_mllh+2*3;%kappa,gamma,sigma2
        %opt_m
        kappa=exp(ln_kappa);
        tau2=tau02;
        alfa=(1/tau2)*exp(-(1/2)*(1/tau2)*(omega_r.^2));%T×1
        m_mat=[];
        for ct=1:length(price)
            m=pinv(sig_G+2*(kappa/alfa(ct,1))*eye(numb_info))*sig_G*ones(numb_info,1);
            m_mat(ct,:)=m';
        end

        % results
        Subject(cs).Path(cpath).SKF.kappa=exp(ln_kappa);
        Subject(cs).Path(cpath).SKF.gamma=exp(ln_gamma);
        Subject(cs).Path(cpath).SKF.sigma2=exp(ln_sigma2);
        Subject(cs).Path(cpath).SKF.llh=-opt_mllh;
        Subject(cs).Path(cpath).SKF.aic=aic;
        Subject(cs).Path(cpath).SKF.m=m_mat;
        Subject(cs).Path(cpath).SKF.exitsig=exitsig;
        
%         catch
%             disp('fitting error: cs path=')
%             [cs cpath]            
%         end
    end
end
end

function mllh = llh_linear_sparse(price,x_mat,inv,omega_r,tau2,g,sig_G,params)
ln_kappa=params(1);
ln_gamma=params(2);
ln_sigma2=params(3);
kappa=exp(ln_kappa);
gamma=exp(ln_gamma);
sigma2=exp(ln_sigma2);

% alfa
alfa=(1/tau2)*exp(-(1/2)*(1/tau2)*(omega_r.^2));%T×1

% m llh
numb_s=length(x_mat(1,:));
llh=0;
for ct=1:length(price)
    m=pinv(sig_G+2*(kappa/alfa(ct,1))*eye(numb_s))*sig_G*ones(numb_s,1);
    M=diag(m);
    omega_s(ct,1)=g*M*x_mat(ct,:)';
    diff=inv(ct,1)-(omega_s(ct,1)/(gamma*price(ct,1)*tau2));%%%%
    llh=llh + (-(1/2)*log(2*pi*sigma2)-(1/sigma2)*(diff^2));
end

mllh=-llh;%out put minus log liklyhood
end









