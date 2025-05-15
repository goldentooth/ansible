agent_prefix "" {
  policy = "read"
}

node_prefix "" {
  policy = "write"
}

service_prefix "" {
  policy = "write"
}

acl  = "write"
mesh = "write"

namespace "nomad" {
  acl = "write"

  key_prefix "" {
    policy = "read"
  }

  node_prefix "" {
    policy = "read"
  }

  service_prefix "" {
    policy = "write"
  }
}