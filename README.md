# m-psk_mc_sim

Phase-shift keying (PSK) is a means of encoding information on a carrier wave by modulating the frequency. In M-PSK, one of m = 1, 2, ... M quantized phases are transmitted at a time. The relationship between SNR and error probability is important for understanding the performance of a M-PSK communication system.

This project calculates probability of symbol error when information is transmitted by M-PSK on a channel that contains Gaussian noise. It runs a Monte Carlo simulation to calculate symbol error probability. The results are plotted with the theoretical result and the theoretical upper and lower bounds.

<div align="center"><img src="https://cloud.githubusercontent.com/assets/3694352/16243691/159507ca-37be-11e6-8e8c-be805b9c53d6.png" style="width: 400px;"/></div>

MC simulation results are plotted with "o" markers. Exact results are shown by the solid lines. Upper/lower bounds are shown by the gray patches.

A detailed description is given in the file *MPSK_MC_summary.pdf*.
