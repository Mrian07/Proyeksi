#-- encoding: UTF-8



# Be sure to restart your server when you modify this file.

# Add new mime types for use in respond_to blocks:
# Mime::Type.register "text/richtext", :rtf
# Mime::Type.register_alias "text/html", :iphone

Mime::SET << Mime[:csv] unless Mime::SET.include?(Mime[:csv])

Mime::Type.register 'application/pdf', :pdf unless Mime::Type.lookup_by_extension(:pdf)
Mime::Type.register 'image/png', :png unless Mime::Type.lookup_by_extension(:png)
