package Apache::ProyeksiAppAuthentication;

use strict;
use warnings FATAL => 'all', NONFATAL => 'redefine';

use Digest::SHA;

use Apache2::Module;
use Apache2::Access;
use Apache2::ServerRec qw();
use Apache2::RequestRec qw();
use Apache2::RequestUtil qw();
use Apache2::Const qw(:common :override :cmd_how);
use APR::Pool ();
use APR::Table ();

use HTTP::Request::Common qw(POST);
use LWP::UserAgent;
use LWP::Protocol::http;


# use Apache2::Directive qw();

my @directives = (
  {
    name => 'ProyeksiAppUrl',
    req_override => OR_AUTHCFG,
    args_how => TAKE1,
    errmsg => 'URL of your (local) ProyeksiApp. (e.g. http://localhost/ or http://www.example.com/proyeksiapp/)',
  },
  {
    name => 'ProyeksiAppApiKey',
    req_override => OR_AUTHCFG,
    args_how => TAKE1,
  },
  {
    name => 'ProyeksiAppGitSmartHttp',
    req_override => OR_AUTHCFG,
    args_how => TAKE1,
  },
);

sub ProyeksiAppUrl { set_val('ProyeksiAppUrl', @_); }
sub ProyeksiAppApiKey { set_val('ProyeksiAppApiKey', @_); }

sub ProyeksiAppGitSmartHttp {
  my ($self, $params, $arg) = @_;
  $arg = lc $arg;

  if ($arg eq "yes" || $arg eq "true") {
    $self->{ProyeksiAppGitSmartHttp} = 1;
  } else {
    $self->{ProyeksiAppGitSmartHttp} = 0;
  }
}

sub trim {
  my $string = shift;
  $string =~ s/\s{2,}/ /g;
  return $string;
}

sub set_val {
  my ($key, $self, $parms, $arg) = @_;
  $self->{$key} = $arg;
}

Apache2::Module::add(__PACKAGE__, \@directives);

sub access_handler {
  my $r = shift;

  unless ($r->some_auth_required) {
   $r->log_reason("No authentication has been configured");
   return FORBIDDEN;
  }

  return OK
}

sub authen_handler {
  my $r = shift;

  my ($status, $password) = $r->get_basic_auth_pw();
  my $login = $r->user;

  return $status unless $status == OK;

  my $identifier = get_project_identifier($r);
  my $method = $r->method;

  if( is_access_allowed( $login, $password, $identifier, $method, $r ) ) {
    return OK;
  } else {
    $r->note_auth_failure();
    return AUTH_REQUIRED;
  }
}

# we send a request to the proyeksiapp sys api
# and use the user's given login and password for basic auth
# for accessing the proyeksiapp sys api an api key is needed
sub is_access_allowed {
  my $login = shift;
  my $password = shift;
  my $identifier = shift;
  my $method = shift;
  my $r = shift;

  my $cfg = Apache2::Module::get_config( __PACKAGE__, $r->server, $r->per_dir_config );

  my $key = $cfg->{ProyeksiAppApiKey};

  # Trim url base if users add trailing slash
  my $url_base = $cfg->{ProyeksiAppUrl};
  $url_base =~ s|/$||;

  my $proyeksiapp_url = "$url_base/sys/repo_auth";
  my $proyeksiapp_unparsed_uri = $r->unparsed_uri;
  my $proyeksiapp_location = $r->location;
  my $proyeksiapp_git_smart_http = 0;
  if (defined $cfg->{ProyeksiAppGitSmartHttp} and $cfg->{ProyeksiAppGitSmartHttp}) {
    $proyeksiapp_git_smart_http = 1;
  }

  my $proyeksiapp_req = POST $proyeksiapp_url , [
      repository => $identifier,
      key => $key,
      method => $method,
      location => $proyeksiapp_location,
      uri => $proyeksiapp_unparsed_uri,
      git_smart_http => $proyeksiapp_git_smart_http ];
  $proyeksiapp_req->authorization_basic( $login, $password );

  my $ua = LWP::UserAgent->new;
  my $response = $ua->request($proyeksiapp_req);

  unless($response->is_success()) {
    $r->log_error("Failed authorization for $login on $proyeksiapp_url: " . $response->status_line);
  }

  return $response->is_success();
}

sub get_project_identifier {
    my $r = shift;

    my $cfg = Apache2::Module::get_config(__PACKAGE__, $r->server, $r->per_dir_config);
    my $location = $r->location;
    $location =~ s/\.git$// if (defined $cfg->{ProyeksiAppGitSmartHttp} and $cfg->{ProyeksiAppGitSmartHttp});
    my ($identifier) = $r->uri =~ m{$location/*([^/.]+)};
    $identifier;
}

1;
