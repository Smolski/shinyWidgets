

#' Knob Input
#'
#' @param inputId The \code{input} slot that will be used to access the value.
#' @param label Display label for the control, or NULL for no label.
#' @param value Initial value.
#' @param min Minimum allowed value, default to \code{0}.
#' @param max Maximum allowed value, default to \code{100}.
#' @param step Specifies the interval between each selectable value, default to \code{1}.
#' @param angleOffset Starting angle in degrees, default to \code{0}.
#' @param angleArc Arc size in degrees, default to \code{360}.
#' @param cursor Display mode "cursor", don't work properly if \code{width} is not set in pixel, (\code{TRUE} or \code{FALSE}).
#' @param thickness Gauge thickness, numeric value.
#' @param lineCap Gauge stroke endings, 'default' or 'round'.
#' @param displayInput Hide input in the middle of the knob (\code{TRUE} or \code{FALSE}).
#' @param displayPrevious Display the previous value with transparency (\code{TRUE} or \code{FALSE}).
#' @param rotation Direction of progression, 'clockwise' or 'anticlockwise'.
#' @param fgColor Foreground color.
#' @param inputColor Input value (number) color.
#' @param bgColor Background color.
#' @param readOnly Disable knob (\code{TRUE} or \code{FALSE}).
#' @param skin Change Knob skin, only one option available : 'tron'.
#' @param width The width of the input, e.g. \code{400px}, or \code{100\%}.
#' @param height The height of the input, e.g. \code{400px}, or \code{100\%}.
#' @param immediate If \code{TRUE} (default), server-side value is updated each time value change,
#' if \code{FALSE} value is updated when user release the widget.
#'
#' @return Numeric value server-side.
#' @export
#'
#' @seealso \code{\link{updateKnobInput}} for updating the value server-side.
#'
#' @importFrom shiny restoreInput
#' @importFrom htmltools tags
#'
#' @examples
#' \dontrun{
#'
#' if (interactive()) {
#'
#' library("shiny")
#' library("shinyWidgets")
#'
#' ui <- fluidPage(
#'   knobInput(
#'     inputId = "myKnob",
#'     label = "Display previous:",
#'     value = 50,
#'     min = -100,
#'     displayPrevious = TRUE,
#'     fgColor = "#428BCA",
#'     inputColor = "#428BCA"
#'   ),
#'   verbatimTextOutput(outputId = "res")
#' )
#'
#' server <- function(input, output, session) {
#'
#'   output$res <- renderPrint(input$myKnob)
#'
#' }
#'
#' shinyApp(ui = ui, server = server)
#'
#' }
#'
#' }
knobInput <- function(inputId, label, value, min = 0, max = 100, step = 1,
                      angleOffset = 0, angleArc = 360, cursor = FALSE,
                      thickness = NULL, lineCap = c("default", "round"), displayInput = TRUE,
                      displayPrevious = FALSE, rotation = c("clockwise", "anticlockwise"),
                      fgColor = NULL, inputColor = NULL, bgColor = NULL,
                      readOnly = FALSE, skin = NULL, width = NULL, height = NULL,
                      immediate = TRUE) {
  value <- shiny::restoreInput(id = inputId, default = value)
  lineCap <- match.arg(lineCap)
  rotation <- match.arg(rotation)
  knobParams <- dropNulls(list(
    id = inputId, type = "text", class = "knob-input",
    value = value, `data-value` = value, `data-skin` = skin,
    `data-min` = min, `data-max` = max, `data-step` = step,
    `data-angleoffset` = angleOffset, `data-anglearc` = angleArc,
    `data-displayprevious` = displayPrevious, `data-thickness` = thickness,
    `data-displayinput` = displayInput, `data-linecap` = lineCap,
    `data-fgcolor` = fgColor, `data-inputcolor` = inputColor,
    `data-bgcolor` = bgColor, `data-cursor` = cursor,
    `data-rotation` = rotation, `data-readonly` = readOnly,
    `data-width` = width, `data-height` = height,
    `data-immediate` = immediate
  ))
  knobParams <- lapply(knobParams, function(x) {
    if (identical(x, TRUE))
      "true"
    else if (identical(x, FALSE))
      "false"
    else x
  })
  inputTag <- do.call(htmltools::tags$input, knobParams)
  knobInputTag <- htmltools::tags$div(
    class = "form-group shiny-input-container",
    style = if (!is.null(width)) paste0("width: ", htmltools::validateCssUnit(width), ";"),
    if (!is.null(label)) htmltools::tags$label(`for` = inputId, label),
    if (!is.null(label)) htmltools::tags$br(),
    inputTag
  )
  attachShinyWidgetsDep(knobInputTag, "jquery-knob")
}





#' Change the value of a knob input on the client
#'
#' @param session Standard shiny \code{session}.
#' @param inputId The id of the input object.
#' @param label The label to set for the input object.
#' @param value The value to set for the input object.
#' @param options List of additional parameters to update, use \code{knobInput}'s arguments.
#'
#' @export
#'
#' @examples
#' \dontrun{
#'
#' if (interactive()) {
#'
#' library("shiny")
#' library("shinyWidgets")
#'
#' ui <- fluidPage(
#'   tags$h1("knob update examples"),
#'   br(),
#'
#'   fluidRow(
#'
#'     column(
#'       width = 6,
#'       knobInput(
#'         inputId = "knob1", label = "Update value:",
#'         value = 75, angleOffset = 90, lineCap = "round"
#'       ),
#'       verbatimTextOutput(outputId = "res1"),
#'       sliderInput(
#'         inputId = "upknob1", label = "Update knob:",
#'         min = 0, max = 100, value = 75
#'       )
#'     ),
#'
#'     column(
#'       width = 6,
#'       knobInput(
#'         inputId = "knob2", label = "Update label:",
#'         value = 50, angleOffset = -125, angleArc = 250
#'       ),
#'       verbatimTextOutput(outputId = "res2"),
#'       textInput(inputId = "upknob2", label = "Update label:")
#'     )
#'
#'   )
#' )
#'
#' server <- function(input, output, session) {
#'
#'   output$res1 <- renderPrint(input$knob1)
#'
#'   observeEvent(input$upknob1, {
#'     updateKnobInput(
#'       session = session,
#'       inputId = "knob1",
#'       value = input$upknob1
#'     )
#'   }, ignoreInit = TRUE)
#'
#'
#'   output$res2 <- renderPrint(input$knob2)
#'   observeEvent(input$upknob2, {
#'     updateKnobInput(
#'       session = session,
#'       inputId = "knob2",
#'       label = input$upknob2
#'     )
#'   }, ignoreInit = TRUE)
#'
#' }
#'
#' shinyApp(ui = ui, server = server)
#'
#' }
#'
#' }
updateKnobInput <- function(session, inputId, label = NULL, value = NULL, options = NULL) {
  message <- dropNulls(list(label = label, value = value, options = options))
  session$sendInputMessage(inputId, message)
}


