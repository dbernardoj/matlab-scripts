function [ ll ] = log_loss( actual, predicted )
%LOGARITHMIC LOSS FUNCTION The logarithm of the likelihood function for a
%Bernoulli random distribution.
%   In plain English, this error metric is typically used where you have to
%   predict that something is true or false with a probability (likelihood)
%   ranging from definitely true (1) to equally true (0.5) to definitely
%   false(0).
eps = 0.01;
predicted = min( max( predicted, eps ), 1 - eps );
ll = -1 / numel( actual ) * ( sum(( actual .* log( predicted ) ...
  + ( 1 - actual ) .* log( 1 - predicted ))));
end