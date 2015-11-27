node /gregpublisher/ inherits base {
    $publisher = hiera("publisher")
      class { "greg::publisher":
        offset                          => $publisher[offset],
        depsync                         => $publisher[depsync],
        local_member_port               => $publisher[local_member_port],
        clustering                      => $publisher[clustering],
        membershipScheme                => $publisher[membershipScheme],
        cluster_domain                  => $publisher[cluster_domain],
        sub_cluster_domain              => $publisher[sub_cluster_domain],
        members                         => $publisher[members],
        port_mapping                    => $publisher[port_mapping],
        stage                           => $publisher[stage],
    }
}

node /gregstore/ inherits base {
  $store = hiera("store")
      class { "greg::apistore":
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
