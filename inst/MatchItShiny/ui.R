# Tu dois mettre ton shiny sur le site de MIT https://opensource.org/licenses/MIT

# gettext("Smart Interactive Evaluation Impacts App")), style = "color:#6E6E6E", align = "center")
# S : Exemple de titre pr l'app' ! 

data = c(
	 "Lalonde [1986]" = "lalondeMatchIt"
	, "Lalonde Matching" = "lalondeMatching"
	,  "Upload your own..." = "file"
	, "Green and Imai [2005]" = "GerberGreenImai"
	, "Dehejia and Wahba [1999]" = "NSW_PSID"
)

sep = c(
	Comma = ','
 , Semicolon = ';'
 , Tab = '\t'
 , Space = ''
)

estimand = c(
	"ATT (Sample Average Treatment effect for the Treated)" = "ATT"
	, "ATE (Sample Average Treatment Effect)" = "ATE"
	, "ATC (Sample Average Treatment Effect for the Controls)" = "ATC"
)

procedure = c(
 "Propensity score matching (PSM), see for e.g Rosenbaum and Rubin (1983) " = "ps"
	, "Exact Matching" = "exact"
	, "Multivariate matching based on covariates" = "covarMatch"
	# esk covarMatch = full Matching (Article Matching p5.)
	, "Optimal full matching, see for e.g Hansen (2004); Hansen and Klopfer (2006); Rosenbaum (1989, 1991)" = "full"
	# Je pense que l'optimal full matching est 1 variante de full matching. 
	, "Multivariate matching based on Mahalanobis distance, see for e.g Cochran and Rubin (1973); Rubin [1979, 1980])" = "mahalanobis"
	, "Combination of Mahalanobis and PSM, see for e.g Rubin (2001); Rosenbaum and Rubin (1985))" = "mahalanobisPSM"
	, "Genetic algorithm, see for e.g Diamond and Sekhon (2005) and Sekhon and Grieve (2011)" = "GenMatch"
	, "CE Matching, see for e.g mettre les ref " = "cem"
	, "Inverse variance" = "inversevarMatch"
)

distance = c(
	"Mahalanobis distance" = "mahalanobis"
	, "Logit (default)" = "logit"
	, "Probit" = "probit"
	, "Linear Logit" = "linear.logit"
	, "Linear Probit" = "linear.probit"
	, "log" = "log"
	, "Linear log" = "linear.log"
	, "Complementary log-log" = "cloglog"
	, "Linear Complementary log-log" = "linear.cloglog"
	, "Cauchit" = "cauchit"
	, "Linear Cauchit" = "linearcauchit" 
)

selectInput.distance.label <- em(h5("Select the model to estimate the propensity score or use Mahalanobis distance"))

selectInput.algo.subclass.distance = selectInput(
	"algo.subclass.distance"
	, selectInput.distance.label	
	, 	choices = distance
	, 	selected = "logit"
)

selectInput.distance = selectInput(
	"distance"
	, 	selectInput.distance.label
	, 	choices = distance
	, 	selected = "logit"
)

method = c(
	"Exact Matching" = "exact"
	, "Subclassification" = "subclass"
	, "Nearest neighbor(s) [default: KNN = 1]" = "nearest"
	, "Optimal Matching" = "optimal"
	, "Full Matching" = "full"
	, "Genetic Matching" = "genetic"
	, "Coarsened Exact Matching" = "cem"
)

Weight = c("1" = 1, "2" = 2, "3" = 3)

discard = c(
	  # "Without discarding" = "none"
	# ,   "Hull both" = "hull.both"
	# ,   "Hull Control" = "hull.control"
	   "Control" = "control"
	# ,   "Hull treat" = "hull.treat"
	,   "Treat" = "treat"
	,   "Both" = "both"
)


numericInput.subclass = numericInput("subclass", em(h5("How many subclass (min = 2)?")), min = 2, value = 2)

numericInput.algo.subclass.subclass = numericInput("subclassrestriction", em(h5("How many subclass (default = 6, min = 2)?")), min = 2, value = 6)



fluidPage(titlePanel("eval")

, sidebarLayout(
sidebarPanel( 

wellPanel(
div(align = "center", selectInput(
"data"
, ("Choose a dataset or upload your own")
, choices = data
)

, conditionalPanel(
tags$hr()
, condition = "input.data == 'file'"
, fileInput(
"file"
, "Choose your file"
)
, tags$hr()
, checkboxInput(
"header"
, "Header"
, TRUE
)
, checkboxInput(
"SEP"
, "Separator (tab, space,..., comma = default)"
, FALSE
)
, conditionalPanel(
condition="input.SEP==true"
, shiny::radioButtons(
"sep"
, ""
, choices = sep
, inline = TRUE
)
)
, checkboxInput(
"stringsAsFactors"
, "Strings as factors"
, FALSE
)        
)

)
# Tu peux faire qq chose d'automatic qui detecte le type de fichier et telecharge la lib adéquate (foreign) pr 1fichier Stata, SAS...
# Sinon, tu peux obliger le User de convertir son fichier en csv pr qu'il soit exploitable
# Tu dois faire en sorte que l'app shiny puisse lire les fichiers ds l'environnement globale de R.
				
, wellPanel(
div(align = "center", checkboxInput("evalparam", strong("Show evaluation parameters"), FALSE))  # div ici est obligatoire
, conditionalPanel(
condition="input.evalparam==true"

, wellPanel(
div(align = "center", checkboxInput("varselec", "Modify variables selection", FALSE)
, conditionalPanel(
condition = "input.varselec == true"
, br()
, fluidRow(column(6
, uiOutput("outcome_var"))
, column(6
, uiOutput("treatment_var"))
, uiOutput("covariates")


# , selectInput(
# "Tr" 
# , em(h5("Treatment variable"))
# , choices = 
# )))

# , selectInput(
# "X" 
# , em(h5("Move the covariates (that you don't need)"))
# , choices = NULL  
# , multiple = TRUE
# , selectize = TRUE
)
)
)
)



, wellPanel(
div(align = "center", checkboxInput("Estimand", "Select the quantity of interest (ATT = default)", FALSE) # div ici est obligatoire
, conditionalPanel(
condition="input.Estimand==true"
, selectInput(
"estimand"
, ""
, choices = estimand
))))


, wellPanel(
div(align = "center", checkboxInput("otheralgo", "Perform other algorithms (PSM = default)", FALSE)

, conditionalPanel(
condition="input.otheralgo==true"

, selectInput(
"method"
, ""
, choices = method
, selected = "nearest"
)


# Options for sublassification method
, conditionalPanel(
condition = "input.method == 'subclass'"
, br()
	, checkboxInput(
				"opsubclass"
				, em("Customize options")
				, FALSE
	)
, br()

, conditionalPanel(condition = "input.opsubclass == true"
, selectInput.algo.subclass.distance
, numericInput.algo.subclass.subclass

# , numericInput("subclass.subclass", em(h5("How many subclass?")), min = 2, value = 6)
)

# Il te manque de faire uploader un vecteur compris entre 0 et 1 pr le calcul des subclass
# either a scalar specifying the number of subclasses, or a vector of probabilities
# bounded between 0 and 1, which create quantiles of the distance measure using
# the units in the group specified by sub.by (default = subclass = 6).

# , tu ne va pas faire sub.by():critere qui indique le nbre de treat, de control ou all.
)


# Options for nearest neighbor method			

, conditionalPanel(
# condition = "input.method != ''"
condition = "input.method != 'subclass'"

 , checkboxInput(
	"opnearest"
	, em("Customize options")
	, FALSE
)

, conditionalPanel(condition = "input.opnearest == true"
# , hr()			

, selectInput.distance
, fluidRow(column(7
, numericInput("ratio"
, em(h5("How many control units to match to each treated unit?"))
, value = 1, min = 1
))
, column(5
, numericInput(
"caliper"
, 	em(h5("Caliper (example: 0.25)"))
, 	value = 0, min = 0
))
)

, fluidRow(
div(align = "left", 
	column(2
, checkboxInput(
"replace"
, em("Replacement?")
, FALSE
)
)
)
, div(align = "right", column(10
, checkboxInput(
"Discard"
, em("Discard units?")
, FALSE
)
)
)
)

, conditionalPanel(
condition = "input.Discard == true"
, paste("From:")
, shiny::radioButtons(
"discard"
, ""
, choices = discard
, selected = character(0)
, inline = TRUE
)
)			

, hr() 

, checkboxInput(
"moreop"
, em("See additional options?")
, FALSE
)

, conditionalPanel(
condition="input.moreop==true"

, br()

, checkboxInput(
"Subclass"
, "Do you want to perform Subclassifi-cation restriction?"
, FALSE
)

, conditionalPanel(
condition="input.Subclass==true"
, numericInput.subclass
)

, checkboxInput(
"Exact"
,  "Do you want to perform Exact restriction?"
, FALSE
)
, conditionalPanel(
condition="input.Exact==true"
, selectInput(
"XExact" 
, em(h5("Please select variable(s) on which you want to perform exact matching"))
, choices = NULL
, multiple = TRUE
)
)



, br()					 												
, checkboxInput(
"caliperop"
, "Do you want to perform Mahalanobis-metric matching within each caliper?"
, FALSE
)
, conditionalPanel(
condition = "input.caliperop == true"
, selectInput(
"mahvars"
, em(h5("Please select variable(s) on which you want to perform Mahalanobis-metric"))
, choices = NULL
, multiple = TRUE
)
)

)
# ) 
# )
)
)

			, conditionalPanel(
			  	condition = "input.method == 'GenMatch'"

				  	, checkboxInput(
			  			"GenMatchWithPS"
			  			, 	"The GenMatch is improved when a propensity score is incorporated. Hit if you want to add ps to the covariates."
				  	)
					, checkboxInput(
	  					"parallelize"
	  					, "Do you want to speed the process by parallelizing the Genetic algorithm. You can make use the multiple CPUs or a cluster of computers"
	  				)
		  	)
, hr()
		, div(style = "position:relative", align = "center", actionButton("help_method", "Help", width = "23%", icon = icon("info-circle")))
			)
		)
	)
)
)


		, wellPanel(
			div(align = "center", checkboxInput("results", strong("Save the results and graphs"), FALSE))
						, conditionalPanel(condition = "input.results == true"
, br()
							, div(align = "center", checkboxInput("graphop", "Show graphs options", FALSE))
							, conditionalPanel(
								condition="input.graphop==true"
										, selectInput(
											"type"
										, 	"Optional: Select the type of the graph"
										, 	choices = c("Histogram" = "hist", "Jitter" = "jitter")
										, 	selected = "hist"
										)
									)
							, h5(gettext("Save graphs"), align="center")
        , shiny::radioButtons("paramdown","",
                    choices=list("PNG"="png","JPG"="jpg","PDF"="pdf")
                    ,inline=TRUE
                    ,selected="png"
                    )
							)
			)
, br()


        , div(align="center",actionButton("PCAcode", gettext("Get the evaluation code")))
        


 
, br()
        , div(align="center",actionButton("Quit", gettext("Quit the app")))
        )
)  # fin de parentèse de la 1è div.



, mainPanel(
		tabsetPanel(id = "tabsetPanel"
			, selected = "Values"
#########################################################################
#####               7th tabPanel "Quick evaluation" 	              #####
#########################################################################
, tabPanel("Quick Evaluation"
, br()
, br()

, div(align = "center"
, strong(paste("The model specification: "), verbatimTextOutput("Model")
, paste("The outcome of interest: "), verbatimTextOutput("outcome")

, fluidRow(
column(6
# , strong(paste("Calculating the average treatment effect for the treated")
, paste("méthode manuelle")
, verbatimTextOutput("manuelle")
, verbatimTextOutput("x.out")     
, verbatimTextOutput("x1.out")      
, verbatimTextOutput("s.out.robuste")

)

	
, column(6
, paste("estimateur naif")
, verbatimTextOutput("naif")
, strong(paste("Matching"), verbatimTextOutput("matching")
, verbatimTextOutput("s.out")
, verbatimTextOutput("x1.out.robuste")      
, verbatimTextOutput("z.out.robuste")      

)
)
)


, br()
, br()
, paste("How many units where matched, unmatched or discarded")
, verbatimTextOutput("matchit_sample_sizes")

, br()
, br()    
, paste("Remember you need to achieve satisfactory balance before saving the results!")
, br()
, br()

, plotOutput("graph")

# , strong(paste("Output of parameter of interest estimation", ""))

)  # Fin de la () de strong
)  # Fin de la () de la div
)  # Fin de la () du tabPanel              	

#########################################################################
#####               	6th tabPanel Balancing condition            #####
######################################################################### 

 , tabPanel("Balancing condition", icon = icon("balance-scale")
# Rq : Autre noms possibles : Checking balance, Measures of the balance, Balance Statistics, Balance diagnostics, Assess balance !
, br()
, br()

		, div(align = "center"
			, fluidRow(
					column(5
						, strong(p("Samples sizes")
							, verbatimTextOutput("matchit_summary_sample_sizes"))
						, actionButton("help_goal_balance", "Why you need the best balance?", width = "72%",  icon = icon("balance-scale")))

				, column(5
					, strong(p("Percent Balance Improvement")
						, verbatimTextOutput("matchit_summary_percent_balance_improvement"))
					, actionButton("help_percent_balance_improvement", "Mean Diff., eQQ...?", width = "45%", icon = icon("calculator")))
				)

, br()
, hr()

		, plotOutput("graph_balance")

, br()
, hr()

	, fluidRow(
	 	strong(p("Do you want to display additional results for checking balance?"))
	, column(5 
	  , checkboxInput(
      "matchit_summary_balance_for_all_data"
      , strong("Summary of balance for all data")
      ,  FALSE
    )
	  , verbatimTextOutput("matchit_summary_balance_for_all_data")
	 )

	, column(5 
  , checkboxInput(
      "matchit_summary_balance_for_matched_data"
      , strong("Summary of balance for matched data")
      , FALSE
    )
  , verbatimTextOutput("matchit_summary_balance_for_matched_data") 
  )
		, div(align = "center", actionButton("help_all_matched_balance", "Help", width = "17%", icon = icon("info-circle")))
	)
	)
                	
)

 	# , strong(paste("Output of parameter of interest estimation"), verbatimTextOutput("mb"))
 	

                	# , strong(paste("Output Matchit Summary"), verbatimTextOutput("m.outSummary"))

		# , verbatimTextOutput("matchit_summary")


#########################################################################
#####               	5th tabPanel "Values" 				        #####
######################################################################### 

, tabPanel("Values"
, br()
, br()

, div(align = "center"
, uiOutput("Values")
, strong(verbatimTextOutput("results0dim"))
, strong(verbatimTextOutput("results0"))
, strong(verbatimTextOutput("results"))
, verbatimTextOutput("odds.ratios")
, plotOutput("resultsplot")      
, fluidRow(
column(6		
)	
, column(6	
, strong(paste("Summary of Propensity score"), verbatimTextOutput("distance")
, paste("Percent correctly predicted values"), verbatimTextOutput("MatriceConfusion")
)
)
)
, plotOutput("distancehistggplot")         
, plotOutput("distancehist")      
, plotOutput("distancecurve")   
, verbatimTextOutput("mb")      
, verbatimTextOutput("values")      
)
)
#########################################################################
#####               	4th tabPanel "Matched Data"		            #####
######################################################################### 

, tabPanel(".Data", br(), br()
, div(align = "center"
, shiny::radioButtons(
"m.data"
, "Obtain the generated data for:"
, choices = c(
 "All" = "full"
, "Matched data" = "all"
, "Matched treatment group" = "treat"
, "Matched control group" = "control"
, "Unmatched data" = "unmatched"
)
, selected = "all"
, inline = TRUE
)
, br()	
, br()	
, dataTableOutput("m.data"), br(), br()
, br()	
, strong(verbatimTextOutput("dim.m.data")
, br()		
, downloadButton("download.m.data", "Download")
)
)
)	

# output$sample = renderUI(
# # , uiOutput("sample")
# )


#########################################################################
#####  3rd tabPanel: Display interactive comparaison treat vs. control #####
######################################################################### 


  , tabPanel("Comparaison treat vs. control"
, br()
, br()
		, fluidRow(
  	column(5, uiOutput("var_single_tab3"))
  	, column(5, uiOutput("var_multi_tab3"))
  	)

  	, verbatimTextOutput("summaryByTreat")
  	# , verbatimTextOutput("summaryByTreatDF")
  	, p(downloadButton("download_summaryByTreat", "Download"), align = "center")
  	)
   # the the summary
   # , selectInput("bam", h6(gettext("Graphs for")), choices=list(IdChoices=VariableChoices),multiple=FALSE), plotOutput("histo")),
   # Tu peux faire com ds Factoshiny 1menu déroulant pr voir le graph de chak var.

#########################################################################
#####               2sd tabPanel "Summary"				            #####
######################################################################### 
## 2sd tabPanel: Display interactive summaries (more better than the default stats::summary and questionr::describe)

, tabPanel("Summary" 
, br()
, br()
, uiOutput("VARS")
, dataTableOutput("data.selec.summary")
, verbatimTextOutput("download_summary_text")			
, br()           	
, p(downloadButton("download_summary", "Download"), align = "center")
, br()
, br()
, br()
, br()           	
, uiOutput("VAR")               	
, plotOutput("data.selec.graph")
)	

#########################################################################
#####               	1st tabPanel "Data"					        #####
######################################################################### 

## 1st tabPanel: Return dataframe (reactive version) and display dim 

, tabPanel("Data", br(), br()
, div(align = "center"
, tableOutput("data") 
, br() 
, strong(verbatimTextOutput("dim")))
)      		

# fluidRow(
# br(),
# 	column(width = 6,
#                br(),
#                    conditionalPanel(
#                        condition="input.paramdown=='jpg'",
#                           p(downloadButton("downloadData4", gettext("Download as jpg")), align="center")),
#                    # conditionalPanel(
# condition="input.paramdown=='png'",
# p(downloadButton("downloadData3",gettext("Download as png")),align="center")),
# conditionalPanel(
# condition="input.paramdown=='pdf'",
# p(downloadButton("downloadData5",gettext("Download as pdf")),align="center")),
# br(),
# align="center")







# fluidRow(

# )


#    , verbatimTextOutput("treatment_var")

#    , verbatimTextOutput("covar")



)
)
)
)

