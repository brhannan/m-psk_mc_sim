function main()
	% Simulate MPSK. Calculate bit error probability from the exact formula
	% (see "Digital Communications" Proakis 5th ed.) and upper/lower bounds. 
	% Run Monte Carlo simulation to estimate symbol error probability.
	% Plot the results.

	% Calculate error probability from exact formula. Get bounds.
	% Saves results to file.
	mpsk_prob_err_exact();
	% Run MC simulation. Results saved to file.
	mcsim_mpsk();
	% Load, plot the results.
	plot_mpsk_data();
end