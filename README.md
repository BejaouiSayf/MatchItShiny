# MatchItShiny

Keywords: *propensity score matching, multivariate matching, genetic optimization, causal inference, R.*

`MatchItShiny` is a Matching Software for Causal Inference.
Nonparametric Preprocessing for Parametric Casual Inference

The aim of `MatchItShiny` is to make the imputation of causal effect workflow easier. 

**1. Problematic**: There is no consensus on how exactly matching ought to be done and how to measure the success of the matching procedure. A wide variety of matching procedures have been proposed, and `MatchItShiny` implements many of them.


**2. 2sd problematic**: The work flow of an evaluateur 


**Fields**: each fields where you use method of causal inference - statistics (see for e.g Rubin 2006; Rosenbaum 2002), medecine (Christakis and Iwashyna 2003; Rubin 1997), economics  (Abadie and Imbens 2006; Dehejia and Wahba 2002, 1999), political science (Bowers and Hansen 2005; Herron and Wand 2007; Imai 2005), sociology (Morgan and Harding 2006; Diprete and Engelhardt 2004; Winship and Morgan 1999; Smith 1997) and even law (Rubin 2001).


`MatchItShiny` is an interactive application to visualise and perform impacts analysis. The interface is based on the Shiny web application framework, though can be run locally and with the user's own data.

## Updating to the latest version of `MatchItShiny`

To install it:

```R
# install.packages("devtools")
library(devtools)
devtools::install_github("BejaouiSayf/MatchItShiny")
```

**First step : you need to install devtools**  
![Demo Install devtools R package](https://user-images.githubusercontent.com/19627220/45932929-7daedc00-bf84-11e8-946d-20fa0e6410bd.gif)
**Second step : install MatchItShiny**  
![Demo Install MatchItShiny](https://user-images.githubusercontent.com/19627220/45933170-daf85c80-bf87-11e8-8843-f6cf3d16da69.gif)

<!-- ![Demo Install](https://github.com/BejaouiSayf/MatchItShiny/blob/master/Demo%20Install%20MatchItShiny.gif) -->
<hr>

Another GIF to show the demo Use:   

<!-- ![Demo Use](https://github.com/BejaouiSayf/MatchItShiny/blob/master/Demo%20Use%20MatchItShiny.gif)-->

![](https://www.iloveimg.com/fr/download/3smq1ghw0hcnrdmc03s8cfzbh1n5rztwls2lk27p0kg9fqft3lyftzpr4rbzfp88kp4fy98pfb9rzfg7nj1wg4nzqpry1dvjz657l6nf9h2bAkgpd7q1n96fc4y2r8yAhzmjj55xfbzbjA1f4ypgn388tkg67db50wh6z9gxq4gr2z8fdvz1/1)


### What's new

The package is working fine.
As soon as possible, I will submit the package to CRAN.

I'm always happy to hear about what doesn't work for you and where `MatchItShiny` get in your way (send an email to the [maintainer](bejaoui@gmail.com))



## Todo
**Add difference-in-difference method** 
**Add Matching difference-in-difference**

## For Developpers
- Please work on the develop branch, it's newer than master. the master branch is for users. 
- Love
- Markdown

## Licence
Rq : Tu pense que tu n'as pas le droit de mettre ton pkg sous licence MIT ! 
En fait, tu pense que le CRAN veulent que le pkg soit sous Licence GPU
The plugin is licensed under the MIT license.

Copyright (C) <2012> Muchenxuan Tong demon386@gmail.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.





