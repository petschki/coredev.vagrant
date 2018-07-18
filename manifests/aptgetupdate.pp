class aptgetupdate {

  # add repository for python 3.6/3.7
  exec { 'add-apt-repository':
    command => '/usr/bin/add-apt-repository -y ppa:deadsnakes/ppa'
  }

  # This apt-get update below is meant to ward
  # off "Unable to fetch some archives, maybe run apt-get update or try with --fix-missing?"
  # errors.
  exec { 'apt-get update':
    command => '/usr/bin/apt-get update',
    unless => "/usr/bin/test -d Plone"
  }

}

include aptgetupdate
