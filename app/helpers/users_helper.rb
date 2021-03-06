# frozen_string_literal: true
module UsersHelper
  # Returns the Gravatar for the given user
  def gravatar_for(user)
    gravatar_id = Digest::MD5.hexdigest(user.email.downcase)
    gravatar_url = "http://gravatar.com/avatar/#{gravatar_id}.png?d=mm"
    image_tag(gravatar_url, alt: user.name, class: 'navbar-avatar')
  end
end
