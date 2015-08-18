# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/



$ -> $('[data-behaviour~=datepicker]').datepicker({"format": "mm/dd/yyyy", "autoclose": true});

$ ->
  $("input[data-behaviour~='all_day_checkbox']").click (e) ->
    toggle_all_day()

$ ->
  $("select[data-behaviour~='choretype_select']").change ->
    toggle_dates()


toggle_all_day =  ->
    if $("#chore_all_day").prop('checked')
      $("#start_time").hide()
      $("#end_time").hide()  
    else
     $("#start_time").show()
     $("#end_time").show()

toggle_dates =  ->
    if $("#chore_choretype_id").prop('value') == '1' or $("#chore_choretype_id").prop('value') == '2' 
      $("#first_appointment_panel").hide()
      $("#frequency_panel").hide()  
    else
     $("#first_appointment_panel").show()
     today = new Date();
     if($("#chore_startdate").val() == 'not set')
      $("#chore_startdate").val(today.getMonth()+1+'/'+today.getDate()+'/'+today.getFullYear())
     if($("#chore_deadline").val() == 'not set')
      $("#chore_deadline").val(today.getMonth()+1+'/'+today.getDate()+'/'+today.getFullYear())
     $("#frequency_panel").show()  

$ -> toggle_all_day()
$ -> toggle_dates()