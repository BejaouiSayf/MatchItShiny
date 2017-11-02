# library(plotly)
library(e1071)  # Pr le skewness et le kurtosis
data(lalonde, package = "Matching")
lalondeMatching <- lalonde[, c(ncol(lalonde), 1:8, 10:11, 9)]
names(lalondeMatching)[names(lalondeMatching)=="nodegr"] <- "nodegree"
names(lalondeMatching)[names(lalondeMatching)=="hisp"] <- "hispan"
data(lalonde, package = "MatchIt")
lalondeMatchIt <- lalonde

NSW_PSID <- read.csv("C:/Users/bejao/OneDrive/AstucesR/Premiers pas/MyShinyTuto/matching_earnings.csv")

data(GerberGreenImai, package = "Matching")
GerberGreenImai <- GerberGreenImai

library(Zelig)
# library(RItools)
# library(optmatch)

function(session, input, output) {

#########################################################################
#####               Functions for sidebarPanel                      #####
#########################################################################

observe({input$data})


# switch to tabPanel "Data" when the user upload a file.
  observe({
    if (input$data == 'file')
    {updateTabsetPanel(session, "tabsetPanel", selected = "Data")}
    })  

  file = reactive(
		if(is.null(input$file)) return() 
    else read.table(file=input$file$datapath, header = input$header, sep = input$sep, stringsAsFactors = input$stringsAsFactors)
  )

  data = reactive(
  	switch(input$data
    , "lalondeMatchIt" = lalondeMatchIt
    , "lalondeMatching" = lalondeMatching
    , "NSW_PSID" = NSW_PSID
    , "GerberGreenImai" = GerberGreenImai
    # , "m.data" = m.data()
    , "file" = file()
    )
  )

  output$outcome_var = renderUI(
    selectInput(
    "Y" 
    , em(h5("Outcome of interest"))
    , choices = names(data())[-1]
    , selected = tail(names(data())[-1], 1)
    )
  )

  output$treatment_var = renderUI(
    selectInput(
    "Tr" 
    , em(h5("Treatment variable"))
    , choices = names(data())[-which(colnames(data()) %in% c(input$Y))]
    )
  )

  output$covariates = renderUI(
    selectInput(
    "X" 
    , em(h5("Move the covariates (that you don't need)"))
    , choices = names(data())[-which(colnames(data()) %in% c(input$Y, input$Tr))]
    , selected = names(data())[-which(colnames(data()) %in% c(input$Y, input$Tr))]
    , multiple = TRUE
    )
  )

  # observe({
  #   Y <- colnames(data())[-which(colnames(data()) %in% c(input$Tr))]
  #   updateSelectInput(session, "Y", choices = Y, selected = tail(Y, 1))
  #   })

  # observe({
  # 	Tr <- colnames(data())[-which(colnames(data()) %in% c(input$Y))]
  # 	updateSelectInput(session, "Tr", choices = Tr)
  # 	})

  # observe({
  # 	X <- colnames(data())[-which(colnames(data()) %in% c(input$Y, input$Tr))]
  # 	updateSelectInput(session, "X",  choices = X, selected = X)
  # 	})

  # observe({
  #   X <- colnames(data())[which(colnames(data()) %in% c(input$X))]
  #  updateSelectInput(session, "XExact",  choices = X, selected = NULL)
  #   })

  observe({
	  X <- colnames(data())[which(colnames(data()) %in% c(input$X))]
	 updateSelectInput(session, "mahvars",  choices = X, selected = NULL)
  	})

  outputOptions(output, "outcome_var", suspendWhenHidden=FALSE)
  outputOptions(output, "treatment_var", suspendWhenHidden=FALSE)
  outputOptions(output, "covariates", suspendWhenHidden=FALSE)

  observeEvent(input$help_method, {

  if (input$method == "exact")    
    {showNotification(help.method.exact.matching, type = "message", duration = 20)}

  else if (input$method == "subclass")
    {showNotification(help.method.subclassification.matching, type = "message", duration = 20)}

  else if (input$method == "full")
    {showNotification(help.method.full.matching, type = "message", duration = 20)}

  # else if (input$method == "nearest" && input$opnearest == FALSE)
  #   {showNotification(help.method.nearest_neighbor.matching, type = "message", duration = 20)}

  # else if (input$method == "optimal" && input$opnearest == FALSE)
  #   {showNotification(help.method.optimal.matching, type = "message", duration = 20)}

  else if (input$method == "cem" && input$opnearest == FALSE)
    {showNotification(help.method.cem.matching, type = "message", duration = 40)}

  else if (input$method == "genetic" && input$opnearest == FALSE)
    {showNotification(help.method.genetic.matching, type = "message", duration = 40)}



  # else if (input$method == "nearest" && input$opnearest == TRUE)
  #   {showNotification(help.method.nearest_neighbor.matching.options.all, type = "message", duration = 20)}


  # else if (input$method == "nearest" && input$opnearest == TRUE && input$caliper != 0)
    # {showNotification(help.method.nearest_neighbor.matching.option.caliper, type = "message", duration = 30)}


  # else if (input$method == "nearest" && input$subclassexact == "exact")
    # {showNotification(help.method.nearest_neighbor.matching.option.excat, type = "message", duration = 20)}

  # else if (input$method == "nearest" && input$subclassexact == "subclassification")
    # {showNotification(help.method.nearest_neighbor.matching.option.subclassification, type = "message", duration = 20)}

  else if (input$discard == "none" && input$Discard == TRUE)
    {showNotification(help.option.discard.none, type = "message", duration = 20)}

  else if (input$discard == "both" && input$Discard == TRUE)
    {showNotification(help.option.discard.both, type = "message", duration = 20)}

  else if (input$discard == "control" && input$Discard == TRUE)
    {showNotification(help.option.discard.control, type = "message", duration = 20)}

  else if (input$discard == "treat" && input$Discard == TRUE)
    {showNotification(help.option.discard.treated, type = "message", duration = 20)}
    
  }
  )

#########################################################################
#####                         Writing the model                     #####
######################################################################### 

  Model = reactive(paste(input$Tr,"~", paste(input$X, collapse = " + ")))

  # reactive(reformulate(input$X, input$Tr))

  output$Model <- renderText(Model())

  yourModel = reactive(as.formula(Model()))

  # yourModel = reactive({as.formula(sprintf('%s~%s', input$Tr, covar()))})

  output$yourModel <- renderText(yourModel())

# Q : unexpected end of input 1: ~ ^ Warning in model.matrix.default(mt, mf, contrasts) : the response appeared on the right-hand side and was dropped ?
# S : Les sites surlequel tu peux apporter ta rép (si tu la trouve) ! 
# stackoverflow.com/questions/31463118/r-shiny-unclear-error-within-lm-function-parse
# stackoverflow.com/questions/18762962/passing-variable-names-to-model-in-shiny-app
# stackoverflow.com/questions/26496694/shiny-app-error-in-console

# Une partie de la solution lorsq tu as 1pb pr parser 1character ds R
# Pb: reformulate(c( paste(sep="","X",1:5), "for", paste(sep="","X",1:5) ), quote(Y))
# Sol: deparse(quote(`for`), backtick = TRUE)
# stackoverflow.com/questions/42238675/error-in-formula-to-neuralnet

output$outcome = renderText(input$Y)

#########################################################################
#####               Functions for 7th tabPanel                      #####
######################################################################### 

naif = reactive(summary(lm(reformulate(input$Tr, input$Y), data = data())))
output$naif <- renderPrint(naif()) 


subclass = reactive({
    subclass <- input$subclass
    if(subclass == 2 && input$Subclass == FALSE || input$Subclass == FALSE || subclass == 1) {subclass <- NULL}
    else {subclass}
})
# Il te manque de faire silent lorsq le numericInput est vide

discard = reactive({
    if((input$Discard == FALSE))
    {discard <- "none"}
    else
    {discard <- input$discard}
})
# Il te manque de faire silent lorsq le discard est vide.
# Tu as essayé de le faire avec cette condition ds le if || (input$Discard == FALSE && input$discard != "control") || (input$Discard == FALSE && input$discard != "treat") || (input$Discard == FALSE && input$discard != "both")

  
m.out = reactive({

   if (input$method == "nearest" || input$method == "optimal" || input$method == "full")
    m.out <- { matchit(formula = yourModel(), data = data(), method = input$method, distance = input$distance, discard = discard(), ratio = input$ratio, replace = input$replace, caliper = input$caliper, exact = c(input$XExact), subclass = subclass(), mahvars = c(input$mahvars))
    }

    # { matchit(formula = reformulate(input$X, input$Tr), data = data(), method = input$method, distance = input$distance, discard = discard(), ratio = input$ratio, replace = input$replace, caliper = input$caliper, exact = c(input$XExact), subclass = subclass(), mahvars = c(input$mahvars))
    # }
# , verbose = TRUE    
# mahalanobis, exact, ne fournit pas de plot.

  else if (input$method == "exact")
   { matchit(formula = yourModel(), data = data(), method = "exact", verbose = TRUE)
  }      


  else if (input$method == "subclass")
    { matchit(formula = yourModel(), data = data(), method = "subclass", distance = input$algo.subclass.distance, discard = discard(), subclass = subclass(), verbose = TRUE)
  }
      
  else if (input$method == "genetic")
   { matchit(formula = yourModel(), data = data(), method = "genetic", distance = input$distance, discard = discard(), ratio = input$ratio, replace = input$replace, caliper = input$caliper, exact = c(input$XExact), verbose = TRUE)
  }      

  else if (input$method == "cem")
    { matchit(formula = yourModel(), data = data(), method = "cem", distance = input$distance, discard = discard(), ratio = input$ratio, verbose = TRUE)
  }

})


# m.data = reactive(match.data(m.out(), "control"))
# , distance ="pscore"
# alor "control" ou "pscore"


ZeligModelSpecificationDescripedAbove = reactive({as.formula(paste(input$Y, "~", paste(input$Tr, "+"), paste(input$X, collapse = "+")))})

#########################################################################
#####                     Methode manuelle                          #####

manuelle = reactive(summary(lm(reformulate(c(input$Tr, input$X), input$Y), data = m.data())))
output$manuelle = renderPrint(manuelle())  

# data  = reactive(na.omit(data()))
# L'idéal : tu dois le faire dès le début du code. Tu peux ainsi ne pas mettre rm.na = TRUE ds le code de calcul de la moy., s.d, ...
# Rq : Pr que le test de moy suivant marche, tu dois déclarer treat comme 1factor !
# C ça qui donne cette erreur contrasts can be applied only to factors with 2 or more levels

# ATT = reactive(
#   t.test(
#   m.data()[, input$Y][m.data()(as.factor[, input$Tr]) == 1]
#   , m.data()$re78[m.data()(as.factor[, input$Tr]) == 0]
#   , paired = TRUE )
#   )

# ATT = reactive(t.test(y()[tr()==1],y()[tr()==0],paired=TRUE))

# ATT = reactive(t.test(m.data1$re78[m.data1$treat==1],m.data1$re78[m.data1$treat==0],paired=TRUE))

# t.test(m.data1$re78[m.data1$treat==1],m.data1$re78[m.data1$treat==0],paired=TRUE)

# pb: contrasts can be applied only to factors with 2 or more levels

  # ties = reactive(input$ties)
  # CommonSupport = reactive(as.numeric(input$CommonSupport))
  # Weight = reactive(as.numeric(input$Weight))

  # nboots = reactive(as.numeric(input$nboots)) 

#########################################################################
#####                       Methode Matching                        #####
    
matching = reactive(
  Match(Y = data()[, input$Y], Tr = data()[, input$Tr], X = psResult()$fitted, estimand = input$estimand
      # , exact = exact(), M = ratio(), ties = ties(), replace = replace(), caliper = caliper(), CommonSupport = CommonSupport()
  # , Weight = Weight()
  )
)

output$matching = renderPrint(summary(matching()))


# methode Matching combiné avec matchit 
  # rr = reactive(
    # Match(Y = m.data()[, input$Y], Tr = m.data()[, input$Tr], X = m.data()[, "distance"], estimand = input$estimand
      # m.out()$distance
      # , exact = exact(), M = ratio(), ties = ties(), replace = replace(), caliper = caliper(), CommonSupport = CommonSupport() , Weight = Weight()
      # )
  # )

  # output$mb = renderPrint(mb())

  mb = reactive(MatchBalance(yourModel(), data=data(), match.out = rr(), nboots = nboots()))

  Y = reactive({input$Y[[2]]})

#########################################################################
#####              Methode Zelig (z.out, x.out, s.out)              #####
    
z.out = reactive({zelig(formula = ZeligModelSpecificationDescripedAbove(), data = m.out(), model = "ls", cite = FALSE)})

# output$z.out = renderPrint(summary(z.out()))

x.out = reactive({setx(z.out(), treat = 0)})
x1.out = reactive({setx(z.out(), treat = 1)})

output$x.out = renderPrint(x.out())  
output$x1.out = renderPrint(x1.out())  
      
s.out = reactive({sim(z.out(), x = x.out(), x1 = x1.out())})
output$s.out <- renderPrint(summary(s.out()))


# zelig.att = reactive(Zelig::ATT(m.out(), model = "ls", data = m.data()))
# il existe 1commande ATT ds le pkg Zelig

#####              Methode Zelig (z.out, x.out, s.out)              #####
                          # Methode robuste 

z.out.robuste = reactive({zelig(formula = ZeligModelSpecificationDescripedAbove(), data = match.data(m.out(), "control"), model = "ls", cite = FALSE)})
output$z.out.robuste <- renderPrint(summary(z.out.robuste()))

x1.out.robuste = reactive({setx(z.out.robuste(), data = match.data(m.out(), "treat"), cond = TRUE )})
# output$x1.out.robuste <- renderPrint(summary(x1.out.robuste()))

# s.out.robuste = reactive(sim(z.out.robuste(), x1 = x1.out.robuste()))
# output$s.out.robuste <- renderPrint(summary(s.out.robuste()))



# x.out = reactive({setx(z.out(), data = match.data(m.out(), "treat"), cond = TRUE)})

# x.out = reactive({setx(zelig(formula = ZeligModelSpecificationDescripedAbove(), data = match.data(m.out(), "control"), model = "ls" ), data = match.data(m.out(), "treat"), cond = TRUE)})


# output$graph <- renderPlot({
#   validate(
#     need(input$method != "exact" && input$distance != "mahalanobis", paste("\n", "\n", "\n", "\n", "No plots generated (not appropriate).", "\n", "\n", "Please see the", "numerical output in the next tabpanel to check balance.")))
#   plot(m.out(), type = type() )
# })





  # output$matchit_sample_sizes = renderPrint(print(m.out()))

  # output$m.out <- renderPrint(
    # if (is.null(data())) return ()
    # else m.out()
  # )
 

#########################################################################
#####               Functions for 6th Balancing condition           #####
#########################################################################

observeEvent(input$help_percent_balance_improvement, {
  showNotification(
    div("-  The percent balance improvement is defined as 100((|a| − |b|)/|a|), where a is the balance before and b is the balance after matching)."
, br()
    , "- Value near of 100 indicate better balancing."
, br()
, br()
    , "- “Mean Diff” is the difference in means between the groups (treated and control groups)."
, br()
, br()
    , "- Be careful, the widely used procedure of doing t-tests of the difference in means is highly misleading and should never be used to assess balance; see Imai et al. (2008)."
, br()
, br()
    , "- “eQQ” give the median, mean, and maximum distance between the two empirical quantile functions (treated and control groups)."
, br()
, br()
    , "-  Values greater than 0 indicate deviations between the groups in some part of the empirical distributions.")
  , type = "message"
  , duration = 30
  )
})

observeEvent(input$help_goal_balance, {
  showNotification(
    div("- The goal is to create a data set that looks closer to one that would result from a perfectly blocked (and possibly randomized) experiment."
, br()
       , "- So, we need the distribution of covariates to be the same within the matched treated and control groups."
, br()
, br()
       , "- N.B.: Balance diagnostics should be performed on all variables in X, even if some are excluded from one of the matching procedures.")
      , type = "message"
      , duration = 20)
})

observeEvent(input$help_all_matched_balance, {
  showNotification(
    div("- It gives the balance between the treated and control groups in the full (original) data set, and then in the matched data set."
, br()
, br()
       , "- If the matching worked well, the measures of balance should be smaller in the matched data set (smaller values of the measures indicate better balance)."
, br()
, br()
       , "- “Means Treated” and “Means Control” show the weighted means in the treated and control groups."
, br()
, br()
       , "- “SD Control” is the standard deviation calculated in the control group (where applicable)."
, br()
       , "- N.B.: definitions of “Mean Diff” and “eQQ” are given (see table of %balance improvement).")
      , type = "message"
      , duration = 30)
})

  output$matchit_summary_percent_balance_improvement = renderPrint(summary(m.out())$reduction)

  output$matchit_summary_sample_sizes = renderPrint(summary(m.out())$nn)

m.out.plot <- reactive(plot(m.out(), type = input$type))


  # output$graph_balance <- renderPlot({plotly(m.out.plot()
  output$graph_balance <- renderPlot({m.out.plot()
    # validate(
      # need(input$method != "exact" && input$distance != "mahalanobis", paste("\n", "\n", "\n", "\n", "\n", "\n", "\n", "\n", "No plots generated (not appropriate).", "\n", "\n", "If you want, you can see the summary of balance for all data", "\n", "and the summary of balance of the matched data")))

      
  })


  matchit_summary_balance_for_all_data = reactive(
  if(input$matchit_summary_balance_for_all_data == FALSE)
     {return()}
   else 
   {summary(m.out())$sum.all}
)

  matchit_summary_balance_for_matched_data = reactive(
  if(input$matchit_summary_balance_for_matched_data == FALSE)
     {return()}
   else 
   {summary(m.out())$sum.matched}
)

  output$matchit_summary_balance_for_all_data = renderPrint(matchit_summary_balance_for_all_data())

  output$matchit_summary_balance_for_matched_data = renderPrint(matchit_summary_balance_for_matched_data())



#########################################################################
#####               Functions for 5th tabPanel                      #####
######################################################################### 

output$Values = renderUI(
shiny::radioButtons(
"values"
, "Which result do you want to obtain?"
, choices = names(m.out())

[-which(names(m.out()) %in% c(
#   "X"
   "call"  # tu n'as pas besoin
  , "formula" # tu n'as pas besoin
#   , "treat"
  , "nn"
#   , "discarded"
)
)
]
, selected = names(m.out())[-which(names(m.out()) %in% c("X", "call", "formula", "treat", "nn", "discarded"))][3]

, inline = TRUE
)
)
output$results0dim = renderPrint(length((m.out()[[grep(input$values, names(m.out()))]])))
output$results0 = renderPrint((m.out()[[grep(input$values, names(m.out()))]]))
output$results = renderPrint(summary(m.out()[[grep(input$values, names(m.out()))]]))
output$resultsplot = renderPlot(plot(m.out()[[grep(input$values, names(m.out()))]]))

output$odds.ratios = renderPrint(exp(coef(m.out()$model)))


# oldpar <- par(oma=c(0,0,3,0), mfrow=c(2,2))
# plot(GLM.1)
# par(oldpar)
# crPlots(GLM.1, span=0.5)
# avPlots(GLM.1, id.method="identify", id.n=2)

# MatriceConfusion = reactive(table(m.out()$distance > 0.5, data()[, input$Tr]))
output$MatriceConfusion = renderPrint(table(m.out()$distance > 0.5, data()[, input$Tr]))
# output$MatriceConfusion = renderPrint(MatriceConfusion())

#########################################################################
#####               Functions for 1st tabPanel "Data"               #####
#########################################################################

.df = reactive({
within(data(), {
distance <- fitted(m.out()$model)
})
})

  output$data = renderTable (
    .df()
    , rownames = TRUE
    	  # , options = list(
    	  	# "orderClasses" = TRUE
    	    # , "responsive" = TRUE
    	    # , "pageLength" = 10)
  )
output$dim = renderText(paste("DIM:", nrow(.df()), "obs", "x", ncol(.df()), "variables."))

# Rq : Tu peux combiner tab1 et tab4 (1tab pr afficher les ≠ BD : original, avec la var distance, m.data "all, treat, control, unmatched") !
# mais tu pense que ce n'est pas 1bonne idée parcq il y'aura trop d'options à cocher.
# Q : Cmnt tu peux faire apparaître NSW (les row.names) ?
# S : Il faut que tu fasse 1fonc avec if else qui telecharge la BD avec ou sans les row.names ! 


#########################################################################
#####           Functions for 2sd tabPanel Summary of dataset       #####
#########################################################################

# Ce que tu peux faire pr que soit + joli, des conditions sur le fait que la var est de type quali ou quanti pr adapté la sortie de summary.
# 1 menu déroulant pr choisir les vars sur lesquelles on fait le summary.
# 1 sortie graphique.

	output$VARS = renderUI(
    selectInput(
	    "var"
	    , "Select vars"
	    , choices = colnames(data())
	    # , selected = colnames(data())
	    # , selected = colnames(data())[c(ncol(data())-1, ncol(data()))]
	    , selected = c(colnames(data())[1], tail(colnames(data()), 2))
	    , multiple = TRUE
    )
	)

  var = reactive(as.numeric(data()[, input$var]))
  
  output$VAR = renderUI(
    selectInput(
      "var_graph"   
      , "Graphs"
      # , choices = colnames(data())
      , choices = NULL
      , selected = NULL
    )
  )

  observe({
    # var_graph <- input$var[length(input$var)]
    var_graph <- tail(input$var, 1)
    updateSelectInput(session, "var_graph", choices = var_graph)
    })



	data.selec = reactive({data()[, input$var]})

	data.selec.summary = reactive({

	  if(length(input$var) == 1) 

	    df <- data.frame(
	      VAR = input$var
	      , Min. = min(var(), na.rm=TRUE)
	      , Qu.1 = stats::quantile(var(), prob = 0.25, na.rm=TRUE)
	      , Med. = stats::median(var(), na.rm=TRUE)
	      , Mean. = mean(var(), na.rm=TRUE)
	      , sd. = stats::sd(var(), na.rm = TRUE)
	      , Qu.3 = stats::quantile(var(), prob = 0.75, na.rm=TRUE)
	      , Max. = max(var(), na.rm = TRUE)
	      , Miss. = paste(sum(is.na(var())), paste0("(", round(sum(is.na(var()))/nrow(data()), 2), "%", ")"))
	      , N. = nrow(data())
	      , Skew. = e1071::skewness(var(), na.rm = TRUE, type = 2)
	      , Kurt. = e1071::kurtosis(var(), na.rm = TRUE, type = 2)
	    )

      else
	      df <- data.frame(
          VAR = input$var
	        , Min. = sapply((data.selec()), min, na.rm = TRUE)
	        , Qu.1 = sapply((data.selec()), function(x)
	          stats::quantile((data.selec()), prob = 0.25, na.rm=TRUE))
	        , Med. = sapply((data.selec()), stats::median, na.rm = TRUE)
	         , Mean. = sapply((data.selec()), mean, na.rm = TRUE, simplify = TRUE)
	        , sd. = sapply((data.selec()), sd, na.rm = TRUE, simplify = TRUE)
	        , Qu.3 = sapply((data.selec()), function(x)
	          quantile((data.selec()), prob = 0.75, na.rm=TRUE, simplify = TRUE))
	        , Max. = sapply((data.selec()), max, na.rm = TRUE, simplify = TRUE)
	        # , Miss. = sapply((data.selec()), function(x) sum(is.na(x)))
	        , Miss. = sapply(data.selec(), function(x) paste(sum(is.na(x)), paste0("(", round(sum(is.na(x))/nrow(data()), 2), "%", ")")))
	        , N. = nrow((data.selec()))
	        , Skew. = sapply((data.selec()), function(x) skewness(x, na.rm = TRUE, type = 2))
	        , Kurt. = sapply((data.selec()), function(x) kurtosis(x, na.rm = TRUE, type = 2))
	      )
	    
	  data.selec.summary <- rapply(object = df, f = round, classes = "numeric", how = "replace", digits = 4) 
})


# Cmnt tu peux condenser l'affichage de renderDataTable(data.selec.summary() pr que les vars de la BD pr que ça tienne sur 1page ? 
# R :  ... .
	output$data.selec.summary = renderDataTable(data.selec.summary()
    , options = list(
      "orderClasses" = TRUE
      , "responsive" = TRUE
      , "pageLength" = 10)
  )

# Q : Tu dois testé si le download_summary donne bien 1BD avec read.table avec R ? 
# R :  ... .
  output$download_summary = downloadHandler(
    filename = function() 
    paste("summaryOfDataset", "csv", sep=".")
    , content = function(file) 
    # write.table(data.selec.summary(), col.names = FALSE, sep = ",", qmethod = "double", file)
    write.csv(data.selec.summary(), file)
  )

# Q : Cmnt tu peux écrire le text suivant après le boutton download ?
# R : Tu as essayer mais ça n'as pas marché ... 
  download_summary_text = reactive(
    if(is.null(data())) {return()} 
    else
    {paste("You can integrate the numeric summary directly in Latex")}
  )
  renderPrint({download_summary_text()})


  data.selec.graph = reactive({
      graphics::par(mfrow = c(1, 2))
      graphics::boxplot(data()[, input$var_graph])
      graphics::hist(data()[, input$var_graph], main = paste("histogram of", input$var_graph), xlab = input$var_graph)
  })

  output$data.selec.graph <- renderPlot(data.selec.graph())

	# output$QSTAT = renderUI({
	#   radioButtons(
	# 		"qstat"
	# 		, "Witch type of summary output do you want ? "
	# 		, choices = c(
	# 			"All variables"
	# 			, "Select"
	# 			, "by group (treated vs. control)"
	# 			, "simple"
	# 		)
	# 		, inline = TRUE
	# 	)
	# })

  # , h5(align = "center", strong("Table of min, max, missing and unique values by variables:"))
 
#########################################################################
#####   Functions for 3rd tabPanel comparaison treat vs. control    #####
#########################################################################

  output$var_single_tab3 = renderUI(
    selectInput(
      "var_single_tab3"
      , "Select"
      , choices = colnames(data())
      , selected = colnames(data())[1]
    )
  )
  
  output$var_multi_tab3 = renderUI(
    selectInput(
      "var_multi_tab3"
      , "Select"
      , choices = NULL
      # , selected = colnames(data())
      # , selected = colnames(data())[c(ncol(data())-1, ncol(data()))]
      # , selected = colnames(data())[c(ncol(data()))]
      , multiple = TRUE
      , selectize = TRUE
    )
  )

  observe({
    var_multi_tab3 <- colnames(data())[-which(colnames(data()) %in% c(input$var_single_tab3))]
    updateSelectInput(session, "var_multi_tab3", choices = var_multi_tab3, selected = head(var_multi_tab3, 3))
    })

  summaryByTreat = reactive(
    # by(data()[, c(input$var_multi_tab3)], list(as.name(input$var_single_tab3[[1]]) = data()[, input$var_single_tab3]), summary)
# Q : Cmnt écrire le nom de la var au lieu de "modality" ?
# R : C 1 liste input$var_single_tab3, où il faut que tu accede à  son 1er element... . 
    by(data()[, c(input$var_multi_tab3)], list("modality" = data()[, input$var_single_tab3]), summary)
  )

    # by(data()[, c(input$X, input$Y)], list(modality = data()[, input$Tr]), summary)

  # summaryByTreatDF = reactive(
  #     data.frame(
  #       VAR = input$var_single_tab3
        # , Min. = min((var()), na.rm=TRUE)
        # , Qu.1 = stats::quantile((var()), prob = 0.25, na.rm=TRUE)
        # , Med. = stats::median((var()), na.rm=TRUE)
        # , Mean. = mean((var()), na.rm=TRUE)
        # , sd. = stats::sd((var()), na.rm = TRUE)
        # , Qu.3 = stats::quantile((var()), prob = 0.75, na.rm=TRUE)
        # , Max. = max((var()), na.rm = TRUE)
        # , Miss. = paste(sum(is.na(var())), paste0("(", round(sum(is.na(var()))/nrow(data()), 2), "%", ")"))
        # , N. = nrow(data())
        # , Skew. = e1071::skewness((var()), na.rm = TRUE, type = 2)
        # , Kurt. = e1071::kurtosis((var()), na.rm = TRUE, type = 2)
      # )
  # )



# su_re78age <- by(lalonde[, c("re78", "age")], list(treat = lalonde$treat), summary)
 # class(su_re78age)

  output$summaryByTreat=renderPrint(summaryByTreat())


  output$download_summaryByTreat=downloadHandler(
    filename = function()
    paste("summaryBy", Sys.time(), "txt", sep=".")
    , content = function(file) 
    write.table(summaryByTreat(), file)
    )
  # Tu as 1pb : tu n'arrive pas à écrire le filename correctement. Il manque l'extension (txt, csv)
  # Tu as 1pb : tu n'arrive pas à telecharger la sortie. Je pense que write table n'est pas la bonne sortie.


#########################################################################
#####           Functions for 4th tabPanel matchet dataset          #####
#########################################################################

y = reactive({
  y <- as.data.frame(cbind(data()[, c(input$Y)]))
  names(y) <- c(input$Y)
  row.names(y) <- row.names(data())
})

# lalonde[order(row.names(lalonde))]
# lalonde[order("rownames")]
# head(rownames)

# lalonde[order(lalonde$re78)]
# y <- as.data.frame(lalonde$re78, stringsAsFactors = FALSE)
# re78 <- as.data.frame(allonde$re78, stringsAsFactors = FALSE)
# names(y) <- "re78"
# row.names(y) <- row.names(lalonde)





## Return the matched data 
m.data = reactive({
  if (input$m.data == "full")
{  
  m.data <- merge(as.data.frame(m.out()$match.matrix), as.data.frame(m.out()$X), y(), by = "row.names", all = TRUE)
  # rownames(m.data) <- m.data$Row.names
  # m.data$Row.names <- NULL
  # names(m.data) <-  make.names(names(m.data))
}
  else if (input$m.data == "unmatched") 
  {data()[!row.names(data())%in%row.names(match.data(m.out())),]}
  
  else {match.data(m.out(), group = input$m.data)[ , c(ncol(match.data(m.out())):(ncol(data())+1), 1:ncol(data()))] }
})  


# Show the generated columns at the first position:
# weights, subclasses, or the distance measure
output$m.data = renderDataTable(
  {m.data()}
    , options = list("orderClasses" = TRUE
    , "responsive" = TRUE
    , "pageLength" = 10)
  )

# MergedDataset <- merge(X, match.matrix, 
#   all=TRUE, by="row.names")
# rownames(MergedDataset) <- 
#   MergedDataset$Row.names
# MergedDataset$Row.names <- NULL
# names(MergedDataset) <- 
#   make.names(names(MergedDataset))


output$dim.m.data = renderText(paste("DIM:", nrow(m.data()), "obs", "x", ncol(m.data()), "variables."))



output$download.m.data = downloadHandler(
  	filename = function() 
  	paste(input$m.data, "csv", sep=".")
  	, content = function(file)
    write.table(m.data(), col.names = TRUE, sep = ",", qmethod = "double", file)
)

  # code <- function() {
  # 	Tr <- input$Tr
  # 	covar <- input$X
  # 	data <- data()

  # }


    ### Bouton pour quitter l'application
    ### Recuperation parametres
    observe({
      if(input$Quit==0){
      }
      else{
        isolate({
          stopApp(returnValue=valeuretour())
        })
      }
    })

}
