#
include '::mysql::server'

class cleandb::mysql($apim_version, $user, $password, $host)
{

#staging::deploy { "wso2am-${apim_version}.zip":
#  source        => "puppet:///files/packs/apimanager/${apim_version}/wso2am-${apim_version}.zip",
#  target        => '/mnt/',
#}

file { "/mnt/wso2am-${apim_version}.zip":
    source => "puppet:///files/packs/apimanager/${apim_version}/wso2am-${apim_version}.zip",
    recurse => true,   
}
->
exec { "extracting_wso2am-${apim_version}.zip_for_${name}":
      path      => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
      cwd       => '/mnt',
      unless    => "test -d /mnt/wso2am-${apim_version}/repository",
      command   => "unzip /mnt/wso2am-${apim_version}.zip",
      logoutput => 'on_failure',
      creates   => "/mnt/wso2am-${apim_version}/repository",
      timeout   => 0,
}
->
exec { "delete-db":
  command 	=> "/usr/bin/mysql -u$user -p$password  -e \"DROP DATABASE IF EXISTS apimgtdb;DROP DATABASE IF EXISTS regdb;DROP DATABASE IF EXISTS userdb;DROP DATABASE IF EXISTS statsdb;\"",
}
->
mysql::db { 'apimgtdb':
    charset	=> 'latin1',
    collate	=> 'latin1_swedish_ci',
    user	=> $user,
    password 	=> $password,
    host     	=> $host,
    sql 	=> "/mnt/wso2am-${apim_version}/dbscripts/apimgt/mysql.sql",
 }

notify {"API manager version ${apim_version} ": }

mysql::db { 'userdb':
    user  	=> $user,
    password 	=> $password,
    host     	=> $host,
    sql 	=> "/mnt/wso2am-${apim_version}/dbscripts/mysql.sql",
 }

mysql::db { 'regdb':
    user  	=> $user,
    password 	=> $password,
    host     	=> $host,
    sql 	=> "/mnt/wso2am-${apim_version}/dbscripts/mysql.sql",
 }

mysql::db { 'statsdb':
    user        => $user,
    password    => $password,
    host        => $host,
 }

}
