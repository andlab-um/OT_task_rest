# OT_task_rest
resting_face task fMRI


### Qingyuan Wu, Haiyan Wu(2021)

## Analysis Code

All code required to reproduce results presented in the paper is here.

Reading order: OTaggbeta, OTnetworkregression, myreconstruct, oldreconstruct, and correlation.

The models are constructed using all code in "OTaggbeta" and "OTnetworkregression".
We use code in "aggbeta" to predict each IC in the task state by all extracted ICs from the rsfMRI data.
Running code in the "networkregression", we represent the activity of a network by averaging the value of ICs belonging to the network, so that every network has one averaged IC. Then we use these averaged ICs to predict the ICs in the task state.
Due to the code in "aggbeta" and "networkregression" being most similar, we only write detailed code comments in "OT aggbeta".

"Myreconstruct" and "oldreconstruct" are all applied to predicting task data through combining the resting data and the model, followed by calculating the correlation coefficients between the predicted data and the actual data. The only difference between the two scripts is that the resting data of one subject is combined with his own beta map in "myreconstruct", but is combined with other's beta map in "oldreconstruct".

Specifically, the difference is displayed in the step "ypredict=XrestPL*agg_beta28(:,c);" of the first loop. "Myreconstruct" provides detailed code comments.




## Data


- The behavior data for the experiment are in `beha_data.csv`
- All fMRI data with descriptions of the variables is put in openfmri

## Models

predictive modelling and analysis (including figure 2-3) is under `./models`

