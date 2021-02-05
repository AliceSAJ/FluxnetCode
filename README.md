# FluxnetCode

The R code provided here is for the analysis conducted in the paper:  

Johnston et al. 2021. Temperature threhsolds of ecosystem respiration at a global scale. Nature Ecology & Evolution 2021.

Details of the Fluxnet data used for the analysis and data policy terms that restrict it's upload in a public repository are detailed in the paper, and provided below. 

The R code here provides the temperature breakpoint analysis by comparing linear and threshold models, and comparisons of linear, metabolic, single breakpoint and two breakpoint models for the global dataset. 

The data were compiled from the Fluxnet website (https://fluxnet.fluxdata.org/data/fluxnet2015-dataset/), following the Tier Two data policy (https://fluxnet.org/data/data-policy). Tier Two data include six sites (RU-Sam, RU-SkP, RU-Tks, RU-Vrk, SE-St1, ZA-Kru) that are “available only for scientific and educational purposes, and under this policy, data producers must have opportunities to collaborate and consult with data users. Substantive contributions from data producers result in co-authorship”. All other Fluxnet site data are covered by a CC-BY-4.0 license which should be attributed to the FLUXNET2015 dataset.

The FLUXNET dataset is subject to a data processing pipeline which include data quality control checks, filtering of low turbulence periods and partitioning of CO2 fluxes into respiration and photosynthesis components using established methods. Non-gap-filled half hourly (µmol CO2 m-2 s-1) and annual (g C m 2) night-time ecosystem respiration (RECO_NT_VUT_MEAN), air temperature (TA_F) and soil temperature (TS_F) measurements were compiled and converted to units of metabolic energy (W ha-1) and the reciprocal of absolute temperature ((1,000/T), where T is temperature in Kelvin). 

The dataset used for the code provided here included half hourly night-time ecosystem respiration (TER, W ha-1), air temperature (A_TEMP, (1,000/Air T)) and soil temperature (S_TEMP, (1,000/Air T)) measurements, together with FLUXNET_site (Site name/ID), Year, Lat (Latitude, °), and Climate (broadly classified as Tundra, Boreal, Temperature, Mediterranean and Tropical). 
