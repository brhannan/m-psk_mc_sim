function MpskMcStruct = mcsim_mpsk(bitEnergyArray, M_array, N0, varargin)
	% Run a Monte Carlo simulation to calculate M-PSK bit error rates.
	% Inputs:
	% 	bitEnergyArray - Array of Eb/N0 values.
	%	M_array - array of M values for the M-PSK system.
	%	N0 - N_0 value =1, included for completeness.
	%	symbolErrThresh - Optional input. Calculate symbol error probability 
	%		after this many symbol errors have occurred. Default value is 100.
	% Output:
	%	MpskMcStruct - A struct with the following fields.
	%		bitEnergyVals - An array of bit energy values.
	%		MN - Array of error probabilities for M=N, where N is 2, 4, 8 or 16.
	% 
	% B. Hannan

	% Set the value of the optional input, symbolErrThresh.
	numVarArgs = length(varargin);
	if numVarArgs > 1
	    error('myfuns:mcsim_mpsk:TooManyInputs', ...
	        'This function takes at most 1 optional input.');
	end
	optArgs = {100};
	optArgs(1:numVarArgs) = varargin;
	symbolErrThresh = optArgs{:};

	MpskMcStruct = struct();
	MpskMcStruct.bitEnergyVals = bitEnergyArray;
	for k = 1:numel(M_array)
		M_now = M_array(k);
		fprintf('\nStart M=%d sim.\n', M_now);
		MpskMcStruct.(sprintf('M%d',M_now)) = sim_m_psk(M_now, bitEnergyArray, ...
			symbolErrThresh, N0);
	end
	% save('mpsk_mc.mat');
end


function probErrArray = sim_m_psk(M, ebArray, errorThresh, N0)
	% Run a MC simulation for M-PSK. Return an array containing an error 
	% probability for each Eb/N0 value.
	% Inputs:
	%	M - The M value for the M-PSK system.
	%	ebArray - Array of bit energy values.
	%	errorThresh - Stop after this number of symbol errors.
	% 	N0 - Eb/N0 gives the SNR.
	% Outputs:
	%	probErrArray - Error prob. for each value of ebArray.
	MAX_LOOP_COUNT = 1e8;
	dTheta = pi/M; 	% The angle that defines the decision region boundary.
	make_noise = @() normrnd(0, sqrt(N0/2)); % Gauss. noise. Mean 0. Var N0/2.
	probErrArray = zeros(size(ebArray));
	for k = 1:numel(ebArray);
		fprintf('Eb=%0.1f... ', ebArray(k));
		loopCount = 0;
		errorCount = 0;
		mVal = 1; % Only need m=1 due to symmetry. Include for clarity.
		bitEnergy = ebArray(k); % E_b
		symbEnergy = bitEnergy * log2(M); % E_s = E_b * log2(M)
		while 1
			m = randi(M,1);
			n1 = make_noise();
			n2 = make_noise();
			% The cos, sin terms below are constant. They are expressed in 
			% terms of m, M for clarity.
			r1 = sqrt(symbEnergy) * cos(2*pi*(mVal-1)/M) + n1;
			r2 = sqrt(symbEnergy) * sin(2*pi*(mVal-1)/M) + n2;
			tfError = check_symbol_error(r1, r2, dTheta);
			if tfError
				errorCount = errorCount + 1;
			end
			if errorCount >= errorThresh
				break;
			end
			if loopCount > MAX_LOOP_COUNT
				fprintf('Max loop count exceeded. M = %d. Eb = %0.2f.\n', ...
					M, bitEnergy);
				break;
			end
			loopCount = loopCount + 1;
		end
		probErrArray(k) = errorCount/loopCount;
		fprintf('Pe = %0.2e\n', probErrArray(k));
	end % k
end

function isSymbolError = check_symbol_error(r1recd, r2recd, deltaTheta)
	% Checks whether the received symbol at location [r1recd, r2recd] lies in 
	% the correct decision region (m=1).
	% Inputs:
	%	r1recd, r2recd - Coords of the received symbol.
	%	deltaTheta - Angle defining the M-PSK decision region. Equals pi/M.
	% Output:
	%	isSymbolError - True if received symbol is outside the decision region.
	u = [1 0 0];
	v = [r1recd r2recd 0];
	assignin('base','u',u); assignin('base','v',v);
	theta = atan2( norm(cross(u,v)), dot(u,v) );
	isSymbolError = abs(theta) > deltaTheta;
end