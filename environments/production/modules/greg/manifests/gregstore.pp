# ----------------------------------------------------------------------------
#  Copyright 2005-2013 WSO2, Inc. http://www.wso2.org
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.
# ----------------------------------------------------------------------------
#
# Class: greg
#
# This class installs WSO2 Governance Registry
#
# Parameters:
#  version            => '1.5.0',
#  offset             => 0,
#  config_database    => 'config',
#  maintenance_mode   => 'zero',
#  depsync_enabled    => false,
#  sub_cluster_domain => 'mgt',
#  clustering         => true,
#  cloud              => true,
#  gregtype           => 'gregstore',
#  owner              => 'root',
#  group              => 'root',
#  target             => '/mnt',
#  members            => {'192.168.18.122' => 4010 },
#  port_mapping       => { 8280 => 9763, 8243 => 9443 }
#
# Actions:
#   - Install WSO2 Governance Registry
#
# Requires:
#
# Sample Usage:
#

class greg::gregstore (
  $env                = undef,
  $cluster_domain     = undef,
  $sub_cluster_domain = undef,
  $local_member_port  = '4000',
  $members            = {'127.0.0.1' => '4000'},
  $port_mapping       = false,
  $offset             = 0,
  $config_database    = 'config',
  $depsync_enabled    = false,
  $clustering         = false,
  $cloud              = false,
  $target             = "/mnt/${ipaddress}/gregstore",
  $membershipScheme   = 'multicast',
  $carbon_hostname    = '127.0.0.1',
  $carbon_mgt_hostname = '127.0.0.1',
  $proxy_port_enabled = true,
  $http_proxy_port    = 80,
  $https_proxy_port   = 443,
) inherits params {

  $gregtype          = 'gregstore'
  $deployment_code = 'greg'
  $carbon_version  = $version
  $service_code    = 'greg'
  $carbon_home     = "${target}/wso2${service_code}-${carbon_version}"
  $is_lb_fronted   = true

  $service_templates = [
    'conf/axis2/axis2.xml',
    'conf/carbon.xml',
    'conf/datasources/master-datasources.xml',
    'conf/registry.xml',
    'conf/user-mgt.xml',
    'conf/tomcat/catalina-server.xml',
    'conf/identity/sso-idp-config.xml',
#    'conf/log4j.properties',
#    'conf/identity.xml',  # in APIM 1.10.0-SNAPSHOT this is located in conf/identity/identity.xml
#    'deployment/server/jaggeryapps/publisher/site/conf/site.json',
    'deployment/server/jaggeryapps/store/config/store.json',
    ]

  tag($service_code)

  greg::clean { "${deployment_code}_${gregtype}":
    mode   => $maintenance_mode,
    target => $carbon_home,
  }

  greg::initialize { "${deployment_code}_${gregtype}":
    repo      => $package_repo,
    version   => $carbon_version,
    service   => $service_code,
    local_dir => $local_package_dir,
    target    => $target,
    mode      => $maintenance_mode,
    owner     => $owner,
    require   => Greg::Clean["${deployment_code}_${gregtype}"],
  }

  greg::deploy { "${deployment_code}_${gregtype}":
    gregtype   => $gregtype,
    service  => $deployment_code,
    version  => $carbon_version,
    security => true,
    owner    => $owner,
    group    => $group,
    target   => $carbon_home,
    require  => Greg::Initialize["${deployment_code}_${gregtype}"],
  }

  if $sub_cluster_domain == 'worker' {
    greg::create_worker { "${deployment_code}_${gregtype}":
      target  => $carbon_home,
      require => Greg::Deploy["${deployment_code}_${gregtype}"],
    }
  }

  greg::push_gregstore_templates {
    $service_templates:
      target    => $carbon_home,
      directory => "${deployment_code}/${version}",
      owner     => $owner,
      group     => $group,
      require   => Greg::Deploy["${deployment_code}_${gregtype}"];
  }

  file {
    "${carbon_home}/bin/wso2server.sh":
      ensure    => present,
      owner     => $owner,
      group     => $group,
      mode      => '0755',
      content   => template("greg/${version}/wso2server.sh.erb"),
      require   => Greg::Deploy["${deployment_code}_${gregtype}"];
  }

    exec { "removing_store_app_for_store":
        path    => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
        command => "rm -rf ${carbon_home}/repository/deployment/server/jaggeryapps/publisher",
        require => Greg::Deploy["${deployment_code}_${gregtype}"],
    }

  greg::startservice { "${deployment_code}_${gregtype}":
    owner     => $owner,
    group     => $group,
    target    => $carbon_home,
    directory => "${deployment_code}/${version}",
    require   => [
      Greg::Initialize["${deployment_code}_${gregtype}"],
      Greg::Deploy["${deployment_code}_${gregtype}"],
      Greg::Push_gregstore_templates[$service_templates],
      File["${carbon_home}/bin/wso2server.sh"],
      ],
  }

  greg::conf_reset { "reset_puppet_agent_certname_in_conf_file" :
    require   => Greg::Startservice["${deployment_code}_${gregtype}"];
  }

}
