%平滑化
function [sm_weight, sm_X_mean] = smoother_new(N, dT, beta_est, filter_X)
  sm_X = zeros(dT - 1, N,'gpuArray');
  sm_weight = zeros(dT - 1, N,'gpuArray');
  sm_weight_tmp = zeros(1,N,'gpuArray');
  sm_X_mean = ones(dT - 1, 1,'gpuArray');
  %T時点のweightは変わらないのでそのまま代入
  sm_X(dT - 1,:) = filter_X(dT - 1,:)';
  sm_weight(dT - 1,:) = 1 / N;
	sm_X_mean(dT - 1) = sm_weight(dT - 1,:)*sm_X(dT - 1,:)';
	for dt = (dT - 2):-1:1
	    sum_weight = 0;
	    %分子計算 横にnormpdfの分子が変化、縦に分母が変化
	    bunsi = normpdf([sm_X(dt + 1,:)], [sqrt(beta_est) *  filter_X(dt, :)]', sqrt(1 - beta_est))';
	    %分母計算 横にnormpdfの分子が変化、縦に分母が変化    
	    bunbo = filter_weight(dt,:) * normpdf([sm_X(dt + 1,:)], [sqrt(beta_est) * filter_X(dt,:)]', sqrt(1 - beta_est));

			sm_weight_tmp = bunsi ./ bunbo;
	    %dt
	    %sm_weight(dt, :) = sm_weight_tmp / sum(sm_weight_tmp);
	    cs_weight = cumsum(sm_weight_tmp);
      weight = sm_weight_tmp / cs_weight(N);
      cs_weight = cs_weight / cs_weight(N);
      resample_check_weight = weight.^2;
      resample_check_weight = sum(resample_chlseck_weight);
      %リサンプリング (resample)とりあえず並列にしない
      if 1 / resample_check_weight < N / 10;
      dt;
      weight = repmat(1 / N, N, 1);
      resumple_num =  resample(cs_weight,rand(1,N) ,N);
      sm_X(dt,:) = filter_X(dt,resumple_num);
      else
      sm_X(dt,:) = filter_X(dt,:);
      end
      sm_weight(dt, :) = weight;
	    sm_X_mean(dt) = sm_weight(dt,:)*sm_X(dt,:)';
	end
	

end