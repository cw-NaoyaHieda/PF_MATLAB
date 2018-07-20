function [Q] = Q_calc(params, dT, pw_weight, filter_X, sm_weight, DR)
  beta_est = params(1);
  q_qnorm_est = params(2);
  rho_est = params(3);
  X_0_est = params(4);
  Q_state = 0;
  Q_obeserve = 0;
  first_state = 0;
  for dt = 1:(dT - 1)
    Q_state = Q_state + sum(sum(gpuArray(pw_weight(:,:,dt + 1)) .* log(normpdf([filter_X(dt + 1,:)], [sqrt(beta_est) *  filter_X(dt, :)]', sqrt(1 - beta_est)))));
    Q_obeserve = Q_obeserve + sm_weight(dt,:) * log(g_DR_dinamic(DR(dt+1), filter_X(dt, :), q_qnorm_est, beta_est, rho_est))';
  end
  first_state = sm_weight(1,:) * log(normpdf([filter_X(1,:)], sqrt(beta_est) *  X_0_est, sqrt(1 - beta_est)))';
  Q = gather(-Q_state - Q_obeserve - first_state);
end
