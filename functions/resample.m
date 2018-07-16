%リサンプリング関数
function y = resample(cumsum_weight, x, N)
  ch = x < cumsum_weight(1);
  y = N - sum(ch);
end