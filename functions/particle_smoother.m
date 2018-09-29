%平滑化
function [sm_X, sm_weight, sm_X_mean] = particle_smoother(N, dT, beta_est, filter_X, filter_weight)
  sm_X = zeros(dT - 1, N,'gpuArray');
  sm_weight = zeros(dT - 1, N,'gpuArray');
  sm_weight_tmp = zeros(1,N,'gpuArray');
  sm_X_mean = ones(dT - 1, 1,'gpuArray');
  sm_table = ones(N, N, 'gpuArray');
  %T時点のweightは変わらないのでそのまま代入
  sm_X(dT - 1,:) = filter_X(dT - 1,:);
  sm_weight(dT - 1,:) = filter_weight(dT - 1,:);
	sm_X_mean(dT - 1) = sm_weight(dT - 1,:)*filter_X(dT - 1,:)';
	for dt = (dT - 2):-1:1
	    sum_weight = 0;
	    %smtableの計算 横にnormpdfの分子が変化、縦に分母が変化
	    %sm_table  = normpdf([sm_X(dt + 1,:)], [sqrt(beta_est) *  filter_X(dt, :)]', sqrt(1 - beta_est));
	    %分子計算 横にnormpdfの分子が変化、縦に分母が変化
	    %bunsi = sm_weight(dt+1, :) * sm_table';
	    %分母計算 横にnormpdfの分子が変化、縦に分母が変化    
	    %bunbo = filter_weight(dt, :) * sm_table;

			%sm_weight_tmp = filter_weight(dt, :) .* bunsi ./ bunbo;
			
		
	    
	    %cs_weight = cumsum(sm_weight_tmp);
			
			
			
	    %dt
	    %sm_weight(dt, :) = sm_weight_tmp / sum(sm_weight_tmp);
	    %cs_weight(N)
      %weight = sm_weight_tmp / cs_weight(N);
      %cs_weight = cs_weight / cs_weight(N);
      
      sm_table  = normpdf([filter_X(dt + 1,:)], [sqrt(beta_est) *  filter_X(dt, :)]', sqrt(1 - beta_est));
	    %分子計算 横にnormpdfの分子がsm変化、縦に分母が変化
	    bunsi = sm_weight(dt+1, :) .* sm_table;
	    %分母計算 横にnormpdfの分子が変化、縦に分母が変化    
	    bunbo = filter_weight(dt, :) * sm_table;
	    weight = filter_weight(dt,:)' .* (bunsi * (1./bunbo)');
	    
      resample_check_weight = weight.^2;
      resample_check_weight = sum(resample_check_weight);
      sm_X(dt,:) = filter_X(dt,:);
      %リサンプリング (resample)とりあえず並列にしない
      if 0%1 / resample_check_weight < N / 10;
        dt
        weight = repmat(1 / N, N, 1);
        resumple_num =  resample(cs_weight,rand(1,N) ,N);
        sm_X(dt,:) = filter_X(dt,resumple_num);
        dt
      end
      sm_weight(dt, :) = weight;
	    sm_X_mean(dt) = sm_weight(dt,:)*sm_X(dt,:)';
	end
	

end
