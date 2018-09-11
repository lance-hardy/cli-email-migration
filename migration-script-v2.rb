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

# overrides_controller contains both delete and create functions - use as guideline
# there is no api currently which displays overrides

def destroy
  @override_target.destroy
  flash[:notice] = 'Successfully deleted Override'
  respond_with @override_target, location: overrides_path
end

def update
  if @override_target.update_attributes(override_target_params)
    flash[:notice] = 'Successfully updated Override'
  else
    @override_target.set_all_overrides
  end
  respond_with @override_target, location: overrides_path(client_urn: client_urn)
end

def new
  @override_target.set_all_overrides
end

def create
  @override_target = OverrideTarget.new(override_target_params)
  if @override_target.save
    flash[:notice] = 'Successfully created Override'
  else
    @override_target.set_all_overrides
  end
  respond_with @override_target, location: overrides_path(client_urn: client_urn)
end

private
def load_target
  @override_target = OverrideTarget.find(params[:override_target_id])
end

def model_client_urn
  @override_target.try(:client_urn)
end

def override_target_params
  return {} unless params[:override_target].present?
  params.require(:override_target).permit(:id, :client_urn, :location_urn, :cls_form_type_id, :email_type_id, overrides_attributes: [:id, :field, :value])
end

def load_new_target
  @override_target = if params[:clone_override_target_id]
                       OverrideTarget.find(params[:clone_override_target_id]).clone_override_target
                     else
                       OverrideTarget.new(client_urn: client_urn)
                     end
end
