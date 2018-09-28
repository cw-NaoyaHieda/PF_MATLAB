% g_DR.fnからランダムサンプリング
% SIR (sampling/ importnaece - resampling)法で
% q(z)からL個のサンプルを抽出
% q(z)は　pd, rho を与えたときの　g_DR.fnの平均、分散と等しくなるような
% ガンマ分布から持ってくる
% weightの計算、resampling

SIR_DR <- function(L, pd, rho)
{
  m.dr = integrate(function(x) { x * g_DR.fn(rho=rho,PD=pd,x) },
                   lower=0, upper=1)$value
  v.dr = integrate(function(x) { x^2 * g_DR.fn(rho=rho,PD=pd,x) },
                   lower=0, upper=1)$value - m.dr^2
  
  ## 提案分布
  q <- rgamma(L, shape= m.dr^2/v.dr, rate=m.dr/v.dr)
  ## 重み
  w <- sapply(q, g_DR.fn, rho=rho, PD=pd)/dgamma(q, shape= m.dr^2/v.dr, rate=m.dr/v.dr)
  w <- w/sum(w)
  ## resample
  q.resample <- Resample1(q, weight=w, NofSample = L)
  list(m.dr=m.dr,  v.dr=v.dr , q=q.resample, w=w)
}
