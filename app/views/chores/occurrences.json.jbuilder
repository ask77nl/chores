json.array!(@occurrences) do |occurrence|
  json.extract! occurrence, :id, :title
  json.start occurrence.start
  json.end occurrence.end
  json.allDay occurrence.allDay
  json.url occurrence_url(occurrence, format: :html)
end