json.array!(@occurrences) do |occurrence|
  json.extract! occurrence, :id, :title
  json.start occurrence.start_time
  json.end occurrence.end_time
  #json.url occurrence_url(occurrence, format: :html)
end