# m-psk_mc_sim
A Monte Carlo simulation of M-PSK symbol error rates.

Phase-shift keying (PSK) is a means of encoding information on a carrier wave by modulating the frequency. In M-PSK, one of m = 1, 2, ... M quantized phases are transmitted at a time. This project calculates probability of symbol error when information is transmitted by M-PSK on a channel that contains Gaussian noise. It runs a Monte Carlo simulation to calculate symbol error probability. Additionally, the theoretical result is calculated. These data are plotted with the theoretical upper and lower bounds.

<div align="center"><img src="https://cloud.githubusercontent.com/assets/3694352/16243691/159507ca-37be-11e6-8e8c-be805b9c53d6.png" style="width: 400px;"/></div>

MC simulation results are plotted with "o" markers. Exact results are shown by the solid lines. Upper/lower bounds are shown by the gray patches.

For more info, see the file *MPSK_MC_summary.pdf*.
