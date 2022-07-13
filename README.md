# OT_task_rest
# Oxytocin modulates social brain network correlations in resting and task state (2022 Cerebral Cortex) <img src="https://github.com/andlab-um/OT_task_rest/blob/main/procedure.png" align="right" width="361px">

[![DOI](https://img.shields.io/badge/biorxiv-preprint-brightgreen)](https://doi.org/10.1101/2021.12.30.474596)<br />
[![Twitter URL](https://img.shields.io/twitter/url?label=%40ANDlab3&style=social&url=https%3A%2F%2Ftwitter.com%2Flizhn7)](https://twitter.com/ANDlab3)


**For this work: <br />**
**Wu Q, Huang Q, Liu C, et al. Oxytocin modulates social brain network correlations in resting and task state[J]. bioRxiv, 2022: 2021.12. 30.474596. <br />


related prework

Yuanchen Wang, Ruien Wang, Haiyan Wu, The role of oxytocin in modulating self–other distinction in human brain: a pharmacological fMRI study, Cerebral Cortex, 2022;, bhac167, https://doi.org/10.1093/cercor/bhac167

___


### Qingyuan Wu et al(2022)

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

## citation

@article{wang1991role,
  title={The role of oxytocin in modulating self-other distinction in human brain: a pharmacological fMRI study},
  author={Wang, Yuanchen and Wang, Ruien and Wu, Haiyan},
  journal={Cerebral cortex (New York, NY: 1991)},
  pages={bhac167}
}


