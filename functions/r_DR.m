%関数定義
%DRの乱数発生
function y = r_DR(X_t, q_qnorm, rho, beta)
  y = (q_qnorm - sqrt(rho*beta)*X_t) / sqrt(1 - rho) - sqrt(rho*(1 - beta) / (1 - rho)) * random('Normal',0,1);
end


