function main()
	% Simulate M-PSK transmission and symbol error. 
	% Run a Monte Carlo simulation to estimate symbol error probability.
	% Calculate symbol error probability from the exact formula (see "Digital 
	% Communications" Proakis 5th ed.) and upper/lower bounds. 
	% Plot the results.
	mpskMvals = [2 4 8 16]; % M values for the M-PSK system.
	N0 = 1;
	ebn0 = [1:2:12] / N0; % Eb/N0 (SNR) values.
	ERR_CALC_THRESH	 = 250; % Calc. P_err after this num. errors occur.
	MpskExact = mpsk_prob_err_exact(ebn0, mpskMvals, N0);
	MpskMC = mcsim_mpsk(ebn0, mpskMvals, N0, ERR_CALC_THRESH);
	save('mpsk_data.mat');
	plot_mpsk_data(MpskExact, MpskMC);
end