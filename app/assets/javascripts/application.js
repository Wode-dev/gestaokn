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
//= require_tree .
//= require jquery3
//= require jquery_ujs
//= require toastr


$(function(){

    // Ativar ou desativar usuario
    $('input[type=checkbox].switch-secret').change(function() {
        console.log("checkbox")
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
    })
});

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