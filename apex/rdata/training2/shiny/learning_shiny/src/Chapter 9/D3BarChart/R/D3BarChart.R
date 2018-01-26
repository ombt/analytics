#' <Add Title>
#'
#' <Add Description>
#'
#' @import htmlwidgets
#'
#' @export
D3BarChart <- function(data,var,tooltip, width = NULL , height = NULL) {

  # forward options using x
  x = list(
    inpdata = data,
    plotvar = var,
    tooltip = tooltip
  )

  # create widget
  htmlwidgets::createWidget(
    name = 'D3BarChart',
    x,
    width = width,
    height = height,
    package = 'D3BarChart'
  )
}

#' Widget output function for use in Shiny
#'
#' @export
D3BarChartOutput <- function(outputId, width = '100%', height = '400px'){
  shinyWidgetOutput(outputId, 'D3BarChart', width, height, package = 'D3BarChart')
}

#' Widget render function for use in Shiny
#'
#' @export
renderD3BarChart <- function(expr, env = parent.frame(), quoted = FALSE) {
  if (!quoted) { expr <- substitute(expr) } # force quoted
  shinyRenderWidget(expr, D3BarChartOutput, env, quoted = TRUE)
}
