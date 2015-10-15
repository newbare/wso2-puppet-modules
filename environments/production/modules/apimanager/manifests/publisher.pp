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
# Class: apimanager
#
# This class installs WSO2 API Manager
#
# Parameters:
#  version            => '1.5.0',
#  offset             => 0,
#  config_database          => 'config',
#  maintenance_mode   => 'zero',
#  depsync            => false,
#  sub_cluster_domain => 'mgt',
#  clustering         => true, 
#  cloud              => true,
#  amtype             => 'gateway',
#  owner              => 'root',
#  group              => 'root',
#  target             => '/mnt',
#  members            => {'192.168.18.122' => 4010 },
#  port_mapping       => { 8280 => 9763, 8243 => 9443 }
#
# Actions:
#   - Install WSO2 API Manager
#
# Requires:
#
# Sample Usage:
#

class apimanager::publisher (
  $version            = "1.9.0",
  $env                = undef,
  $cluster_domain     = undef,
  $sub_cluster_domain = undef,
  $local_member_port  = '4000',
  $members            = {'127.0.0.1' => '4000'},
  $port_mapping       = false,
  $offset             = 0,
  $config_database          = 'config',
  $maintenance_mode   = 'zero',
  $depsync            = false,
  $clustering         = false,
  $cloud              = false,
  $owner              = 'root',
  $group              = 'root',
  $target             = "/mnt/${ipaddress}/publisher",
  $membershipScheme   = 'multicast',
  $registry_db_connection_url      = undef,
  $registry_db_user                = undef,
  $registry_db_password            = undef,
  $registry_db_driver_name         = undef,
  $userstore_db_connection_url     = undef,
  $userstore_db_user               = undef,
  $userstore_db_password           = undef,
  $userstore_db_driver_name        = undef,
  $apim_db_connection_url          = undef,
  $apim_db_user                    = undef,
  $apim_db_password                = undef,
  $apim_db_driver_name             = undef,
) inherits params {

  $amtype          = 'publisher'
  $deployment_code = 'apimanager'
  $carbon_version  = $version
  $service_code    = 'am'
  $carbon_home     = "${target}/wso2${service_code}-${carbon_version}"
  $is_lb_fronted   = 'true'

  $service_templates = [
    'conf/api-manager.xml',
    'conf/axis2/axis2.xml',
    'conf/carbon.xml',
    'conf/datasources/master-datasources.xml',
    'conf/registry.xml',
    'conf/user-mgt.xml',
    'conf/tomcat/catalina-server.xml',
    'conf/log4j.properties',
    'deployment/server/jaggeryapps/publisher/site/conf/site.json',
#    'deployment/server/jaggeryapps/store/site/conf/site.json',
    ]

  tag($service_code)

  apimanager::clean { "${deployment_code}_${amtype}":
    mode   => $maintenance_mode,
    target => $carbon_home,
  }

  apimanager::initialize { "${deployment_code}_${amtype}":
    repo      => $package_repo,
    version   => $carbon_version,
    service   => $service_code,
    local_dir => $local_package_dir,
    target    => $target,
    mode      => $maintenance_mode,
    owner     => $owner,
    require   => Apimanager::Clean["${deployment_code}_${amtype}"],
  }

  apimanager::deploy { "${deployment_code}_${amtype}":
    amtype   => $amtype,
    service  => $deployment_code,
    version  => $carbon_version,
    security => true,
    owner    => $owner,
    group    => $group,
    target   => $carbon_home,
    require  => Apimanager::Initialize["${deployment_code}_${amtype}"],
  }

  if $sub_cluster_domain == 'worker' {
    apimanager::create_worker { "${deployment_code}_${amtype}":
      target  => $carbon_home,
      require => Apimanager::Deploy["${deployment_code}_${amtype}"],
    }
  }

  apimanager::push_publisher_templates {
    $service_templates:
      target    => $carbon_home,
      directory => "${deployment_code}/${version}",
      owner     => $owner,
      group     => $group,
      require   => Apimanager::Deploy["${deployment_code}_${amtype}"];
  }

  file {
    "${carbon_home}/bin/wso2server.sh":
      ensure    => present,
      owner     => $owner,
      group     => $group,
      mode      => '0755',
      content   => template("apimanager/${version}/wso2server.sh.erb"),
      require   => Apimanager::Deploy["${deployment_code}_${amtype}"];
  }

    exec { "removing_store_app_for_publisher":
        path    => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
        command  => "rm -rf $carbon_home/repository/deployment/server/jaggeryapps/store",
        require => Apimanager::Deploy["${deployment_code}_${amtype}"],
    }
 
  apimanager::startservice { "${deployment_code}_${amtype}":
    owner   => $owner,
    group   => $group,
    target  => $carbon_home,
    directory => "${deployment_code}/${version}",
    require => [
      Apimanager::Initialize["${deployment_code}_${amtype}"],
      Apimanager::Deploy["${deployment_code}_${amtype}"],
      Apimanager::Push_publisher_templates[$service_templates],
      File["${carbon_home}/bin/wso2server.sh"],
      ],
  }

  apimanager::conf_reset { "reset_puppet_agent_certname_in_conf_file" :
    require   => Apimanager::Startservice["${deployment_code}_${amtype}"];
  }

}
