#Script that launches calendar for Appointment Chores

$(document).ready ->
  $('#calendar').fullCalendar
    editable: true,
    header:
      left: 'prev,next today',
      center: 'title',
      right: 'month,agendaWeek,agendaDay'
    defaultView: 'agendaWeek',
    firstDay: 1
    height: 500,
    slotMinutes: 30,

    eventSources: [{
      url: '/chores/occurrences',
    }],

    timeFormat: 'h:mm t{ - h:mm t} ',
    dragOpacity: "0.5"

    eventDrop: (event, dayDelta, minuteDelta, allDay, revertFunc) ->
      updateEvent(event);

    eventResize: (event, dayDelta, minuteDelta, revertFunc) ->
      updateEvent(event);


    updateEvent = (the_event) ->
     $.update "/chores/" + the_event.id,
     event:
      title: the_event.title,
      starts_at: "" + the_event.start,
      ends_at: "" + the_event.end,
      description: the_event.description

$(document).ready ->
 $('#daily_calendar').fullCalendar
    editable: true,
    header: false,
    defaultView: 'agendaDay',
    firstDay: 1
    height: 500,
    slotMinutes: 30,

    eventSources: [{
      url: '/chores/occurrences',
    }]
