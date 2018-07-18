%平滑化
function [sm_weight, sm_X_mean] = particle_smoother(N, dT, beta_est, filter_X, filter_weight)
  sm_weight = ones(dT, N,'gpuArray');
  sm_X_mean = ones(dT, 1,'gpuArray');
  %T時点のweightは変わらないのでそのまま代入
  sm_weight(dT - 1,:) = filter_weight(dT - 1,:);
	sm_X_mean(dT - 1) = sm_weight(dT - 1,:)*filter_X(dT - 1,:)';
	for dt = (dT - 2):-1:1
	    sum_weight = 0;
	    for n = 1:N
	        %分子計算
	        bunbo = 0;
	        bunsi = 0;
	        for n2 = 1:N
	        bunsi_ = sm_weight(dt + 1,n2) * normpdf(filter_X(dt + 1,n2), sqrt(beta_est) *  filter_X(dt, n), sqrt(1 - beta_est))';
	        
	        bunbo_ = filter_weight(dt,n2) * normpdf(filter_X(dt + 1,n), sqrt(beta_est) * filter_X(dt,n2), sqrt(1 - beta_est))';
					bunsi = bunsi + bunsi_;
					bunbo = bunbo + bunbo_;
					end
			sm_weight(dt, n) = filter_weight(dt, n) * bunsi / bunbo;
	    sum_weight = sm_weight(dt, n) + sum_weight;		
	    end
	    
	    dt
	    sm_weight(dt, :) = sm_weight(dt, :) / sum_weight;
	    sm_X_mean(dt) = sm_weight(dt,:)*filter_X(dt,:)';
	end

end