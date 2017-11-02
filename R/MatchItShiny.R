MatchItShiny <- function(x) {
  a=shiny::runApp(system.file("MatchItShiny", package="MatchItShiny") , launch.browser = TRUE)
  return(invisible(a))
}
