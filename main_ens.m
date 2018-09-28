%GPUのデバイスの数確認
gpuDeviceCount
%現在使用しているデバイスの確認
gpuDevice
%seed
rng(1024)
clear global;
reset(gpuDevice(1));
%各変数の値
N = 100;
X_0 = -2.5;
beta = 0.75;
rho = 0.08;
q_qnorm = icdf('Normal',0.02,0,1);
X_0 = -2.5;
dT = 100;
ens_rate = 0.7;
%フィルタリングやスムージングの結果のベクトル
%predict_Y_mean = ones(dT,1,'gpuArray');
params_opter =  ones(30,3);
%答え
X = ones(dT,1,'gpuArray');
DR = ones(dT,1,'gpuArray');

X(1) = sqrt(beta)*X_0 + sqrt(1 - beta) * random('Normal',0,1);


for i = 2:dT
    X(i) = sqrt(beta)*X(i-1) + sqrt(1 - beta) * random('Normal',0,1);
    DR(i) = r_DR(X(i-1),q_qnorm, rho, beta);
end
fprintf('X DR set\n');
DR(1) = DR(2)*(random('Normal',0,1)*0.05+1);
%csvwrite("data_9/X_plot.csv",X);
%csvwrite("data_9/DR_plot.csv",DR);
%csvwrite("data_9/DR_mean.csv",(q_qnorm-sqrt(beta*rho)*X)/(1-rho));
%data = csvread("data/X.csv");
%X = data(1:98,3);
%pd = makedist('Normal',0,1);
%DR = icdf(pd,data(2:99,5));


X_0_est = X_0;
beta_est = beta;
rho_est = rho;
q_qnorm_est = q_qnorm;

for count = 1:30
  [filter_X, filter_weight, filter_X_mean] = particle_filter(N, dT, DR, beta, q_qnorm, rho, X_0);
  fprintf('Filter end\n');
  %csvwrite('data_9/filter_X.csv',filter_X);
  %csvwrite('data_9/filter_weight.csv',filter_weight)
  %csvwrite('data_9/filter_mean.csv',filter_X_mean);
  [sm_X, sm_weight, sm_X_mean] = particle_smoother(N, dT, beta, filter_X, filter_weight);
  fprintf('Smoothing end\n');
  %csvwrite('data_9/smoothing_mean.csv',sm_X_mean);
  
  %アンサンブルな部分
  y = randsample(N,N * ens_rate);
  filter_X = filter_X(:,y);
  filter_weight = filter_weight(:,y)./sum(filter_weight,2);
  sm_weight = sm_weight(:,y)./sum(sm_weight,2);
  N = N * ens_rate;
  
  [pw_weight] = pair_wise_weight(N, dT, beta_est, filter_X, filter_weight, sm_weight);
  fprintf('pw_weight set\n');
  
  PMCEM = @(params)Q_calc_nf(params, X_0, dT, pw_weight, filter_X, sm_weight, DR);
  first_pm = [sig_env(beta),q_qnorm,sig_env(rho)];
  %options = optimoptions(@fminunc,'Display','iter','UseParallel',true,'Algorithm','quasi-newton');
  options = optimoptions(@fminunc,'Display','iter','Algorithm','quasi-newton');
  [params,fval,exitflag,output] = fminunc(PMCEM, first_pm, options);
  params
  PMCEM(first_pm)
  fval
  params_opter(count,:) = params;
  N = N / ens_rate;
end

plot(1:dT,X)
hold on
plot(1:(dT-1),filter_X_mean)
hold on
plot(1:(dT-1),sm_X_mean)
hold off
legend('Answer','filter','smoother')

%reset(gpuDevice(1))



