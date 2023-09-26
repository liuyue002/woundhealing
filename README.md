
# Practical identifiability analysis for PDE models of cell invasion

MATLAB code for performing practical identifiability analysis. This is supplement to Liu, Suh, Maini, Cohen & Baker 2023 "Parameter identifiability and model selection for partial differential equation models of cell invasion".

The paper: https://arxiv.org/abs/2309.01476.

Raw data: https://zenodo.org/record/8377953 (processed data are provided within this repo)


## Files

### Main files

* **param_iden.m**: Perhaps the most important script. This runs parameter identifiability analysis using profile likelihoods. Before running it, check over the settings in the first section of the file. See the file itself for instructions on how to run it.
* **process_experimental_data.m**: process the experimental data, see *Data* below for details. Should run this script (once) before anything else.
* **mcmc.m**: Run Markov Chain Monte Carlo with Metropolis-Hastings algorithm to find the posterior distribution of parameters. This is mostly for a performance comparison with profile likelihoods.
* **generate_synthetic_data.m**: Generate synthetic data for doing the analysis in the supplementary materials.
* **woundhealing_1d.m, woundhealing_2d.m**: Simulate the model in one or two spatial dimensions.

### Helper functions
These functions/scripts are invoked in other scripts and you should not run these by themselves.
* **optimize_likelihood.m**: Optimise the likelihood function (in practice, minimise the squared residual) with respect to a subset of the model parameters. Used to calculate the MLE, and the profile likelihood function at a single point.
* **cmaes.m**: Implements the CMAES optimisation algorithm, which is one of the algorithms supported in *optimize_likelihood.m* (in addition to MATLAB's built-in *fmincon*). This file comes from https://cma-es.github.io/cmaes_sourcecode_page.html , written by Nikolaus Hansen, used under GNU General Public License.
* **get_reduced_model_data.m**: Give a set of parameter values, run simulations to obtain model data, down-sample the data if desired, then rearrange the data as a rank-1 vector. Used during profile likelihood calculations.
* **interp_zero.m**: Given a curve represented with a list of x and y coordinates, find all zeroes of the curve using linear interpolation between the points. Used as a cheap way to find the edge of confidence intervals from profile likelihood curves.
* **log_likelihood.m**: Given residual error between model and data, and the number of data points, calculate the likelihood function assuming Gaussian i.i.d error.
* **plot_kymograph.m**: Plot a kymograph representation of model solution in one spatial dimension.
* **squared_error.m**: Compute the squared error (residual) between data and model by running simulations of the model
* **biggerFont.m**, **tightEdge.m**: Helper functions for making prettier plots.
* **draw_circle.m, update_circle.m**: Used only for annotating animations of the cell density data

### Data
The data comes from 8 barrier assay experiments. Experiments 1,2,5,6 (renamed to 1,2,3,4 in the paper) has circular initial conditions, and experiments 3,4,7,8 (renamed to 5,6,7,8) has triangular initial conditions.

* **experimental_data/raw_data**: contains cell density data processed directly from the experimental images. These MAT files are also provided in Zenodo. Within each MAT file, the "density" variable is the most important. It is a rank-3 tensor, such that density(i,j,k) is the cell density at location (x_i, y_j), at time t_k, in units of cells/μm^2. Other variables relates to cell cycle data, which were not used in the paper.
* **experimental_data/processed_data**: the folder is empty, but can be populated by running *process_experimental_data.m*. Renamed the cell density tensor to "noisy_data" and reshaped so noisy_data(k,i,j)=density(i,j,k). Also contains various animations and visualisations of the data.
* **Images taken from the experiments** are provided on Zenodo (files too large to be provided here, they are also not used directly by the rest of the code).
 
## Branches
The 'public' branch contains cleaned up codes that simulate the models. If you are not the authors, you should look at this branch. The other branches additionally contain codes for analysis, auxillary scripts, as well as work-in-progress. The code is very messy and it is unlikely to be interesting to anyone else.

