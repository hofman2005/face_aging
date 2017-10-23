function new_pts = predict_growth_model(pts, growth_model)

%% Model:
%   y2_i = betta_i * y1_i;
%   x2_i = gamma_i * y2_i - a;
%        = gamma_i * betta_i * y1_i - a;
%        = betta_i * (x1_i+a) - a;

if ~isstruct(growth_model)
    new_pts = pts;
    return;
end

x0 = pts(:,2);
y0 = pts(:,1);

y1 = growth_model.betta .* y0;
x1 = growth_model.betta .* (x0 + growth_model.a) - growth_model.a;
% x12 = grwoth_model.gamma .* y1 - growth_model.a;

new_pts = [y1, x1];