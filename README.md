# OT_task_rest
## Oxytocin modulates social brain network correlations in resting and task state (2022 *Cerebral Cortex*) <img src="https://github.com/andlab-um/OT_task_rest/blob/main/procedure.png" align="right" width="380px">

[![DOI](https://img.shields.io/badge/biorxiv-preprint-brightgreen)](https://doi.org/10.1101/2021.12.30.474596)<br />
[![Twitter URL](https://img.shields.io/twitter/url?label=%40ANDlab3&style=social&url=https%3A%2F%2Ftwitter.com%ANDlab3)](https://twitter.com/ANDlab3)


**For this work: <br />**
**Wu Q, Huang Q, Liu C, et al. Oxytocin modulates social brain network correlations in resting and task state[J]. bioRxiv, 2022: 2021.12. 30.474596. <br />


**related prework

Yuanchen Wang, Ruien Wang, Haiyan Wu, The role of oxytocin in modulating self–other distinction in human brain: a pharmacological fMRI study, *Cerebral Cortex*, 2022;, bhac167, https://doi.org/10.1093/cercor/bhac167

___


### Qingyuan Wu et al(2022)
<img src="https://github.com/andlab-um/OT_task_rest/blob/main//main%20result.png" align="center" width="1000px">


## Analysis Code

All code required to reproduce results presented in the paper is here.

The order of reading: OTaggbeta, OTnetworkregression, myreconstruct, oldreconstruct,.

The models are constructed using all code in "OTaggbeta" and "OTnetworkregression".
We use code in "aggbeta" to predict each IC in the task state by all extracted ICs from the rsfMRI data.
Running code in the "networkregression", we represent the activity of a network by averaging the value of ICs belonging to the network, so that every network has one averaged IC. Then we use these averaged ICs to predict the ICs in the task state.
Due to the code in "aggbeta" and "networkregression" being most similar, we only write detailed code comments in "OT aggbeta".

"Myreconstruct" and "oldreconstruct" are all applied to predicting task data through combining the resting data and the model, followed by calculating the correlation coefficients between the predicted data and the actual data. The only difference between the two scripts is that the resting data of one subject is combined with his own beta map in "myreconstruct", but is combined with other's beta map in "oldreconstruct".

Specifically, the difference is displayed in the step "ypredict=XrestPL*agg_beta28(:,c);" of the first loop.
"Myreconstruct" provides detailed code comments.

All files with "SI" prefix are used to produce the result showed in Figure S3 (in supplementary file).

## Data

- The behavior data for the experiment are in `beha_data.csv`
- All fMRI data with descriptions of the variables is put in openfmri


## Bibtex citation

1.


@article{10.1093/cercor/bhac295,
    author = {Wu, Qingyuan and Huang, Qi and Liu, Chao and Wu, Haiyan},
    title = "{Oxytocin modulates social brain network correlations in resting and task state}",
    journal = {Cerebral Cortex},
    volume = {33},
    number = {7},
    pages = {3607-3620},
    year = {2022},
    month = {08},
    abstract = "{The effects of oxytocin (OT) on the social brain can be tracked upon assessing the neural activity in resting and task states, and developing a system-level framework for characterizing the state-based functional relationships of its distinct effect. Here, we contribute to this framework by examining how OT modulates social brain network correlations during resting and task states, using fMRI. First, we investigated network activation, followed by an analysis of the relationships between networks and individual differences. Subsequently, we evaluated the functional connectivity in both states. Finally, the relationship between networks across states was represented by the predictive power of networks in the resting state for task-evoked activities. The differences in the predicted accuracy between the subjects displayed individual variations in this relationship. Our results showed that the activity of the dorsal default mode network in the resting state had the largest predictive power for task-evoked activation of the precuneus network (PN) only in the OT group. The results also demonstrated that OT reduced the individual variation in PN in the prediction process. These findings suggest a distributed but modulatory effect of OT on the association between resting and task-dependent brain networks.}",
    issn = {1047-3211},
    doi = {10.1093/cercor/bhac295},
    url = {https://doi.org/10.1093/cercor/bhac295},
    eprint = {https://academic.oup.com/cercor/article-pdf/33/7/3607/49574829/bhac295.pdf},
}

