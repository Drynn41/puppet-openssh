# @summary This class allow user to deliver a standard ssh config
#
# Find bellow a list of all usable variables for this module.
#
# @example
#   include openssh
# @param openssh_ports list of ssh port
# @param openssh_listenaddress default vars
# @param openssh_logingracetime default vars
# @param openssh_permitrootlogin default vars
# @param openssh_strictmodes default vars
# @param openssh_maxauthtries default vars
# @param openssh_maxsessions default vars
# @param openssh_pubkeyauthentification default vars
# @param openssh_permitemptypasswords default vars
# @param openssh_authorizedkeysfile default vars
# @param openssh_authorizedkeyscommand default vars
# @param openssh_authorizedkeyscommanduser default vars
# @param openssh_passwordauthentication default vars
# @param openssh_usepam default vars
# @param openssh_match default vars
#  openssh::openssh_match:
#  - type: User
#    lists: ['toto','tata']
#    options:
#      opt1: test1
#      opt2: test2
# @param openssh_package_list default vars
# @param openssh_config_file default vars
# @param openssh_config_file_owner default vars
# @param openssh_config_file_group default vars
# @param openssh_config_file_mode default vars
# @param openssh_template_path default vars
# @param openssh_service_name default vars
class openssh (
  Array     $openssh_ports                      = [22],
  String    $openssh_listenaddress              = '0.0.0.0',
  String    $openssh_logingracetime             = '30m',
  String    $openssh_permitrootlogin            = 'no',
  String    $openssh_strictmodes                = 'yes',
  Integer   $openssh_maxauthtries               = 4,
  Integer   $openssh_maxsessions                = 10,
  String    $openssh_pubkeyauthentification     = 'yes',
  String    $openssh_authorizedkeysfile         = '.ssh/authorized_keys',
  String    $openssh_authorizedkeyscommand      = '/usr/bin/sss_ssh_authorizedkeys',
  String    $openssh_authorizedkeyscommanduser  = 'root',
  String    $openssh_passwordauthentication     = 'no',
  String    $openssh_permitemptypasswords       = 'no',
  String    $openssh_usepam                     = 'yes',
  Array     $openssh_match                      = [],
  Array     $openssh_package_list               = ['openssh-server','openssh-clients'],
  String    $openssh_config_file                = '/etc/ssh/sshd_config',
  String    $openssh_config_file_owner          = 'root',
  String    $openssh_config_file_group          = 'root',
  String    $openssh_config_file_mode           = '0600',
  String    $openssh_template_path              = 'openssh/sshd_config.erb',
  String    $openssh_service_name               = 'sshd.service'
) {
  package { 'openssl':
    ensure => installed,
    #install_options => ['--enablerepo', 'company_repo'],
  }

  package { $openssh_package_list:
    ensure  => installed,
    #install_options => ['--enablerepo', 'company_repo'],
    require => Package['openssl'],
  }

  file { $openssh_config_file:
    ensure  => file,
    require => Package[$openssh_package_list],
    owner   => $openssh_config_file_owner,
    group   => $openssh_config_file_group,
    mode    => $openssh_config_file_mode,
    content => template($openssh_template_path),
  }

  service { $openssh_service_name:
    ensure    => running,
    subscribe => File[$openssh_config_file],
  }
}
