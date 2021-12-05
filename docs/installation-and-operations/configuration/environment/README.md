---
sidebar_navigation:
  title: Environment variables
  priority: 10
---



# Environment variables

When using environment variables, you can set the options by setting environment variables with the name of the options below in uppercase. So for example, to configure email delivery via an SMTP server, you can set the following environment variables:

```bash
EMAIL_DELIVERY_METHOD="smtp"
SMTP_ADDRESS="smtp.example.net"
SMTP_PORT="587"
SMTP_DOMAIN="example.net"
SMTP_AUTHENTICATION="plain"
SMTP_USER_NAME="user"
SMTP_PASSWORD="password"
SMTP_ENABLE_STARTTLS_AUTO="true"
```

In case you want to use environment variables, but you have no easy way to set them on a specific system, you can use the [dotenv](https://github.com/bkeepers/dotenv) gem. It automatically sets environment variables written to a .env file for a Rails application.



### Nested values

You can override nested configuration values as well by joining the respective hash keys with underscores.
Underscores within keys have to be escaped by doubling them.
For example, given the following configuration:

    storage:
      tmp_path: tmp

You can override it by defining the following environment variable:

    PROYEKSIAPP_STORAGE_TMP__PATH=/some/other/path

You can also add new values this way. For instance you could add another field 'type' to the
storage config above like this:

    PROYEKSIAPP_STORAGE_TYPE=nfs

## Passing data structures

The configuration uses YAML to parse overrides from ENV. Using YAML inline syntax, you can:

1. Pass a symbol as an override using `PROYEKSIAPP_SESSION_STORE=":active_record_store"`

2. Pass arrays by wrapping values in brackets (e.g., `[val1, val2, val3]`).

3. Pass hashes with `{key: foo, key2: bar}`.

To pass symbol arrays or hashes with symbol keys, use the YAML `!ruby/symbol` notation.
Example: `{!ruby/symbol key: !ruby/symbol value}` will be parsed as `{ key: :value }`.

Please note: The Configuration is a HashWithIndifferentAccess and thus it should be irrelevant for hashes to use symbol keys.


# Supported environment variables

Below is the full list of supported environment variables that can be used to override the default configuration of your ProyeksiApp installation:

```
PROYEKSIAPP_EDITION (default="standard")                                                                                                         
PROYEKSIAPP_ATTACHMENTS__STORAGE (default="file")                                                                                                 
PROYEKSIAPP_ATTACHMENTS__STORAGE__PATH (default=nil)
PROYEKSIAPP_ATTACHMENTS__GRACE__PERIOD (default=180)                                                             
PROYEKSIAPP_AUTOLOGIN__COOKIE__NAME (default="autologin")
PROYEKSIAPP_AUTOLOGIN__COOKIE__PATH (default="/")
PROYEKSIAPP_AUTOLOGIN__COOKIE__SECURE (default=false)   
PROYEKSIAPP_DATABASE__CIPHER__KEY (default=nil)            
PROYEKSIAPP_SHOW__COMMUNITY__LINKS (default=true)      
PROYEKSIAPP_LOG__LEVEL (default="info")              
PROYEKSIAPP_SCM__GIT__COMMAND (default=nil)          
PROYEKSIAPP_SCM__SUBVERSION__COMMAND (default=nil)
PROYEKSIAPP_SCM__LOCAL__CHECKOUT__PATH (default="repositories")
PROYEKSIAPP_DISABLE__BROWSER__CACHE (default=true)   
PROYEKSIAPP_RAILS__CACHE__STORE (default=nil)                                                   
PROYEKSIAPP_CACHE__EXPIRES__IN__SECONDS (default=nil)
PROYEKSIAPP_CACHE__NAMESPACE (default=nil)
PROYEKSIAPP_CACHE__MEMCACHE__SERVER (default=nil)
PROYEKSIAPP_SESSION__STORE (default=:cache_store)
PROYEKSIAPP_SESSION__COOKIE__NAME (default="_open_project_session")
PROYEKSIAPP_DROP__OLD__SESSIONS__ON__LOGOUT (default=true)
PROYEKSIAPP_DROP__OLD__SESSIONS__ON__LOGIN (default=false)
PROYEKSIAPP_RAILS__RELATIVE__URL__ROOT (default="")
PROYEKSIAPP_RAILS__FORCE__SSL (default=false)
PROYEKSIAPP_RAILS__ASSET__HOST (default=nil)
PROYEKSIAPP_ENABLE__INTERNAL__ASSETS__SERVER (default=false)
PROYEKSIAPP_FORCE__HELP__LINK (default=nil)
PROYEKSIAPP_FORCE__FORMATTING__HELP__LINK (default=nil)
PROYEKSIAPP_IMPRESSUM__LINK (default=nil)
PROYEKSIAPP_DEFAULT__COMMENT__SORT__ORDER (default="asc")
PROYEKSIAPP_EMAIL__DELIVERY__CONFIGURATION (default="inapp")
PROYEKSIAPP_EMAIL__DELIVERY__METHOD (default=nil)
PROYEKSIAPP_SMTP__ADDRESS (default=nil)
PROYEKSIAPP_SMTP__PORT (default=nil)
PROYEKSIAPP_SMTP__DOMAIN (default=nil)
PROYEKSIAPP_SMTP__AUTHENTICATION (default=nil)                                                                                                       
PROYEKSIAPP_SMTP__USER__NAME (default=nil)
PROYEKSIAPP_SMTP__PASSWORD (default=nil)
PROYEKSIAPP_SMTP__ENABLE__STARTTLS__AUTO (default=nil)                                                                                            
PROYEKSIAPP_SMTP__OPENSSL__VERIFY__MODE (default=nil)                                                                                     
PROYEKSIAPP_SENDMAIL__LOCATION (default="/usr/sbinsendmail")
PROYEKSIAPP_SENDMAIL__ARGUMENTS (default="-i")                                                                           
PROYEKSIAPP_DISABLE__PASSWORD__LOGIN (default=false)
PROYEKSIAPP_AUTH__SOURCE__SSO (default=nil)       
PROYEKSIAPP_OMNIAUTH__DIRECT__LOGIN__PROVIDER (default=nil)
PROYEKSIAPP_INTERNAL__PASSWORD__CONFIRMATION (default=true)
PROYEKSIAPP_DISABLE__PASSWORD__CHOICE (default=false)    
PROYEKSIAPP_OVERRIDE__BCRYPT__COST__FACTOR (default=nil)
PROYEKSIAPP_DISABLED__MODULES (default=[])              
PROYEKSIAPP_HIDDEN__MENU__ITEMS (default={})               
PROYEKSIAPP_BLACKLISTED__ROUTES (default=[])         
PROYEKSIAPP_APIV3__ENABLE__BASIC__AUTH (default=true)
PROYEKSIAPP_ONBOARDING__VIDEO__URL (default="https://player.vimeo.com/video/163426858?autoplay=1")
PROYEKSIAPP_ONBOARDING__ENABLED (default=true)    
PROYEKSIAPP_YOUTUBE__CHANNEL (default="https://www.youtube.com/c/ProyeksiAppCommunity")
PROYEKSIAPP_EE__MANAGER__VISIBLE (default=true)      
PROYEKSIAPP_HEALTH__CHECKS__AUTHENTICATION__PASSWORD (default=nil)                              
PROYEKSIAPP_HEALTH__CHECKS__JOBS__QUEUE__COUNT__THRESHOLD (default=50)
PROYEKSIAPP_HEALTH__CHECKS__JOBS__NEVER__RAN__MINUTES__AGO (default=5)               
PROYEKSIAPP_AFTER__LOGIN__DEFAULT__REDIRECT__URL (default=nil)
PROYEKSIAPP_AFTER__FIRST__LOGIN__REDIRECT__URL (default=nil)   
PROYEKSIAPP_MAIN__CONTENT__LANGUAGE (default="english")               
PROYEKSIAPP_CROWDIN__IN__CONTEXT__TRANSLATIONS (default=true)         
PROYEKSIAPP_GRAVATAR__FALLBACK__IMAGE (default="404")      
PROYEKSIAPP_REGISTRATION__FOOTER (default={})            
PROYEKSIAPP_SECURITY__BADGE__DISPLAYED (default=true)
PROYEKSIAPP_INSTALLATION__TYPE (default="manual")            
PROYEKSIAPP_SECURITY__BADGE__URL (default="https://releases.proyeksiapp.com/v1/check.svg")
PROYEKSIAPP_MIGRATION__CHECK__ON__EXCEPTIONS (default=true)
PROYEKSIAPP_SHOW__PENDING__MIGRATIONS__WARNING (default=true)
PROYEKSIAPP_SHOW__WARNING__BARS (default=true) 
PROYEKSIAPP_SHOW__STORAGE__INFORMATION (default=true)    
```
