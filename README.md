# Comment to *Spatial Search by Quantum Walk is Optimal for Almost all Graphs* (code)

Date: * 28.09.2020*

Person responsible for data: *Adam Glos* (aglos [at] iitis.pl).


The scripts necessary for generating the plot presented in "Comment to Spatial Search by Quantum Walk is Optimal for Almost all Graphs".


## Used software
* Julia v1.3.1
* NPZ v0.4.0
* LightGraphs v1.3.3
* Expokit v0.2.0
* PyPlot v2.9.0


## Methodics

The calculations were based on the paper "Spatial Search by Quantum Walk is Optimal for Almost all Graphs" (doi.org/10.1103/PhysRevA.102.032214). For each graph order and each p=n^C, 10 Erdös-Renyi were sampled and the change of success probability calculated on the time interval [0, 2T]. Parameter T were calculated based on the proof of the Lemma in the referenced paper. The plots were done on a rescaled time axis, by dividing each time-point by 2T for each graph chosen. We chose the transition rates to be 1/(np) and the one proposed in the proof of the lemma.

To reconstruct the results, please run files therein:
```
julia single_case.jl
julia plotter.jl
```
The first one generates data which are stored in `data`. The latter command generates the plot.
