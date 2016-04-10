module UsersHelper
  # Returns the Gravatar for the given user
  def gravatar_for(user)
    default_url =  url_encode ("#{root_url}images/icons/avatar.png" )
    gravatar_id = Digest::MD5.hexdigest(user.email.downcase)
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?d=#{default_url}"
    image_tag(gravatar_url, alt: user.name, class: 'navbar-avatar')
  end

end
