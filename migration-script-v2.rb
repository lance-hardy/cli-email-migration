# 1) PULL FROM CLS

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

# 2) DETERMINE DATA FORMAT REQUIRED

# the way data is entered in email-service it makes sense to take the json output and separate it into individual location data collections, eg
# outputs would be comma separated strings, acceptable for form inputs in email service
# this illustrates and assumption of two possible values in one input but it should be determined what the max number of values may be
{
  location_urn1: { to_emails: 'asdf,asdf', to_names: 'asdf,asdf', from_email: 'asdf,asdf', reply_to_email: 'asdf, asdf'....}
  location_urn2: { to_emails: 'asdf,asdf', to_names: 'asdf,asdf', from_email: 'asdf,asdf', reply_to_email: 'asdf, asdf'....}
  ...
}

# 3) CHECK ENV VAR TO SEE IF G5_EMAILS ALREADY SET, ELSE RETURN

# in case the client is already using email service, check heroku env var first

# 4) CONNECT TO EMAIL SERVICE - THE DELETE AND INSERT TASK CAN BE SYNCHRONOUS

# wrap functionality in transaction so no database commit will happen if something goes wrong
# START

# 5) FIND ALL OVERRIDES, OVERRIDE_TARGETS, RECIPIENTS, RECIPIENT_TARGETS, DISABLES AND DELETE

# example, loop through recipient targets where client urn is whatever, destroy
# check for default override flags and do not delete defaults. eg, Recipient has 'Set in g5-hub' flag

# 6) REBUILD FROM CLS API JSON (OR REFORMATTED DATA)

# example, loop through recipient targets where client urn is whatever, insert
# check for default override flags and do not replace defaults. eg, Recipient has 'Set in g5-hub' flag

# END 
