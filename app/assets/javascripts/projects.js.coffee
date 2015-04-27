# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/


$ ->
  $("select[data-behaviour~='parent_project_select']").change ->
    new_parent_project = $("#project_parent_project_id").val()
    find = (gon.projects.filter (i) -> i.name is new_parent_project)[0]
    alert("find is"+find)
    new_context = find.context_id
    $("#project_context_id").val(new_context)
    alert("new context is"+new_context)