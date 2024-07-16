function main

%You have to run subject_files_combine.m to reorganize Subject.mat at the very beginning.
subject_files_combine

%%% Experimental Data %%%
load PriceSetUp
% The structure PriceSetUp.mat summarizes the stock price data used in the experiment. 
% These were generated from the parameters given in the table in Section 2.6. 
% For example, the target stock price sequence with stock price ID 1 is in
% PriceSetUp(1). target_price.sequ,
% and the first price sequence of the information stocks is in
% PriceSetUp(1).info_price(1).sequ has the price.

load Subject
% The structure Subject.mat summarizes the experimental data for each participant in the experiment. 
% For example, the investment rate and Gaze data for the first trial for participant number 1 are summarized in
% Subject(1).Path(1).investment_rate_sequ
% and
% Subject(1).Path(1).gaze_data
% respectively.


%%% Functions %%%
table_descriptive_stats % The basic statistic of the investment rate.

Subject = fitting_rational; % Model-fitting in the rational expectation model
%save Subject Subject

Subject  = fitting_linear_inattention; % Model-fitting in the linear constraint sparse optimization model 
%save Subject Subject

Subject  = fitting_kernel_inattention; % Model-fitting in the empirical learning  sparse optimization model with the SE kernel model
%save Subject Subject

Subject  = fitting_ARDkernel_inattention; % Model-fitting in the empirical learning  sparse optimization model with the ARD kernel model
%save Subject Subject

table_fitting_params % Make Table of model fitting results

table_model_selection %  Make Table of model selection

fig_gaze_example % Examples of time changes in gaze distribution

% Gaze counts
fig_gaze_beta % (G1 and G2) bar plot the participant average of gaze for each beta
fig_gaze_beta_slope %(G1) Test the positive relationship between the absolute beta value and the gaze count. Derive its slope by fitting it with a linear regression model.
fig_gaze_asym % (G2) Test the asymmetry of the gaze count. Find the difference in gaze between negative beta and positive beta.
fig_gaze_entropy_trend % Test for diachronic change in the gaze distribution. Calculate the entropy of the distribution.

% The linear constraint sparse optimization model 
fig_m_beta_linear % (G1 and G2) Bar plot the participant average of the attention for each beta.
fig_m_beta_slope_linear %(G1) Test the positive relationship between the absolute value of beta and attention. Derive the slope by fitting a linear regression model.
fig_m_asym_linear % (G2) Test the asymmetry in attention allocation. Find the difference in gaze between negative beta and positive beta.
fig_m_entropy_trend_linear %(G3) Test the changes in attention allocation through time. Calculate the entropy of the distribution.

% The empirical learning  sparse optimization model  with the SE kernel model
fig_m_beta_kernel %(G1 and G2) Bar plot the participant average of the attention for each beta.
fig_m_beta_slope_kernel %(G1) Test the positive relationship between the absolute value of beta and attention. Derive the slope by fitting a linear regression model.
fig_m_asym_kernel %(G2) Test the asymmetry in attention allocation. Find the difference in gaze between negative beta and positive beta.
fig_m_entropy_trend_kernel %(G3) Test the changes in attention allocation through time. Calculate the entropy of the distribution.

% The empirical learning  sparse optimization model with the ARD kernel model
fig_m_beta_ARDkernel %(G1 and G2) Bar plot the participant average of the attention for each beta.
fig_m_beta_slope_ARDkernel %(G1) Test the positive relationship between the absolute value of beta and attention. Derive the slope by fitting a linear regression model.
fig_m_asym_ARDkernel %(G2) Test the asymmetry in attention allocation. Find the difference in gaze between negative beta and positive beta.
fig_m_entropy_trend_ARDkernel %(G3) Test the changes in attention allocation through time. Calculate the entropy of the distribution.

