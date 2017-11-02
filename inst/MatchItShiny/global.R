# Override R's tendency to use scientific notation
options("scipen" = 100, "digits" = 4)


help.method.exact.matching = div(div(align = "center", strong("Exact Matching")), br(), div(align = "justify", "- The simplest version of matching is exact. This technique matches each treated unit to all possible control units with exactly the same values on all the covariates, forming subclasses such that within each subclass all units (treatment and control) have the same covariate values.", br(), br(), "N.B.: Exact restrictions on a subset of covariates can also be specified in Nearest Neighbor Matching.", br(), br(), "- Do you want to perform it? It's implemented (see Nearest Neighbor Matching options)")
  )

help.method.subclassification.matching = div(div(align = "center", strong("Subclassification Matching")), br(), div(align = "justify", "- When there are many covariates (or some covariates can take a large number of values), finding sufficient exact matches will often be impossible.", br(), br(), "- The goal of subclassification is to form subclasses, such that in each the distribution (rather than the exact values) of covariates for the treated and control groups are as similar as possible."
    ))

help.method.full.matching = div(div(align = "center", strong("Full Matching")), br(), div(align = "justify", "- Full matching is a particular type of subclassification that forms the subclasses in an optimal way (Rosenbaum 2002; Hansen 2004).", br(), br(), "- A fully matched sample is composed of matched sets, where each matched set contains one treated unit and one or more controls (or one control unit and one or more treated units)."
)	)


help.method.optimal.matching = div(div(align = "center", strong("Optimal Matching")), br(), div(align = "justify", "- The default nearest neighbor matching method in MatchIt is “greedy” matching, where the closest control match for each treated unit is chosen one at a time, without trying to minimize a global distance measure.", br(), br(), "- In contrast, “optimal” matching finds the matched samples with the smallest average absolute distance across all the matched pairs.", br(), br(), "-  Gu and Rosenbaum (1993) find that greedy and optimal matching approaches generally choose the same sets of controls for the overall matched samples, but optimal matching does a better job of minimizing the distance within each pair.", br(), br(), "- In addition, optimal matching can be helpful when there are not many appropriate control matches for the treated units."
    ))

help.method.cem.matching = div(div(align = "center", strong("CEM Matching")), br(), div(align = "justify", "- Coarsened Exact Matching (CEM) is a Monotonoic Imbalance Bounding (MIB) matching method which means that the balance between the treated and control groups is chosen by the user ex ante rather than discovered through the usual laborious process of checking after the fact and repeatedly reestimating, and so that adjusting the imbalance on one variable has no effect on the maximum imbalance of any other.", br(), br(), "- CEM also strictly bounds through ex ante user choice both the degree of model dependence and the average treatment effect estimation error, eliminates the need for a separate procedure to restrict data to common empirical support, meets the congruence principle, is robust to measurement error, works well with multiple imputation methods for missing data, and is extremely fast computationally even with very large data sets.", br(), br(), "- CEM also works well for multicategory treatments, determining blocks in experimental designs, and evaluating extreme counterfactuals.")
	)

help.method.genetic.matching = div(div(align = "center", strong("Genetic Matching")), br(), div(align = "justify", "- Genetic matching automates the process of finding a good matching solution (Diamond and Sekhon 2005).", br(), br(), "- The idea is to use a genetic search algorithm to find a set of weights for each covariate such that the a version of optimal balance is achieved after matching.", br(), br(), "- As currently implemented, matching is done with replacement using the matching method of Abadie and Imbens (2007) and balance is determined by two univariate tests, paired t-tests for dichotomous variables and a Kolmogorov-Smirnov test for multinomial and continuous variables, but these options can be changed.")
)		



help.method.nearest_neighbor.matching.options.all = div("Wich help do you want to obtain? You are probably looking for the help of Nearest Neighbor matching options! To obtain that, please modify the value of the desired oprion and hit after the 'help' boutton")

help.method.nearest_neighbor.matching = div(div(align = "center", strong("Nearest Neighbor Matching")), div(align = "center", "(Rubin, 1973a)"), br(), div(align = "justify", "- Nearest neighbor algorithm selects the n (default=1) best control matches for each individual in the treatment group.", br(), br(), "- When you hit 'Customize options' boutton, you will find several options: replacement, caliper,... ."))

help.method.nearest_neighbor.matching.option.caliper = div(div(align = "center", strong("Caliper matching")), div(align = "center", "(Cochran and Rubin, 1973)"), br(), div(align = "justify", "- A variation of nearest neighbor matching that attempts to avoid bad matches (those for which Pj is far from Pi) by imposing a tolerance on the maximum distance ||Pi −Pj|| allowed.", br(), br(), "- Treated persons for whom no matches can be found excluded (way of imposing a common support condition).", br(), br(), "- Difficult to know a priori what choice for the tolerance level is reasonable."))


help.method.nearest_neighbor.matching.option.excat = div(div(align = "center", strong("Exact restrictions within nearest neighbor algorithm")), br(), div(align = "justify", "- Exact restrictions on a subset of covariates can also be specified in nearest neighbor matching", br(), br(), "- If exact is specified, only matches that exactly match on the covariates in exact will be allowed.", br(), br(), "- Within the matches that match on the variables in exact, the match with the closest distance measure will be chosen."))

help.method.nearest_neighbor.matching.option.subclassification = div(div(align = "center", strong("Subclassification option within nearest neighbor algorithm")), br(), div(align = "justify", "- If a subclass is specified within nearest neighbor matching, the matched units will be placed into subclasses after the nearest neighbor matching is completed.", br(), br(), "- i.e: You select matches using nearest neighbor matching, but after the nearest neighbor matches are chosen it places them into subclasses, and adds a variable to the output object indicating subclass membership."))

help.option.discard.none = div(div(align = "center", strong("Without discarding units")), br(), div(align = "justify", "- no units will be discarded before matching. Use this option when the units to be matched are substantially similar, such as in the case of matching treatment and control units from a field experiment that was close to (but not fully) randomized (e.g., Imai 2005), when caliper matching will restrict the donor pool, or when you do not wish to change the quantity of interest and the parametric methods to be used post-matching can be trusted to extrapolate."
))

help.option.discard.both = div(div(align = "center", strong("Discarding treated and control")), br(), div(align = "justify", "- all units (treated and control) that are outside the support of the distance measure will be discarded."
))

help.option.discard.control = div(div(align = "center", strong("Discarding only control units")), br(), div(align = "justify", "- Only control units that are not within the convex hull of the treated units will be discarded."
))

help.option.discard.treated = div(div(align = "center", strong("Discarding only treated units")), br(), div(align = "justify", "-  Only treated units outside the support of the distance measure of the control units will be discarded. Use this option when the average treatment effect on the control units is of most interest and when unwilling to discard control units."
))


