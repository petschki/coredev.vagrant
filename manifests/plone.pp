class plone {

  package { "build-essential":
    ensure => present,
  }
  package { "python-virtualenv":
    ensure => present,
  }
  package { "zlib1g-dev":
    ensure => present,
  }
  package { "libssl-dev":
    ensure => present,
  }
  package { "libjpeg-dev":
    ensure => present,
  }
  package { "libxml2-dev":
    ensure => present,
  }
  package { "libxslt-dev":
    ensure => present,
  }
  package { "libpcre++-dev":
    ensure => present,
  }

  # coredev dependencies
  package { "subversion":
    ensure => present,
  }
  package { "git":
    ensure => present,
  }
  package { "python-pip":
    ensure => present,
  }

  # python 3.6
  package { "python3.6":
    ensure => present,
  }
  package { "python3.6-dev":
    ensure => present,
  }

  # transform utilities
  # htmlto<xxx>
  package { "poppler-utils":
    ensure => present,
  }
  # wvHtml
  package { "wv":
    ensure => present,
  }
 # lynx
  package { "lynx":
    ensure => present,
  }

  # used for creating a PuTTy-compatible key file
  package { "putty-tools":
    ensure => present,
  }

}

include plone
