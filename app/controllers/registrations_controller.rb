class RegistrationsController < Devise::RegistrationsController


  def create
    super do
      User.create(registration_id: resource.id)
      subscribe_to_mailchimp if params[:registration][:gets_mail] == "1"
    end
  end

  def subscribe_to_mailchimp
    gibbon = Gibbon::Request.new(api_key: ENV['MAILCHIMP_API_KEY'])
    gibbon.timeout = 15
    gibbon.open_timeout = 15
    gibbon.symbolize_keys = true
    gibbon.debug = false
    gibbon.lists(ENV['MAILCHIMP_LIST_ID']).members(Digest::MD5.hexdigest(resource.email)).upsert(body: {email_address: resource.email, status: "subscribed", interests: {"8b90dea17b": true, "ba4727f76c": true}})
  end

  protected

  def after_sign_up_path_for(resource)
    edit_user_path(resource.user)
  end

end
