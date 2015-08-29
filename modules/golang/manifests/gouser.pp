# Enable Go for a UNIX user
define golang::gouser {
  file {"/home/${title}/go":
    ensure => directory,
    mode   => '0750',
    owner  => $title,
    group  => $title,
  }

  exec {"echo 'export GOPATH=/home/${title}/go' >> /home/${title}/.bashrc":
    unless => "grep GOPATH /home/${title}/.bashrc",
  }
}
