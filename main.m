%GPUのデバイスの数確認
gpuDeviceCount
%現在使用しているデバイスの確認
gpuDevice
%seed
rng(1012)

%各変数の値
N = 1000;
X_0 = -2.5;
beta = 0.75;
rho = 0.08;
q_qnorm = icdf('Normal',0.02,0,1);
X_0 = -2.5;
dT = 100;

%フィルタリングやスムージングの結果のベクトル
%predict_Y_mean = ones(dT,1,'gpuArray');

%答え
X = ones(dT,1,'gpuArray');
DR = ones(dT,1,'gpuArray');

X(1) = sqrt(beta)*X_0 + sqrt(1 - beta) * random('Normal',0,1);


for i = 2:dT
    X(i) = sqrt(beta)*X(i-1) + sqrt(1 - beta) * random('Normal',0,1);
    DR(i) = r_DR(X(i-1),q_qnorm, rho, beta);
end
DR(1) = DR(2)*(random('Normal',0,1)*0.05+1);
csvwrite("data/matlab_X.csv",X);
csvwrite("data/matlab_DR.csv",DR);
%data = csvread("data/X.csv");
%X = data(1:98,3);
%pd = makedist('Normal',0,1);
%DR = icdf(pd,data(2:99,5));



beta_est = beta;
q_qnorm_est = q_qnorm;
rho_est = rho;
X_0_est = X_0;

[filter_X, filter_weight, filter_X_mean] = particle_filter(N, dT, DR, beta, q_qnorm, rho, X_0);
[sm_weight, sm_X_mean] = particle_smoother(N, dT, beta, filter_X, filter_weight);
[pw_weight] = pair_wise_weight(N, dT, beta_est, filter_X, filter_weight, sm_weight);

PMCEM = @(params)Q_calc(params, dT, pw_weight, filter_X, sm_weight, DR);
first_pm = [beta_est,q_qnorm_est,rho_est,X_0_est];
%options = optimoptions(@fminunc,'Display','iter','Algorithm','quasi-newton');
%[params,fval,exitflag,output] = fminunc(PMCEM, first_pm, options);
[params,fval] = fminunc(PMCEM, first_pm);


%csvwrite("data/matlab_pf.csv",filter_X_mean);
%csvwrite("data/matlab_sm.csv",sm_X_mean);
%plot(1:dT,X)
%hold on
%plot(1:dT,filter_X_mean)
%hold on
%plot(1:dT,sm_X_mean)
%hold off
%legend('Answer','filter','smoother')





