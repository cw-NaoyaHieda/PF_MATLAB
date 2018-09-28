function [density] = g_DR(rho, PD, DR)
  density = sqrt((1-rho)/rho).* exp(0.5*(icdf('normal', DR,0,1).^2 - ((sqrt(1-rho).*icdf('normal', DR,0,1)-icdf('normal', PD,0,1)./sqrt(rho))^2)));
end

