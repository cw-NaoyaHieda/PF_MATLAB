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
	    %分子計算 横にnormpdfの分子が変化、縦に分母が変化
	    bunsi = sm_weight(dt + 1,:) * normpdf([filter_X(dt + 1,:)], [sqrt(beta_est) *  filter_X(dt, :)]', sqrt(1 - beta_est))';
	    %分母計算 横にnormpdfの分子が変化、縦に分母が変化
	    bunbo = filter_weight(dt,:) * normpdf([filter_X(dt + 1,:)], [sqrt(beta_est) * filter_X(dt,:)]', sqrt(1 - beta_est));
			sm_weight_tmp = filter_weight(dt, :) .* bunsi ./ bunbo;
			sm_weight_tmp = sm_weight_tmp / sum(sm_weight_tmp);
	    resample_check_weight = sum(sm_weight_tmp.^2);
	    sm_x = filter_X(dt,:);
	    sm_weight(dt, :) = sm_weight_tmp;
	    %if 1 / resample_check_weight < N / 10;
      %dt
      %cs_weight = gpuArray(cumsum(sm_weight_tmp));
      %cs_weight = cs_weight / cs_weight(N);
      %sm_weight(dt, :) = repmat(1 / N, N, 1);
      %resumple_num =  resample(cs_weight',rand(1,N) ,N);
      %sm_x = gpuArray(filter_X(dt,resumple_num));
      %end
      sm_X_mean(dt) = sm_weight(dt,:)*sm_x';
	end

end