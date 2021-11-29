#-- encoding: UTF-8



# Register interceptors defined in app/mailers/user_mailer.rb
# Do this here, so they aren't registered multiple times due to reloading in development mode.

ApplicationMailer.register_interceptor(DefaultHeadersInterceptor)
# following needs to be the last interceptor
ApplicationMailer.register_interceptor(DoNotSendMailsWithoutReceiverInterceptor)
