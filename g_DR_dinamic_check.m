function opt = check_r_DR(X, DR, dT, params)
  beta_est = params(1);
  q_qnorm_est = params(2);
  rho_est = params(3);
  r_DR(X, q_qnorm, rho, beta)
  opt = 0;
  for i = 1:dT-1
     opt = opt + g_DR_dinamic(DR(i+1), X(i), q_qnorm, beta, rho);
  end
  opt = -opt
end