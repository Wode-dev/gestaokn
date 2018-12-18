# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
    $(".edit-payment-form-button").click (event) ->
        $("input#id").val(event.target.id)
        $("input#kind.edit-form").val($("#" + event.target.id + ".payment-form-kind")[0].innerText)
        $("input#place.edit-form").val($("#" + event.target.id + ".payment-form-place")[0].innerText)
        return
    return