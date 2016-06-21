function plot_mpsk_data(Data, MCSim);
	% Plot MPSK simulation data.
	% Inputs
	%	Data - A struct containing exact M-PSK data and upper/lower bounds.
	%	MCSim - A struct containing M-PSK Monte Carlo results.

	xSnr = 10*log10(MCSim.bitEnergyVals); % Get SNR in dB.

	% Plot exact formula and bounds data.
	figure(1);
		clf;
		h_ax = gca;
		% M=2 curve
		h_m2 = draw_exact_curve(xSnr, Data.M2.errProb, h_ax);
		h_mc_m2 = draw_mc(xSnr, MCSim.M2, h_ax);
		% M=4 curve
		hold on;
		h_m4 = draw_exact_curve(xSnr, Data.M4.errProb, h_ax);
		hold off;
		h_mc_m4 = draw_mc(xSnr, MCSim.M4, h_ax);
		% M=8 curve
		hold on;
		h_m8 = draw_exact_curve(xSnr, Data.M8.errProb, h_ax);
		hold off;
		h_mc_m8 = draw_mc(xSnr, MCSim.M8, h_ax);
		% M=16 curve
		hold on;
		h_m16 = draw_exact_curve(xSnr, Data.M16.errProb, h_ax);
		hold off;
		h_mc_m16 = draw_mc(xSnr, MCSim.M16, h_ax);
		% Plot bounds.
		draw_bounds_patch(xSnr, Data.M2.lb, Data.M2.ub, h_ax);
		draw_bounds_patch(xSnr, Data.M4.lb, Data.M4.ub, h_ax);
		draw_bounds_patch(xSnr, Data.M8.lb, Data.M8.ub, h_ax);
		draw_bounds_patch(xSnr, Data.M16.lb, Data.M16.ub, h_ax);
		% Create legend, labels.
		h_vec = [h_m2, h_m4, h_m8, h_m16];
		hleg = legend(h_vec, 'M=2', 'M=4', 'M=8', 'M=16', ...
			'Location', 'SouthWest');
		hxl = xlabel('$E_B/N_0$ (dB)');
		hyl = ylabel('Probability of symbol error $P_e$');
		set([hxl, hyl], 'interpreter', 'latex', 'FontSize', 22);
		set(gca, 'FontSize', 14);
		grid on;
		xlim([0 12]);
end


function h_curve = draw_exact_curve(x, y, h_axes, varargin)
	% Plot data obtained by integrating the exact function.
	% Inputs
	%	x, y - Input data.
	%	h_axes - Handle to the axes object.
	%	myLineColor - Optional input. Line color.
	numVarArgs = length(varargin);
	if numVarArgs > 1
	    error('myfuns:draw_exact_curve:TooManyInputs', ...
	        'This function takes at most 1 optional input.');
	end
	optArgs = {-1};
	optArgs(1:numVarArgs) = varargin;
	myLineColor = optArgs{:};
	h_curve = semilogy(h_axes, x, y);
	set(h_curve, 'LineWidth', 3);
	if myLineColor ~= -1
		set(h_curve, 'LineColor', myLineColor);
	end
end

function h_curve = draw_mc(x, y, h_axes, varargin)
	% Plot Monte Carlo data.
	% Inputs
	%	x, y - Input data.
	%	h_axes - Handle to the axes object.
	%	myMarkerColor - Optional input. Line color.
	numVarArgs = length(varargin);
	if numVarArgs > 1
	    error('myfuns:draw_mc:TooManyInputs', ...
	        'This function takes at most 1 optional input.');
	end
	optArgs = {-1};
	optArgs(1:numVarArgs) = varargin;
	myMarkerColor = optArgs{:};
	hold on;
	h_curve = semilogy(h_axes, x, y, 'ko');
	if myMarkerColor ~= -1
		set(h_curve, 'MarkerEdgeColor', myMarkerColor);
	end
	hold off;
end

function h_patch = draw_bounds_patch(x, yu, yl, h_axes, varargin)
	% Draw bounded region as a patch. Return handle to patch object.
	% Inputs
	%	x, yu, yl - Upper/lower bound point coordinates.
	%	h_axes - Axes handle.
	% Outputs
	%	h_patch - A handle to the patch object.
	numVarArgs = length(varargin);
	if numVarArgs > 1
	    error('myfuns:draw_bounds_patch:TooManyInputs', ...
	        'This function takes at most 1 optional input.');
	end
	optArgs = {-1};
	optArgs(1:numVarArgs) = varargin;
	myPatchColor = optArgs{:};
	h_patch = patch(h_axes, [x fliplr(x)], [yu fliplr(yl)], 'k');
	set(h_patch, 'FaceAlpha', 0.2, 'EdgeColor', 'none');
	if myPatchColor ~= -1
		set(h_patch, 'LineColor', myPatchColor);
	end
end