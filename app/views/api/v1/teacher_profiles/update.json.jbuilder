json.success true
json.msg 'Profile updated sucessfully.'
json.data do
  json.id @profile.id
  json.full_name @profile.full_name
  json.organization @profile.organization
  json.phone @profile.phone
end
