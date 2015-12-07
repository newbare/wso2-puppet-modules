node /greg_publisher/ inherits base {
    $publisher = hiera("publisher")
      class { "greg::gregpublisher":
        offset                          => $publisher[offset],
        depsync_enabled                 => $publisher[depsync_enabled],
        local_member_port               => $publisher[local_member_port],
        clustering                      => $publisher[clustering],
        membershipScheme                => $publisher[membershipScheme],
        cluster_domain                  => $publisher[cluster_domain],
        sub_cluster_domain              => $publisher[sub_cluster_domain],
        members                         => $publisher[members],
        port_mapping                    => $publisher[port_mapping],
        stage                           => $publisher[stage],
        carbon_hostname                 => $publisher[carbon_hostname],
        carbon_mgt_hostname             => $publisher[carbon_mgt_hostname],
        proxy_port_enabled              => $publisher[proxy_port_enabled],
        http_proxy_port                 => $publisher[http_proxy_port],
        https_proxy_port                => $publisher[https_proxy_port],
    }
}

node /greg_store/ inherits base {
  $store = hiera("store")
      class { "greg::gregstore":
        offset                          => $store[offset],
        depsync_enabled                 => $store[depsync_enabled],
        local_member_port               => $store[local_member_port],
        clustering                      => $store[clustering],
        membershipScheme                => $store[membershipScheme],
        cloud                           => $store[cloud],
        cluster_domain                  => $store[cluster_domain],
        sub_cluster_domain              => $store[sub_cluster_domain],
        members                         => $store[members],
        port_mapping                    => $store[port_mapping],
        stage                           => $store[stage],
        carbon_hostname                 => $store[carbon_hostname],
        carbon_mgt_hostname             => $store[carbon_mgt_hostname],
        proxy_port_enabled              => $store[proxy_port_enabled],
        http_proxy_port                 => $store[http_proxy_port],
        https_proxy_port                => $store[https_proxy_port],
    }
}
