# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
    today = new Date
    todayBR = today.getDate() + "/" + (today.getMonth() + 1) + "/" + today.getFullYear()

    $(".installationpicker").datepicker {
      language: "pt-BR",
      endDate: todayBR  
    }

    $(".installationduepicker").datepicker { 
        language: "pt-BR",
        startDate: todayBR
    }

    $(".paymentpicker").datepicker { 
        language: "pt-BR",
    }

    $(".installation-value").keyup ->
        totalValue = parseFloat(standardizeString($("#cable").val())) + parseFloat(standardizeString($("#bail").val())) + parseFloat(standardizeString($("#router").val())) + parseFloat(standardizeString($("#other").val()))
        $("#installationTotal").html totalValue.toFixed(2).replace(".",",")
        return

    return # ending DOM-ready

standardizeString = (string) -> 
    string.replace(/\./g,"").replace(/\,/g,".")
    