# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/


$ ->
  $("select[data-behaviour~='parent_project_select']").change ->
    new_parent_project_id = $("#project_parent_project_id").val()
    for project in gon.projects
        if ''+project.id == new_parent_project_id   
            new_context_id = project.context_id 
    $("#project_context_id").val(new_context_id)
    