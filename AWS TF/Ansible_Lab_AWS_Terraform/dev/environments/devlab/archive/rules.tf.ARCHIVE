#https://github.com/terraform-aws-modules/terraform-aws-security-group/blob/master/rules.tf
variable "rules" {
  description = "Map of known security group rules (define as 'name' = ['from port', 'to port', 'protocol', 'description'])"
  type        = map(list(any))

  # Protocols (tcp, udp, icmp, all - are allowed keywords) or numbers (from https://www.iana.org/assignments/protocol-numbers/protocol-numbers.xhtml):
  # All = -1, IPV4-ICMP = 1, TCP = 6, UDP = 17, IPV6-ICMP = 58
  default = {
    # Docker Swarm
    docker-swarm-mngmt-tcp   = [2377, 2377, "tcp", "Docker Swarm cluster management"]
    docker-swarm-node-tcp    = [7946, 7946, "tcp", "Docker Swarm node"]
    docker-swarm-node-udp    = [7946, 7946, "udp", "Docker Swarm node"]
    docker-swarm-overlay-udp = [4789, 4789, "udp", "Docker Swarm Overlay Network Traffic"]
    # DNS
    dns-udp = [53, 53, "udp", "DNS"]
    dns-tcp = [53, 53, "tcp", "DNS"]
    # NTP - Network Time Protocol
    ntp-udp = [123, 123, "udp", "NTP"]
    # HTTP
    http-80-tcp   = [80, 80, "tcp", "HTTP"]
    http-8080-tcp = [8080, 8080, "tcp", "HTTP"]
    # HTTPS
    https-443-tcp  = [443, 443, "tcp", "HTTPS"]
    https-8443-tcp = [8443, 8443, "tcp", "HTTPS"]
    # IPSEC
    ipsec-500-udp  = [500, 500, "udp", "IPSEC ISAKMP"]
    ipsec-4500-udp = [4500, 4500, "udp", "IPSEC NAT-T"]
    # Kubernetes
    kubernetes-api-tcp = [6443, 6443, "tcp", "Kubernetes API Server"]
    # LDAP
    ldap-tcp = [389, 389, "tcp", "LDAP"]
    # LDAPS
    ldaps-tcp = [636, 636, "tcp", "LDAPS"]
    # MySQL
    mysql-tcp = [3306, 3306, "tcp", "MySQL/Aurora"]
    # MSSQL Server
    mssql-tcp           = [1433, 1433, "tcp", "MSSQL Server"]
    mssql-udp           = [1434, 1434, "udp", "MSSQL Browser"]
    mssql-analytics-tcp = [2383, 2383, "tcp", "MSSQL Analytics"]
    mssql-broker-tcp    = [4022, 4022, "tcp", "MSSQL Broker"]
    # NFS/EFS
    nfs-tcp = [2049, 2049, "tcp", "NFS/EFS"]
    # PostgreSQL
    postgresql-tcp = [5432, 5432, "tcp", "PostgreSQL"]
    # Oracle Database
    oracle-db-tcp = [1521, 1521, "tcp", "Oracle"]
    # RDP
    rdp-tcp = [3389, 3389, "tcp", "Remote Desktop"]
    rdp-udp = [3389, 3389, "udp", "Remote Desktop"]
    # SMTP
    smtp-tcp                 = [25, 25, "tcp", "SMTP"]
    smtp-submission-587-tcp  = [587, 587, "tcp", "SMTP Submission"]
    smtp-submission-2587-tcp = [2587, 2587, "tcp", "SMTP Submission"]
    smtps-465-tcp            = [465, 465, "tcp", "SMTPS"]
    smtps-2456-tcp           = [2465, 2465, "tcp", "SMTPS"]
    # Solr
    solr-tcp = [8983, 8987, "tcp", "Solr"]
    # Splunk
    splunk-indexer-tcp = [9997, 9997, "tcp", "Splunk indexer"]
    splunk-web-tcp     = [8000, 8000, "tcp", "Splunk Web"]
    splunk-splunkd-tcp = [8089, 8089, "tcp", "Splunkd"]
    splunk-hec-tcp     = [8088, 8088, "tcp", "Splunk HEC"]
    # Squid
    squid-proxy-tcp = [3128, 3128, "tcp", "Squid default proxy"]
    # SSH
    ssh-tcp = [22, 22, "tcp", "SSH"]
    # WinRM
    winrm-http-tcp  = [5985, 5985, "tcp", "WinRM HTTP"]
    winrm-https-tcp = [5986, 5986, "tcp", "WinRM HTTPS"]
    # Open all ports & protocols
    all-all       = [-1, -1, "-1", "All protocols"]
    all-tcp       = [0, 65535, "tcp", "All TCP ports"]
    all-udp       = [0, 65535, "udp", "All UDP ports"]
    all-icmp      = [-1, -1, "icmp", "All IPV4 ICMP"]
    all-ipv6-icmp = [-1, -1, 58, "All IPV6 ICMP"]
    # This is a fallback rule to pass to lookup() as default. It does not open anything, because it should never be used.
    _ = ["", "", ""]
  }
}

variable "auto_groups" {
  description = "Map of groups of security group rules to use to generate modules (see update_groups.sh)"
  type        = map(map(list(string)))

  # Valid keys - ingress_rules, egress_rules, ingress_with_self, egress_with_self
  default = {
    docker-swarm = {
      ingress_rules     = ["docker-swarm-mngmt-tcp", "docker-swarm-node-tcp", "docker-swarm-node-udp", "docker-swarm-overlay-udp"]
      ingress_with_self = ["all-all"]
      egress_rules      = ["all-all"]
    }
    http-80 = {
      ingress_rules     = ["http-80-tcp"]
      ingress_with_self = ["all-all"]
      egress_rules      = ["all-all"]
    }
    http-8080 = {
      ingress_rules     = ["http-8080-tcp"]
      ingress_with_self = ["all-all"]
      egress_rules      = ["all-all"]
    }
    https-443 = {
      ingress_rules     = ["https-443-tcp"]
      ingress_with_self = ["all-all"]
      egress_rules      = ["all-all"]
    }
    https-8443 = {
      ingress_rules     = ["https-8443-tcp"]
      ingress_with_self = ["all-all"]
      egress_rules      = ["all-all"]
    }
    ipsec-500 = {
      ingress_rules     = ["ipsec-500-udp"]
      ingress_with_self = ["all-all"]
      egress_rules      = ["all-all"]
    }
    ipsec-4500 = {
      ingress_rules     = ["ipsec-4500-udp"]
      ingress_with_self = ["all-all"]
      egress_rules      = ["all-all"]
    }
    kubernetes-api = {
      ingress_rules     = ["kubernetes-api-tcp"]
      ingress_with_self = ["all-all"]
      egress_rules      = ["all-all"]
    }
    ldap = {
      ingress_rules     = ["ldap-tcp"]
      ingress_with_self = ["all-all"]
      egress_rules      = ["all-all"]
    }
    ldaps = {
      ingress_rules     = ["ldaps-tcp"]
      ingress_with_self = ["all-all"]
      egress_rules      = ["all-all"]
    }
    mysql = {
      ingress_rules     = ["mysql-tcp"]
      ingress_with_self = ["all-all"]
      egress_rules      = ["all-all"]
    }
    mssql = {
      ingress_rules     = ["mssql-tcp", "mssql-udp", "mssql-analytics-tcp", "mssql-broker-tcp"]
      ingress_with_self = ["all-all"]
      egress_rules      = ["all-all"]
    }
    nfs = {
      ingress_rules     = ["nfs-tcp"]
      ingress_with_self = ["all-all"]
      egress_rules      = ["all-all"]
    }
    postgresql = {
      ingress_rules     = ["postgresql-tcp"]
      ingress_with_self = ["all-all"]
      egress_rules      = ["all-all"]
    }
    oracle-db = {
      ingress_rules     = ["oracle-db-tcp"]
      ingress_with_self = ["all-all"]
      egress_rules      = ["all-all"]
    }
    ntp = {
      ingress_rules     = ["ntp-udp"]
      ingress_with_self = ["all-all"]
      egress_rules      = ["all-all"]
    }
    rdp = {
      ingress_rules     = ["rdp-tcp", "rdp-udp"]
      ingress_with_self = ["all-all"]
      egress_rules      = ["all-all"]
    }
    smtp = {
      ingress_rules     = ["smtp-tcp"]
      ingress_with_self = ["all-all"]
      egress_rules      = ["all-all"]
    }
    smtp-submission = {
      ingress_rules     = ["smtp-submission-587-tcp", "smtp-submission-2587-tcp"]
      ingress_with_self = ["all-all"]
      egress_rules      = ["all-all"]
    }
    smtps = {
      ingress_rules     = ["smtps-465-tcp", "smtps-2465-tcp"]
      ingress_with_self = ["all-all"]
      egress_rules      = ["all-all"]
    }
    solr = {
      ingress_rules     = ["solr-tcp"]
      ingress_with_self = ["all-all"]
      egress_rules      = ["all-all"]
    }
    splunk = {
      ingress_rules     = ["splunk-indexer-tcp", "splunk-clients-tcp", "splunk-splunkd-tcp", "splunk-hec-tcp"]
      ingress_with_self = ["all-all"]
      egress_rules      = ["all-all"]
    }
    squid = {
      ingress_rules     = ["squid-proxy-tcp"]
      ingress_with_self = ["all-all"]
      egress_rules      = ["all-all"]
    }
    ssh = {
      ingress_rules     = ["ssh-tcp"]
      ingress_with_self = ["all-all"]
      egress_rules      = ["all-all"]
    }
    web = {
      ingress_rules     = ["http-80-tcp", "http-8080-tcp", "https-443-tcp", "web-jmx-tcp"]
      ingress_with_self = ["all-all"]
      egress_rules      = ["all-all"]
    }
    winrm = {
      ingress_rules     = ["winrm-http-tcp", "winrm-https-tcp"]
      ingress_with_self = ["all-all"]
      egress_rules      = ["all-all"]
    }
  }
}