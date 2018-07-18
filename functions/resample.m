%リサンプリング関数
function y = resample(cumsum_weight, x, N)
  ch = x < cumsum_weight;
  y = N - sum(ch) + 1;
end