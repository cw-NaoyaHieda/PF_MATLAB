%DRの密度
function y = g_DR_dinamic(tilde_DR, X_t_1, q_qnorm, beta, rho)
y = 1 / (sqrt(rho*(1 - beta) / (1 - rho)) * sqrt(2 * pi)) *...
           exp(-(tilde_DR - (q_qnorm - sqrt(rho*beta)*X_t_1) / sqrt(1 - rho)).^2 /...
                 (sqrt(rho*(1 - beta) / (1 - rho))^2*2));
end