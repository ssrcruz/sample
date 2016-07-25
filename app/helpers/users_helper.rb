module UsersHelper

  # returns the gravatar for the given user
  def gravatar_for(user, size: 50)
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase) # The MD5 algorithim is a hash function used to check data integrity
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}.png?s=#{size}"
    image_tag(gravatar_url, alt: user.name, class: "gravatar")
  end

end
