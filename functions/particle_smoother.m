%平滑化
function [sm_weight, sm_X_mean] = particle_smoother(N, dT, beta_est, filter_X, filter_weight)
  sm_weight = zeros(dT, N,'gpuArray');
  sm_weight_tmp = zeros(1,N,'gpuArray');
  sm_X_mean = ones(dT, 1,'gpuArray');
  %T時点のweightは変わらないのでそのまま代入
  sm_weight(dT - 1,:) = filter_weight(dT - 1,:);
	sm_X_mean(dT - 1) = sm_weight(dT - 1,:)*filter_X(dT - 1,:)';
	for dt = (dT - 2):-1:1
	    sum_weight = 0;
	    parfor n = 1:N
	        %分子計算
	        bunsi = sm_weight(dt + 1,:) * normpdf(filter_X(dt + 1,:), sqrt(beta_est) *  filter_X(dt, n), sqrt(1 - beta_est))';
	        
	        bunbo = filter_weight(dt,:) * normpdf(filter_X(dt + 1,n), sqrt(beta_est) * filter_X(dt,:), sqrt(1 - beta_est))';
					
					sm_weight_tmp(1,n) = filter_weight(dt, n) * bunsi / bunbo;
	        sum_weight = sm_weight_tmp(1, n) + sum_weight;
	    end
	    dt
	    sm_weight(dt, :) = sm_weight_tmp / sum_weight;
	    sm_X_mean(dt) = sm_weight(dt,:)*filter_X(dt,:)';
	end

end