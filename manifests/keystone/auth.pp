# == Class: vitrage::keystone::auth
#
# Configures vitrage user, service and endpoint in Keystone.
#
# === Parameters
#
# [*password*]
#   (required) Password for vitrage user.
#
# [*auth_name*]
#   Username for vitrage service. Defaults to 'vitrage'.
#
# [*email*]
#   Email for vitrage user. Defaults to 'vitrage@localhost'.
#
# [*tenant*]
#   Tenant for vitrage user. Defaults to 'services'.
#
# [*configure_endpoint*]
#   Should vitrage endpoint be configured? Defaults to 'true'.
#
# [*configure_user*]
#   (Optional) Should the service user be configured?
#   Defaults to 'true'.
#
# [*configure_user_role*]
#   (Optional) Should the admin role be configured for the service user?
#   Defaults to 'true'.
#
# [*service_type*]
#   Type of service. Defaults to 'root_cause_analysis_engine'.
#
# [*region*]
#   Region for endpoint. Defaults to 'RegionOne'.
#
# [*service_name*]
#   (optional) Name of the service.
#   Defaults to the value of auth_name.
#
# [*public_url*]
#   (optional) The endpoint's public url. (Defaults to 'http://127.0.0.1:8999/v1')
#   This url should *not* contain any trailing '/'.
#
# [*admin_url*]
#   (optional) The endpoint's admin url. (Defaults to 'http://127.0.0.1:8999/v1')
#   This url should *not* contain any trailing '/'.
#
# [*internal_url*]
#   (optional) The endpoint's internal url. (Defaults to 'http://127.0.0.1:8999/v1')
#
class vitrage::keystone::auth (
  $password,
  $auth_name           = 'vitrage',
  $email               = 'vitrage@localhost',
  $tenant              = 'services',
  $configure_endpoint  = true,
  $configure_user      = true,
  $configure_user_role = true,
  $service_name        = undef,
  $service_type        = 'root_cause_analysis_engine',
  $region              = 'RegionOne',
  $public_url          = 'http://127.0.0.1:8999/v1',
  $admin_url           = 'http://127.0.0.1:8999/v1',
  $internal_url        = 'http://127.0.0.1:8999/v1',
) {

  $real_service_name    = pick($service_name, $auth_name)

  if $configure_user_role {
    Keystone_user_role["${auth_name}@${tenant}"] ~> Service <| name == 'vitrage-server' |>
  }
  Keystone_endpoint["${region}/${real_service_name}"]  ~> Service <| name == 'vitrage-server' |>

  keystone::resource::service_identity { 'vitrage':
    configure_user      => $configure_user,
    configure_user_role => $configure_user_role,
    configure_endpoint  => $configure_endpoint,
    service_name        => $real_service_name,
    service_type        => $service_type,
    service_description => 'vitrage Root Cause Analysis engine Service',
    region              => $region,
    auth_name           => $auth_name,
    password            => $password,
    email               => $email,
    tenant              => $tenant,
    public_url          => $public_url,
    internal_url        => $internal_url,
    admin_url           => $admin_url,
  }

}