function MpskExactStruct = mpsk_prob_err_exact(bitEnergyArray, M_array, N0)
	% MPSK_PROB_ERR_EXACT Evaluate the exact formula for M-PSK error probability 
	% and get upper/lower bounds for multiple values of M.
	MpskExactStruct = struct();
	MpskExactStruct.bitEnergyVals = bitEnergyArray;
	for k = 1:numel(M_array)
		M_now = M_array(k);
		MpskExactStruct.(sprintf('M%d',M_now)).errProb = gen_err_prob_curve(...
			bitEnergyArray, M_now, N0);
		[upBound, lowBound] = calculate_bounds_m(bitEnergyArray, M_now);
		MpskExactStruct.(sprintf('M%d',M_now)).ub = upBound;
		MpskExactStruct.(sprintf('M%d',M_now)).lb = lowBound;
	end
	% save('mpsk_exact_bounds.mat');
end % main


function errProbArray = gen_err_prob_curve(snrArray, mVal, N0)
	% Get the P_M curve for one M value.
	% Inputs:
	%	snrArray 	An array of Eb/N0 values.
	%	mVal	The M value for the M-PSK system.
	% 	N0 		The variance of the Gaussian.
	% Outputs:
	%	errProbArray 	An array of error prob. (P_M) values.

	assert(size(snrArray,1) == 1, 'Eb/N0 array must be a row vector.');
	errProbArray = arrayfun(@calculate_err_prob, snrArray, ...
		repmat(mVal, 1, length(snrArray)), repmat(N0, 1, length(snrArray)));
end

function pm = calculate_err_prob(z, mVal, N0)
	% Calculate a P_M value given one M value and one Es/N0 value.
	% Inputs:
	%	z		Es/N0 value.
	%	mVal	The M value for the M-PSK system.
	% 	N0 		The variance of the Gaussian.
	% Outputs:
	%	pm 		Error probability (P_M).

	% Set integration limits. Let x be r0 and y be r1. 
	xmin = 0;
	xmax = 1e3; % Approximate the infinite integral with a large constant.
	ymin = 0;
	if mVal == 2 % Why can't integral2 handle the singularity at tan(pi/2)?
		yMaxFcn = @(x) x * 1e4; % Set upper limit to a large constant to
	else 						% avoid the "singularity problem".
		yMaxFcn = @(x) x * tan(pi/mVal);
	end
	intgdFcn = @(x, y) (2/(pi*N0^2)) * ...
		exp( -log2(mVal)*z + (2*x*sqrt(log2(mVal)/N0))*sqrt(z) - x.^2/N0 ) .* ... 
		exp(- y.^2 / N0);

	myInt = integral2(intgdFcn, xmin, xmax, ymin, yMaxFcn);
	pm = 1 - myInt;
end

function [lbArray, ubArray] = calculate_bounds_m(snrArray, mVal)
	% Calculate upper and lower bounds on P_M for a M-PSK system.
	% Inputs:
	%	snrArray 	An array of Eb/N0 values.
	%	mVal		The M value of the M-PSK system.
	% Outputs:
	%	lbArray		Array of LB values.
	% 	ubArray		Array of UB values.
	assert(size(snrArray,1) == 1, 'Eb/N0 array must be a row vector.');
	myQfun = @(x) 0.5 * erfc(x/sqrt(2)); % Define the Q function.
	lbFun = @(z,mVal) myQfun(sqrt( 2 * z * log2(mVal) * (sin(pi/mVal))^2 ));
	ubFun = @(z,mVal) 2 * myQfun(sqrt( 2 * z * log2(mVal) * (sin(pi/mVal))^2 ));
	lbArray = arrayfun(lbFun, snrArray, repmat(mVal, 1, length(snrArray)));
	ubArray = arrayfun(ubFun, snrArray, repmat(mVal, 1, length(snrArray)));1
end