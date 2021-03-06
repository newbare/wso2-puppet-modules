#

class wso2base::params {

    $domain               = "example.com"
    $package_repo         = "http://downloads.${domain}"
    $depsync_svn_repo     = "http://svn.${domain}/svn/amdepsync"
    $local_package_dir    = "/mnt/packs"

    # Java
    $java_home  = "jdk1.7.0_79"
    $package    = "jdk-7u79-linux-x64.gz"
    $java_dir   = '/opt'

    # users
    $owner = 'wso2user'
    $group = 'wso2user'

    # maven
    $maven_package  ="apache-maven-3.0.5-bin.tar.gz"
    $maven_dir      ="apache-maven-3.0.5" 

    # Service subdomains
    $am_subdomain         = 'api'
    $elb_subdomain        = 'elb'
    $gateway_subdomain    = 'gateway'
    $keymanager_subdomain = 'keymanager'
    $apistore_subdomain   = 'apistore'
    $publisher_subdomain  = 'publisher'
    $management_subdomain = 'mgt'
    
    $depsync_svn_user     = 'wso2'
    $depsync_svn_password = 'wso2123'
    
}
