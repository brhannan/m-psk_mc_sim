function plot_mpsk_data();
	% Plot MPSK simulation data.

	% Go get MpskExactStruct and MpskMcStruct.
	load('mpsk_exact_bounds.mat');
	load('mpsk_mc.mat');

	% Make sure the x vals are the same.
	assert(isequal(MpskExactStruct.bitEnergyVals,MpskMcStruct.bitEnergyVals), ...
		'Be/N0 not equal!');

	xSnr = 10*log10(MpskMcStruct.bitEnergyVals);

	% Plot exact formula and bounds data.
	figure(1);
		clf;
		% M=2 curve
		h_m2 = semilogy(xSnr, MpskExactStruct.M2.errProb);
		hold on;
		h_mc_m2 = semilogy(xSnr, MpskMcStruct.M2, 'ko');
		hold off;
		% M=4 curve
		hold on;
		h_m4 = semilogy(xSnr, MpskExactStruct.M4.errProb);
		hold off;
		hold on;
		h_mc_m4 = semilogy(xSnr, MpskMcStruct.M4, 'ko');
		hold off;
		% M=8 curve
		hold on;
		h_m8 = semilogy(xSnr, MpskExactStruct.M8.errProb);
		hold off;
		hold on;
		h_mc_m8 = semilogy(xSnr, MpskMcStruct.M8, 'ko');
		hold off;
		% M=16 curve
		hold on;
		h_m16 = semilogy(xSnr, MpskExactStruct.M16.errProb);
		hold off;
		hold on;
		h_mc_m16 = semilogy(xSnr, MpskMcStruct.M16, 'ko');
		hold off;
		% Plot bounds.
		hold on;
		h_bounds = plot(xSnr, MpskExactStruct.M2.lb, '--k*', ...
			xSnr, MpskExactStruct.M2.ub, '--k*');
		hold off;
		hold on;
		plot(xSnr, MpskExactStruct.M4.lb, '--k*', ...
			xSnr, MpskExactStruct.M4.ub, '--k*');
		hold off;
		hold on;
		plot(xSnr, MpskExactStruct.M8.lb, '--k*', ...
			xSnr, MpskExactStruct.M8.ub, '--k*');
		hold off;
		hold on;
		plot(xSnr, MpskExactStruct.M16.lb, '--k*', ...
			xSnr, MpskExactStruct.M16.ub, '--k*');
		hold off;
		h_vec = [h_m2, h_m4, h_m8, h_m16, h_bounds];
		hleg = legend(h_vec, 'M=2', 'M=4', 'M=8', 'M=16', 'Bounds',...
			'Location', 'SouthWest');
		hxl = xlabel('$E_B/N_0$ (dB)');
		hyl = ylabel('Probability of symbol error $P_e$');
		set([hxl, hyl], 'interpreter', 'latex', 'FontSize', 22);
		set(hleg, 'fontsize', 14);
		set(h_vec, 'LineWidth', 3);
		set(gca, 'FontSize', 14);
		grid on;
		xlim([0,9]);
end