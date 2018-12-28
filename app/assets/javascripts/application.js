// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require activestorage
// require turbolinks
//= require jquery3
//= require jquery_ujs
//= require popper
//= require bootstrap-sprockets
//= require_tree .
//= require toastr


$(function(){

    feather.replace();

    $('.dropdown-toggle').dropdown();

    $(".date-picker").datepicker({
        language: "pt-BR",
    });

    // Ativar ou desativar usuario
    $('input[type=checkbox].switch-secret').change(function(){
        var toggle = $(this);
        $('input[type=checkbox].switch-secret').bootstrapToggle('disable');
        
        $.post(
            "secrets/switch",
            {"secret_id":$(this).prop("id"),
                "state":$(this).prop('checked') },
            function(data, textStatus, request){
                updateRowColorStatus(toggle)
                toggle.bootstrapToggle('enable');
            }, 
           "json")
           .fail(function() {
               toggle.bootstrapToggle('toggle');
               updateRowColorStatus(toggle)
           });
    });

    maskForMoneyInput();

    try {
        conterBlockUpdateRepeat();
        registerCounterBlockButtonsListeners();
    } catch (error) {
        console.log("Usuário programado para bloqueio")
    }
    
});

function conterBlockUpdateRepeat() {
    counterBlockUpdate();
    setTimeout(conterBlockUpdateRepeat, 1000);
}

// Atualiza o contador do modal de programação para bloquear cliente
function counterBlockUpdate() {
    var date = new Date();
    var blocktime = 0;
    
    blocktime += parseInt($("input#days")[0].value) * 24 * 60 * 60;
    blocktime += parseInt($("input#hours")[0].value) * 60 * 60;
    blocktime += parseInt($("input#minutes")[0].value) * 60;
    blocktime += parseInt($("input#seconds")[0].value);
    
    date.setSeconds(blocktime + date.getSeconds());

    $("span#date-0").text(date.getDate());
    $("span#date-1").text(date.getMonth() + 1);
    $("span#date-2").text(date.getFullYear());
    
    $("span#time-0").text(date.getHours());
    $("span#time-1").text(date.getMinutes());
    $("span#time-2").text(date.getSeconds());
}

function registerCounterBlockButtonsListeners() {    
    $("button.plus-button, button.minus-button").click(function(event) {
        if ($(event.target).attr('class').includes("plus-button")) {
            // botão de somar
            var object = $("input." + $(event.target).attr('id'));
            object.val(parseInt(object.val()) + 1);
        } else if($(event.target).attr('class').includes("minus-button")) {
            // Botão de subtrair
            var object = $("input." + $(event.target).attr('id'));
            if(object.val() > 0){
                object.val(parseInt(object.val()) - 1);
            }
        }

        counterBlockUpdate();
    });
}

function updateRowColorStatus(toggle) {
    $('input[type=checkbox].switch-secret').bootstrapToggle('enable');
    
    if(toggle.prop('checked')){
        toggle.parent().parent().parent().parent().parent().parent().parent()
        .removeClass("txt-accent")
    } else {
        toggle.parent().parent().parent().parent().parent().parent().parent()
        .addClass("txt-accent");
    }
}

function maskForMoneyInput(){
    $(".money-input").inputmask('decimal', {
        'alias': 'numeric',
        'groupSeparator': '.',
        'autoGroup': true,
        'digits': 2,
        'radixPoint': ",",
        'digitsOptional': false,
        'allowMinus': false,
        'placeholder': ''
    });
}
