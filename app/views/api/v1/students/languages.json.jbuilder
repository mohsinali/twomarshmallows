json.success true
json.msg 'Languages'

json.data do
  json.array! @languages do |lng|
    json.partial! 'api/v1/languages/language', lng: lng
  end
end