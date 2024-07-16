function Subject  = fitting_ARDkernel_inattention
% Attention allocation kernel sparse model のfitting　

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

        % rational belief
        clear omega_r tau2
        omega_r=g*x_mat';
        omega_r=omega_r';%T×1
        tau2=tau02-(sig_rs*pinv(sig_ss)*sig_rs');

        % fitting ⇒ gamma, kappa/sita, sigma2
        clear ln_kappa ln_gamma ln_sigma2 opt_mllh aic
        params0=zeros(1,numb_info+3);
        optnew = optimset('Display','notify','MaxFunEvals',500,'TolFun',1e-6);  
        func=@(params)llh_kernel_sparse1(price,x_mat,inv,omega_r,tau02,params);
        [params_ml, opt_mllh, exitsig] = fminunc(func,params0,optnew);
        
        %params
        ln_kappa=params_ml(1);
        ln_xi=params_ml([2:numb_info+1]);
        ln_sigma2=params_ml(numb_info+2);
        ln_gamma=params_ml(numb_info+3);
        
        %aic
        aic=2*opt_mllh + 2*(numb_info+3);%kappa,xi,gamma,sigma2
        
        %opt_m
        tau2=tau02;
        alfa=(1/tau2)*exp(-(1/2)*(1/tau2)*(omega_r.^2));%T×1
        [diff_f]=diff_belief_function(omega_r,alfa,x_mat,exp(ln_kappa),exp(ln_xi));%T×S
        for csigs=1:length(g)
            if(g(csigs)<0)
                diff_f(:,csigs)=-diff_f(:,csigs);%absolute value
            end
        end
        n_diff_f=[];
        for ct=1:length(price)
            n_diff_f(ct,:)=diff_f(ct,:)./g;
        end

        % results
        Subject(cs).Path(cpath).SKernel_ARD.kappa=exp(ln_kappa);
        Subject(cs).Path(cpath).SKernel_ARD.xi=exp(ln_xi);
        Subject(cs).Path(cpath).SKernel_ARD.gamma=exp(ln_gamma);
        Subject(cs).Path(cpath).SKernel_ARD.sigma2=exp(ln_sigma2);
        Subject(cs).Path(cpath).SKernel_ARD.llh=-opt_mllh;
        Subject(cs).Path(cpath).SKernel_ARD.aic=aic;
        Subject(cs).Path(cpath).SKernel_ARD.diff_f=diff_f;
        Subject(cs).Path(cpath).SKernel_ARD.n_diff_f=n_diff_f;
        Subject(cs).Path(cpath).SKernel_ARD.exitsig=exitsig;
        
%         catch
%             disp('fitting error: cs path=')
%             [cs cpath]            
%         end
    end
end
end

function mllh = llh_kernel_sparse1(price,x_mat,inv,omega_r,tau2,params)
numb_info=length(x_mat(1,:));
ln_kappa=params(1);
ln_xi=params([2:numb_info+1]);
ln_sigma2=params(numb_info+2);
ln_gamma=params(numb_info+3);
kappa=exp(ln_kappa);
xi=exp(ln_xi);
sigma2=exp(ln_sigma2);
gamma=exp(ln_gamma);

% alfa
alfa=(1/tau2)*exp(-(1/2)*(1/tau2)*(omega_r.^2));%T×1

% belief in kernel regression
[omega_k]=beleif_kernel_regression(omega_r,alfa,x_mat,kappa,xi);

% m llh
llh=0;
for ct=1:length(price)
    diff=inv(ct,1)-(omega_k(ct,1)/(gamma*price(ct,1)*tau2));
    llh=llh + (-(1/2)*log(2*pi*sigma2)-(1/sigma2)*(diff^2));
end

mllh=-llh;%out put minus log liklyhood
end

function [omega_k]=beleif_kernel_regression(omega_r,alfa,x_mat,kappa,xi)
for cn=1:length(x_mat(:,1))
        Xnm1=x_mat([1:cn],:);
        Knlnm1=calc_Kernel(Xnm1,Xnm1,1./xi);
        Xn=x_mat(cn,:);
        Knln=calc_Kernel(Xn,Xnm1,1./xi);
        A=diag(alfa([1:cn],1));
        rtnnm1=omega_r([1:cn],1);
        omega_k(cn,1) = Knln'*pinv(A*Knlnm1 + 2*kappa*eye(cn))*A*(rtnnm1);
end
end

function [diff_f]=diff_belief_function(omega_r,alfa,x_mat,kappa,xi)
% Derivative of f(x) around x=0
for cn=1:length(x_mat(:,1))
    Xnm1=x_mat([1:cn],:);
    Knlnm1=calc_Kernel(Xnm1,Xnm1,1./xi);
    Xn=x_mat(cn,:);  
    dmy=xi.*Xnm1.*exp(-xi.*(Xnm1.^2)/2);
    A=diag(alfa([1:cn],1));
    rtnnm1=omega_r([1:cn],1);
    diff_f(cn,:) = (dmy'*pinv(A*Knlnm1 + 2*kappa*eye(cn))*A*(rtnnm1))';
end
end

function Knl=calc_Kernel(X,Xo,tau)
%tau 1×M
%X is a K by M dim mat
%Xo is a N by M dim mat, refres to attribute vecs of observed past choices
%Knl is a N by K dim mat
if(length(tau)==1)
    numb_fact=size(Xo,2);
    A=(1/tau)*eye(numb_fact);
else
    A=diag(1./tau);
end
numb_K=length(X(:,1));
numb_N=length(Xo(:,1));
Knl=zeros(numb_N,numb_K);
for cn1=1:numb_N
    for cn2=1:numb_K
        Knl(cn1,cn2)=exp(-(Xo(cn1,:)-X(cn2,:))*A*(Xo(cn1,:)-X(cn2,:))');
    end
end
end








