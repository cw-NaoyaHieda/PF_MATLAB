function [x] = sig_env(y)
  x = (1/2)*log(y/(1-y))
end
