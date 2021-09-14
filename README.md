# OT_task_rest
resting_face task fMRI


### Qingyuan Wu, Haiyan Wu(2021)

## Analysis Code

All code required to reproduce results presented in the paper are under `./code`

阅读顺序：OTaggbeta、OTnetworkregression、myreconstruct、oldreconstruct、correlation.

OTaggbeta和OTnetworkregression里的代码全部用于最初的模型构建。
aggbeta是用所有静息态成分（除和任何一个RSN脑网络的相关都不超过0.1的之外）预测特定任务态成分。
networkregression是将同属于一个脑网络的成分进行平均后，用一个成分代表一个脑网络，再用这13个成分（除去初级视觉皮层网络）预测特定任务态成分。
除此之外，aggbeta脚本和networkregression脚本几乎完全相同，因此仅在OTaggbeta脚本中有详细注释。

myreconstruct及oldreconstruct都用于重构，即用静息态数据和aggbeta预测任务态数据，并计算真实数据和预测数据之间的相关性。
两个脚本之间唯一的区别就在于一个被试的静息态数据是带入自己的betamap（myreconstruct）还是带入其他人的betamap（oldreconstruct）
具体区别是在第一个for循环中“ypredict=XrestPL*agg_beta28(:,c);”这一步，详细的注释在myreconstruct里。



## Data


- The behavior data for the experiment are in `beha_data.csv`
- All fMRI data with descriptions of the variables is put in openfmri

## Models

predictive modelling and analysis (including figure 2-3) is under `./models`

## Statical analysis
R scripts for statical analysis
