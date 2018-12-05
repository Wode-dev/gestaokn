# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
    $("#testMkConnection").click (event) ->
        console.log "clicked"

        $("#testMkConnection").addClass("disabled")

        ip = $("#mk_ip")[0].value
        user = $("#mk_user")[0].value
        password = $("#mk_password")[0].value

        console.log ip
        
        object = $.post "configuracoes/teste",
        {"ip":ip,
        "user":user,
        "password":password }, 
        (data, textStatus, request) ->
            $("#testMkConnection").removeClass("disabled")
            if data["connection"] is true
                toastr["success"]("Mikrotik conectado com sucesso")
            else
                toastr["warning"]("Não foi possível conectar")
            return
        , "json"

        object.fail ->
            toastr["error"]("Não foi possível fazer o teste")
            $("#testMkConnection").removeClass("disabled")
            return
        return
    
    return # ending DOM-ready