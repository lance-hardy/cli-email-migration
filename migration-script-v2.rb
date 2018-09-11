# get configurable attributes from one cls at a time
app = "g5-cls-ix846vtx-storbox-self-s"

# create an array of results
custom_config_results = []

# we need to modify the configurable attributes api to also look for Disabled Tasks - something like
#         @tasks =  LeadTaskManager.instance.tasks
#         loop through each Lead Task to see if disabled - if so add to output

# GET the json output from cls app api endpoint. It will include client_urn, form (if custom config), location_urn (if custom config),
# category, field and value. If the api is modified to look for disabled tasks there would also be something like lead_task
json_output = HTTParty.get("https://#{app}.herokuapp.com/api/v1/configurable_attributes")

# gather all configured attributes for app
configs_array = []

# gather all configurable attributes which includes custom and default values. It should also include Lead Task 'enabled' info if added to api
  json_output.parsed_response['configurable_attributes'].map do |obj| configs_array << obj end

# connect to email service - tbd

# the goal is to
## 1) select client
## 2) select client locations
## 3) delete all configurable attributes associated with those locations
## 4) replace all configurable attributes with json output from api

# Matt Bohme is tasked with deleting client data from email service
# should the delete and insert task be syncrhonous 
