# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
    $(".installation-value-record").keyup ->
        totalValue = parseFloat(standardizeString($("#secret_cable").val())) + parseFloat(standardizeString($("#secret_bail").val())) + parseFloat(standardizeString($("#secret_router").val())) + parseFloat(standardizeString($("#secret_other").val()))
        $("#installationTotal").html totalValue.toFixed(2).replace(".",",")
        return

standardizeString = (string) -> 
    string.replace(/\./g,"").replace(/\,/g,".")