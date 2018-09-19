# Begin Rake Task

# 1) PASS IN CLIENT URN
@client = G5Updatable::Client.find_by_urn('CLIENT_URN')

# get the client cls from client urn in updatable
app = @client.get_client_cls

# 2) PULL DATA FROM CLS API

# GET the json output from cls app api endpoint. It will include an indicator if on email_service, form tasks disabled or enabled,
# client_urn, form (if custom config), location_urn (if custom config), category, field and value.
json_output = HTTParty.get("https://#{app}.herokuapp.com/api/v1/configurable_attributes")

# gather all configured attributes for app
configs_array = []

# gather all configurable attributes which includes custom and default values. It should also include Lead Task 'enabled' info if added to api
# figure out what kind of parsed data is required for insertion in email service db
  json_output.parsed_response['configurable_attributes'].map do |obj| configs_array << obj end

# 3) DETERMINE DATA FORMAT REQUIRED

# the way data is entered in email-service it makes sense to take the json output and separate it into individual location data collections, eg
# outputs would be comma separated strings, acceptable for form inputs in email service
# this illustrates an assumption of two possible values in one input but it should be determined what the max number of values may be
# this is really only criticial for a recipient who has a name and email that belong to each other
{
  location_urn1: { to_emails: 'asdf,asdf', to_names: 'asdf,asdf', from_email: 'asdf,asdf', reply_to_email: 'asdf, asdf'....}
  location_urn2: { to_emails: 'asdf,asdf', to_names: 'asdf,asdf', from_email: 'asdf,asdf', reply_to_email: 'asdf, asdf'....}
  ...
}

# 3) CHECK EMAILS_CONFIG KEY TO SEE IF G5_EMAILS ALREADY SET, ELSE RETURN

if json_output.emails_config == null
  keep going
else
  stop!

# 4) CONNECT TO EMAIL SERVICE - THE DELETE AND INSERT TASK CAN BE SYNCHRONOUS

# wrap functionality in transaction so no database commit will happen if something goes wrong
# START

# 5) FIND ALL OVERRIDES, OVERRIDE_TARGETS, RECIPIENTS, RECIPIENT_TARGETS, DISABLES AND DELETE

# example, loop through recipient targets where client urn is whatever, destroy
# check for default override flags and do not delete defaults. eg, Recipient has 'Set in g5-hub' flag

# 6) REBUILD FROM PARSED JSON API DATA

# loop through all locations that belong to selected client
locations = all location_urns

locations.each do |locations|
  location.override_target
  # find an override target that has this location and this email type (error, location, customer, etc)
  # if one is not found it should be created
  # create an override for the field value combination
  # the new override points to the override target

  location.to_email ?
  # a recipient would needs to be added to the recipient table


# END
