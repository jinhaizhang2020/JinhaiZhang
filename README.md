# JinhaiZhang
Welcome to my studio! Feb 11, 2020

Merging plot of surficial portrait of massive data set using the fewest number of active records

Shuqin Wang1, Jinhai Zhang2*
1School of Information Engineering, Minzu University of China, Beijing 100081, China
2Key Laboratory of the Earth's Deep Interior, Institute of Geology and Geophysics, Chinese Academy of Sciences, Beijing 100029, China

Running title: Merging plot of massive data

Submitted to Computer & Geosciences
On Feb 11, 2020

*Corresponding author: Prof. Jinhai Zhang
Institute of Geology and Geophysics, Chinese Academy of Sciences
No.19, Beitucheng West Road, Chaoyang District, Beijing, China, 100029.

Email: zjh@mail.iggcas.ac.cn
Phone: +86-01082998013


Abstract
In many branches of scientific observation, we have accumulated a vast amount of data and hope to dig out some intrinsic rules from the data. The data processing and statistical analyses on massive data are becoming more and more important with the increasing mass of data accumulation. However, we encounter serious problems at the first step when presenting the massive data, due to oversized figures and long-wait time for generating vector graphics. In this paper, we propose a simple but powerful approach to plot the vector graphics of massive data using the degenerate displaying technique, which only shows the superficial portrait of the whole data volume by ignoring the other parts that have no actual contribution to the superficial portrait. We mark one record as active if one or more of its pixels can be seen in the virtual bitmap in the memory, after judging the superposition relationship between this record and all previous marked records. This approach does not degrade the quality of the final vector graphics, since it only selects those marked records to plot. It can greatly suppress the final size of the vector graphics and can significantly reduce the wait time of drawing, editing, and displaying the vector graphics. In an example of 410,642 earthquake catalogs, only 2577 records (~0.63%) were finally selected the data set that was plotted. The resulted degenerate vector graphics is only ~2.2 megabyte in size, which is much smaller than that of the original size (~100+ megabyte). The run time of the plotting is only several minutes, which is greatly reduced from several hours for plotting all the records. The run time of the Matlab code for selecting the active records spends only ~14 s. The degenerate vector graphics can drastically save on memory demand and is helpful for wide dissemination of electronic publications in terms of vector graphics. This technique would be helpful in plotting various types of massive data by faithfully presenting all actual records involved, especially for the rapidly increasing amount of mass data.
