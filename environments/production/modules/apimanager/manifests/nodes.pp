#
# API Manager - Publisher node definition
#
node /apim_publisher/ inherits base {
    $publisher = hiera("publisher")
      class { "apimanager::publisher":
        offset                          => $publisher[offset],
        depsync                         => $publisher[depsync],
        local_member_port               => $publisher[local_member_port],
        clustering                      => $publisher[clustering],
        membershipScheme                => $publisher[membershipScheme],
        cloud                           => $publisher[cloud],
        cluster_domain                  => $publisher[cluster_domain],
        sub_cluster_domain              => $publisher[sub_cluster_domain],
        members                         => $publisher[members],
        port_mapping                    => $publisher[port_mapping],
        stage                           => $publisher[stage],
    }
}

#
# API Manager - Pubstore node definition
# Publisher + apistore in one node
# This node definition should come before /store/ node definition,
# to capture the pubstore certname/hostname incoming agent requests first
#
node /apim_pubstore/ inherits base {
 $pubstore = hiera("pubstore")
      class { "apimanager::pubstore":
        offset                          => $pubstore[offset],
        local_member_port               => $pubstore[local_member_port],
        clustering                      => $pubstore[clustering],
        membershipScheme                => $pubstore[membershipScheme],
        cloud                           => $pubstore[cloud],
        sub_cluster_domain              => $pubstore[sub_cluster_domain],
        members                         => $pubstore[members],
        port_mapping                    => $pubstore[port_mapping],
        stage                           => $pubstore[stage],
    }
}

#
# API Manager - apistore node definition
# This should come after /pubstore/ node definition
#
node /apim_store/ inherits base {
  $store = hiera("store")
      class { "apimanager::apistore":
        offset                          => $store[offset],
        depsync                         => $store[depsync],
        local_member_port               => $store[local_member_port],
        clustering                      => $store[clustering],
        membershipScheme                => $store[membershipScheme],
        cloud                           => $store[cloud],
        cluster_domain                  => $store[cluster_domain],
        sub_cluster_domain              => $store[sub_cluster_domain],
        members                         => $store[members],
        port_mapping                    => $store[port_mapping],
        stage                           => $store[stage],
    }
}

#
# API Manager - Keymanager node definition
#
node /apim_keymanager/ inherits base {
    $keymanager = hiera("keymanager")
      class { "apimanager::keymanager":
        offset                          => $keymanager[offset],
        depsync                         => $keymanager[depsync],
        local_member_port               => $keymanager[local_member_port],
        clustering                      => $keymanager[clustering],
        membershipScheme                => $keymanager[membershipScheme],
        cloud                           => $keymanager[cloud],
        sub_cluster_domain              => $keymanager[sub_cluster_domain],
        members                         => $keymanager[members],
        port_mapping                    => $keymanager[port_mapping],
        stage                           => $keymanager[stage],
    }
}

#
# API Manager - Gateway node definition
# Node definition for gateway-manager and gateway-worker nodes
#
node /apim_gateway/ inherits base {
 $gateway = hiera("gateway")
      class { "apimanager::gateway":
        offset                          => $gateway[offset],
        depsync_enabled                 => $gateway[depsync_enabled],
        local_member_port               => $gateway[local_member_port],
        clustering                      => $gateway[clustering],
        membershipScheme                => $gateway[membershipScheme],
        cloud                           => $gateway[cloud],
        sub_cluster_domain              => $gateway[sub_cluster_domain],
        members                         => $gateway[members],
        port_mapping                    => $gateway[port_mapping],
        stage                           => $gateway[stage],
    }
}

