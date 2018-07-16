%GPUのデバイスの数確認
gpuDeviceCount
%現在使用しているデバイスの確認
gpuDevice
%seed
rng(1000)

%各変数の値
N = 1000;
X_0 = -2.5;
beta = 0.75;
rho = 0.08;
q_qnorm = icdf('Normal',0.02,0,1);
X_0 = -2.5;
dT = 100;

filter_X_Kal = ones(dT,1,'gpuArray');
predict_Y_Kal = ones(dT,1,'gpuArray');

%答え
X = ones(dT,1,'gpuArray');
DR = ones(dT,1,'gpuArray');

X(1) = sqrt(beta)*X_0 + sqrt(1 - beta) * random('Normal',0,1);


for i = 2:dT
    X(i) = sqrt(beta)*X(i-1) + sqrt(1 - beta) * random('Normal',0,1);
    DR(i) = r_DR(X(i-1),q_qnorm, rho, beta);
end
DR(1) = DR(2)*(random('Normal',0,1)*0.05+1);

X_0_est = X_0;
beta_est = beta;
rho_est = rho;
q_qnorm_est = q_qnorm;


%カルマンフィルタ
Plant = ss(sqrt(beta_est),sqrt(1 - beta_est) ,- sqrt(rho_est)*sqrt(beta_est) / sqrt(1 - rho_est),0,-1);

%Cの部分 (q_qnorm - sqrt(rho)*sqrt(beta)*X_t) / sqrt(1 - rho)y
w = randn(dT,1);
v = - sqrt(rho_est)*sqrt(1 - beta_est) / sqrt(1 - rho_est)*randn(dT,1);
y = lsim(Plant,w);
yv = y + v;







