function main()
	% Simulate MPSK. Calculate bit error probability from the exact formula
	% (see "Digital Communications" Proakis 5th ed.) and upper/lower bounds. 
	% Run Monte Carlo simulation to estimate symbol error probability.
	% Plot the results.

	N0 = 1;
	mpskMvals = [2 4 8 16]; % M values for the M-PSK system.
	ebn0 = [1:0.5:10] / N0; % Eb/N0 values.

	MpskExact = mpsk_prob_err_exact(ebn0, mpskMvals, N0);
	MC = mcsim_mpsk(ebn0, mpskMvals, N0);
	save('mpsk_data.mat');
	plot_mpsk_data(); % Load, plot the results.
end