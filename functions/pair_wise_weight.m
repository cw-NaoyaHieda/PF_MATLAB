%Qの計算に必要な新しいwight
%メモリの問題で、Nがある程度大きい時は計算結果をCPUのメモリに移動
function [pw_weight] = pair_wise_weight(N, dT, beta_est, filter_X, filter_weight, sm_weight)
  if N > 1000 | dT > 100000
    pw_weight = zeros(N, N, dT);
    for dt = 2:(dT - 1)
      %分母計算 横にnormpdfの分子が変化、縦に分母が変化
      bunbo = filter_weight(dt - 1,:) * normpdf([filter_X(dt,:)], [sqrt(beta_est) *  filter_X(dt - 1, :)]', sqrt(1 - beta_est)); 
      %分子計算しつつ代入　現時点を横、一時点前を縦の行列で
      pw_weight(:,:,dt) = gather(normpdf([filter_X(dt,:)], [sqrt(beta_est) *  filter_X(dt - 1, :)]', sqrt(1 - beta_est)) .* (filter_weight(dt - 1,:)' * sm_weight (dt,:) ./ bunbo));
    end
  else
    pw_weight = ones(N, N, dT,'gpuArray');
    for dt = 2:(dT - 1)
      %分母計算 横にnormpdfの分子が変化、縦に分母が変化
      bunbo = filter_weight(dt - 1,:) * normpdf([filter_X(dt,:)], [sqrt(beta_est) *  filter_X(dt - 1, :)]', sqrt(1 - beta_est)); 
      %分子計算しつつ代入　現時点を横、一時点前を縦の行列で
      pw_weight(:,:,dt) = normpdf([filter_X(dt,:)], [sqrt(beta_est) *  filter_X(dt - 1, :)]', sqrt(1 - beta_est)) .* (filter_weight(dt - 1,:)' * sm_weight (dt,:) ./ bunbo);
    end
  end
  
end