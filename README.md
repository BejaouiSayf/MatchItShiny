# MatchItShiny

Keywords: *propensity score matching, multivariate matching, genetic optimization, causal inference, R.*

`MatchItShiny` is an interactive application to visualise and perform impacts analysis. The interface is based on the Shiny web application framework, though can be run locally and with the user's own data.

The package is working fine. I'm always happy to hear about what doesn't work for you and where `MatchItShiny` get in your way (send an email to the [maintainer](bejaoui@gmail.com))

**Fields**: each fields where you use method of causal inference - statistics (see for e.g Rubin 2006; Rosenbaum 2002), medecine (Christakis and Iwashyna 2003; Rubin 1997), economics  (Abadie and Imbens 2006; Dehejia and Wahba 2002, 1999), political science (Bowers and Hansen 2005; Herron and Wand 2007; Imai 2005), sociology (Morgan and Harding 2006; Diprete and Engelhardt 2004; Winship and Morgan 1999; Smith 1997) and even law (Rubin 2001).


## Updating to the latest version of `MatchItShiny`

To install it:  
**First step: you need to install devtools**  
```R
install.packages("devtools")
library(devtools)
```
![Demo Install devtools R package](https://user-images.githubusercontent.com/19627220/45932929-7daedc00-bf84-11e8-946d-20fa0e6410bd.gif)  
<br>
<br>
**Second step: install MatchItShiny**  
```R
devtools::install_github("BejaouiSayf/MatchItShiny")
```
![Demo Install MatchItShiny](https://user-images.githubusercontent.com/19627220/45933170-daf85c80-bf87-11e8-8843-f6cf3d16da69.gif)
<br>
<br>
<br>
**Third step: lanch MatchItShiny** 
```R
MatchItShiny::MatchItShiny()
```
![Demo Launch MatchItShiny](https://user-images.githubusercontent.com/19627220/45975326-3e47c480-c044-11e8-9079-e650a3b9a72f.gif)
