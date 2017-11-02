# MatchItShiny

Keywords: *score de propension, appariement, équilibrage des distributions, effet causal, algorithme génétique, CEM, R.*

Temps d'apprentissage du package `MatchItShiny` : **court !**

L'objectif de `MatchItShiny` est de simplifier le work flow de l'évaluateur ! Facile à utiliser (sans avoir à  connaître le langage R), à partir de votre browser (chrome, Microsoft Edge, Firefox), avec quelques clics-souris vous obtenez l'estimation de l'effet causal, vous testez la condition d'équilibrage des distributions, les graphiques qui vont avec, etc. 


**1. 1st problematic**: There is no consensus on how exactly matching ought to be done and how to measure the success of the matching procedure. A wide variety of matching procedures have been proposed, and `MatchItShiny` implements many of them.


**2. 2sd problematic**: The work flow of an evaluateur 

# Usage

**Dommaine d'application**: each fields where you use method of causal inference - statistics (see for e.g Rubin 2006; Rosenbaum 2002), medecine (Christakis and Iwashyna 2003; Rubin 1997), economics  (Abadie and Imbens 2006; Dehejia and Wahba 2002, 1999), political science (Bowers and Hansen 2005; Herron and Wand 2007; Imai 2005), sociology (Morgan and Harding 2006; Diprete and Engelhardt 2004; Winship and Morgan 1999; Smith 1997) and even law (Rubin 2001).


`MatchItShiny` is an interactive application to visualise and perform impacts analysis. The interface is based on the Shiny web application framework, though can be run locally and with the user's own data.

## Comment obtenir la dernière version de `MatchItShiny` ?

```R
# Comment l'installer :
# install.packages("devtools")
library(devtools)
devtools::install_github("BejaouiSayf/MatchItShiny")
```

![Demo Install](https://github.com/BejaouiSayf/MatchItShiny/blob/master/Demo%20Install%20MatchItShiny.gif)


I'm always happy to hear about what doesn't work for you and where `MatchItShiny` get in your way (send an email to the [maintainer](bejaoui@gmail.com))


## Todo
- *Ajouter la méthode des doubles differences* 
- *Ajouter la méthode des doublesdifferences par appariement
- *iuediu* drag and drop
- Communiquer avec l'environnement R (pour les utilisateurs de R)

## A l'attention des développeurs

Please work on the develop branch, it's newer than master. the master branch is for users.

## Remerciements
shiny, matchit, matching, 

## A faire
Ajouter : 




