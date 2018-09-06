# for combing through all cls at once
# assemble list of cls apps not on email Service
app_migration_list = ["g5-cls-1tg8mswx-cj-real-estate"
"g5-cls-il8mwp5u-fpi-management",
"g5-cls-imdwr16w-pomona-propert",
"g5-cls-iql3e4ar-electra-americ",
"g5-cls-1tatjf2t-discovery-rege",
"g5-cls-1tfoyb4i-jb-real-estate",
"g5-cls-1tfoytvj-bh-real-estate",
"g5-cls-ix846vtx-storbox-self-s",
"g5-cls-1tfoxt2h-md-real-estate",
"etc, etc, etc"]

# create an array of results
custom_config_results = []

# loop through each app in the migration list where we will look for custom cls configs
app_migration_list.each do |app|

  # GET the json output from cls app api endpoint. It will include client_urn, form (if custom config), location_urn (if custom config),
  # category, field and value
  json_output = HTTParty.get("https://#{app}.herokuapp.com/api/v1/configurable_attributes")

  # gather all relevant configured attributes for app
  configs_array = []

  # we make the assumption that a non default, configured attribute will contain either a location_urn and/or a form
  # we only want to collect data that is not default values though even the presence of location_urn does not assure that
  # it is certain that an entry WITHOUT location_urn is definitely default
  json_output.parsed_response['configurable_attributes'].map do |obj| configs_array << obj if obj.location_urn.present? || obj.form.present? end

  # connect to email service - tbd

  # email service models don't align with cls models so path to data migration isn't obvious
  # in the cls a client_urn has many location_urn(s) which have many category(s) which have many field(s) which have many value(s)

  # how does the collected config data get injected into the email service db?
  # in an attempt to find a logical correlation an exploration of email service db produces some examples data structure

  # the email service has many override(s), override_target(s), and override_target_id(s)

  # an override contains an id, override_target_id, field (correlates to cls field), value (correlates to cls value), created_at & updated_at
  o = Override.last
  RESULT: id: 12, override_target_id: 11, field: "header_background_color", value: "#333333", created_at: Thu, 06 Sep 2018 21:52:16 UTC +00:00, updated_at: Thu, 06 Sep 2018 21:52:16 UTC +00:00>

  # an override_target contains an id, email_type_id, client_urn (correlates to cls client_urn), location_urn (correlates to cls location_urn),
  # cls_form_type_id (does this correlate to cls form?), created_at, updated_at, default_override
  o.override_target
  id: 11,
  email_type_id: nil,
  client_urn: "g5-c-ily02vuo-acorn-self-storage-client",
  location_urn: nil,
  cls_form_type_id: nil,
  created_at: Thu, 06 Sep 2018 21:52:16 UTC +00:00,
  updated_at: Thu, 06 Sep 2018 21:52:16 UTC +00:00,
  default_override: false>

  # an override_target client contains typical client info
  o.override_target.client
  => #<G5Updatable::Client:0x005556a1d95f38
   id: 395,
   uid: "http://hub.g5dxm.com/clients/g5-c-ily02vuo-acorn-self-storage-client",
   urn: "g5-c-ily02vuo-acorn-self-storage-client",
   properties:
    {"id"=>360,
     "uid"=>"http://hub.g5dxm.com/clients/g5-c-ily02vuo-acorn-self-storage-client",
     "name"=>"Acorn Self Storage - Client",
     "branded_name"=>"Acorn Self Storage",
     "urn"=>"g5-c-ily02vuo-acorn-self-storage-client",
     "vertical"=>"Self-Storage",
     "street_address_1"=>"",
     "street_address_2"=>"",
     "country"=>"US",
     "city"=>"Brentwood",
     "state"=>"CA",
     "state_name"=>"California",
     "postal_code"=>"",
     "fax"=>"",
     "email"=>"",
     "tel"=>"",
     "domain_type"=>"SingleDomainClient",
     "domain"=>"https://www.acornselfstorage.biz",
     "service_1"=>"",
     "service_2"=>"",
     "service_3"=>"",
     "service_4"=>"",
     "service_5"=>"",
     "secure_domain"=>true,
     "vendor_integration"=>false,
     "created_at"=>"2016-03-18T10:49:27.196-07:00",
     "updated_at"=>"2017-08-17T22:07:33.631-07:00",
     "organization"=>"sockeye",
     "g5_internal"=>false,
     "fb_pixel_id"=>"",
     "adwords_id"=>"",
     "adwords_conversion_label"=>"",
     "status"=>"Active",
     "call_pooling_enabled"=>false},
   created_at: Mon, 21 Aug 2017 21:26:51 UTC +00:00,
   updated_at: Mon, 21 Aug 2017 21:26:51 UTC +00:00,
   name: "Acorn Self Storage - Client">

  # location info can be dug into using G5Updatable but that isn't relevant
  l = G5Updatable::Location.find_by_urn("g5-cl-54e0svnb6-eagle-s-nest-self-storage")
    => #<G5Updatable::Location:0x005556a469f370
   id: 2522,
   uid: "http://hub.g5dxm.com/clients/g5-c-ifsvlxoy-tiger-self-storage-multidomain/locations/g5-cl-54e0svnb6-eagle-s-nest-self-storage",
   urn: "g5-cl-54e0svnb6-eagle-s-nest-self-storage",
   client_uid: "http://hub.g5dxm.com/clients/g5-c-ifsvlxoy-tiger-self-storage-multidomain",
   properties:
    {"uid"=>"http://hub.g5dxm.com/clients/g5-c-ifsvlxoy-tiger-self-storage-multidomain/locations/g5-cl-54e0svnb6-eagle-s-nest-self-storage",
     "client_uid"=>"http://hub.g5dxm.com/clients/g5-c-ifsvlxoy-tiger-self-storage-multidomain",
     "amenities"=>[],
     "created_at"=>"2015-10-15T16:49:25.504-07:00",
     "updated_at"=>"2017-11-18T11:20:24.990-08:00",
     "client_id"=>234,
     "name"=>"Eagle's Nest Self Storage",
     "internal_branded_name"=>"",
     "custom_slug"=>"1",
     "corporate"=>false,
     "urn"=>"g5-cl-54e0svnb6-eagle-s-nest-self-storage",
     "status"=>"Live",
     "status_note"=>nil,
     "etc, etc, etc"

  # recipient target produces client_urn
   r = RecipientTarget.last
    RecipientTarget Load (4.0ms)  SELECT  "recipient_targets".* FROM "recipient_targets"  ORDER BY "recipient_targets"."id" DESC LIMIT 1
    RecipientTarget Load (4.0ms)  SELECT  "recipient_targets".* FROM "recipient_targets"  ORDER BY "recipient_targets"."id" DESC LIMIT 1
  => #<RecipientTarget:0x005556a3b2d820
   id: 7361,
   client_urn: "g5-c-5cowv7cjj-mckenzie-communities",
   created_at: Tue, 21 Nov 2017 00:12:29 UTC +00:00,
   updated_at: Tue, 21 Nov 2017 00:12:29 UTC +00:00,
   all_cls_form_types: true,
   all_locations: false,
   read_only: true,
   all_except_cls_form_types: false>

   # recipient will certainly correspond to some cls config(s) but will these be introduced as recipients or overrides from cls?
   q = Recipient.last
    Recipient Load (1.6ms)  SELECT  "recipients".* FROM "recipients"  ORDER BY "recipients"."id" DESC LIMIT 1
    Recipient Load (1.6ms)  SELECT  "recipients".* FROM "recipients"  ORDER BY "recipients"."id" DESC LIMIT 1
  => #<Recipient:0x005556a39daf90
   id: 42749,
   recipient_target_id: 7361,
   email: "dexterfloralcommunities-test@dfc.com",
   name: nil,
   created_at: Tue, 21 Nov 2017 00:20:37 UTC +00:00,
   updated_at: Tue, 21 Nov 2017 00:20:37 UTC +00:00,
   read_only: true>

    # what is the relationship in email service between client_urn, location_urn and the custom configs to be imported

    # the path to migration is littered with many questions

end
