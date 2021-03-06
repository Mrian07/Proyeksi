module API
  module V3
    URN_PREFIX = 'urn:proyeksiapp-org:api:v3:'.freeze
    URN_ERROR_PREFIX = "#{URN_PREFIX}errors:".freeze
    # For resources invisible to the user, a resource (including a payload) will contain
    # an "undisclosed uri" instead of a url. This indicates the existence of a value
    # without revealing anything. An example for this is the parent project which might be
    # invisible to a user.
    # In case a "undisclosed uri" is provided as a link, the current value is not
    # to be altered and thus it is treated as if the value where never provided in
    # the first place. This allows a schema/_embedded/payload -> client -> POST/PUT
    # request/response round trip where the user knows of the existence of the value without revealing
    # the contents. The payload remains valid in this case and the client can distinguish between
    # keeping the value and unsetting the linked resource to null.
    URN_UNDISCLOSED = "#{URN_PREFIX}undisclosed".freeze
  end
end

