# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
    $("#testMkConnection").click (event) ->
        console.log "clicked"

        ip = $("#mk_ip")[0].value
        user = $("#mk_user")[0].value
        password = $("#mk_password")[0].value

        testMikrotikConnection(ip, user, password)

        return
    
    $("#testInitialConfiguration").click (event) ->
        console.log("clicado")

        ip = $("#mk_ip")[0].value
        user = $("#mk_user")[0].value
        password = $("#mk_password")[0].value

        testMikrotikConnection(ip, user, password)

        return
    
    $("Button.showUserModalButton").click (event) ->
        id = event.currentTarget.id

        name = $("tr#" + id).children(".name")[0].innerText
        nick_name = $("tr#" + id).children(".nick_name")[0].innerText
        email = $("tr#" + id).children(".email")[0].innerText
        # console.log($("tr#"+id).children(".name")[0].innerText)

        modal = $("div.modal-body.edit-users")
        modal.children("input#name").val(name)
        modal.children("input#nick_name").val(nick_name)
        modal.children("input#email").val(email)
        modal.children("input#id").val(id)

        return
    
    return # ending DOM-ready

testMikrotikConnection = (ip, user, password) ->
    $("#testMkConnection").addClass("disabled")

    console.log ip
    
    object = $.post "configuracoes/teste",
    { "ip": ip,
    "user": user,
    "password": password },
    (data, textStatus, request) ->
        $("#testMkConnection").removeClass("disabled")
        if data["connection"] is true
            toastr["success"]("Mikrotik conectado com sucesso")
            $("#submitInitialConfiguration").trigger("click")
        else
            toastr["warning"]("Não foi possível conectar")
        return
    , "json"

    object.fail ->
        toastr["error"]("Não foi possível fazer o teste")
        $("#testMkConnection").removeClass("disabled")
        return
    
    return