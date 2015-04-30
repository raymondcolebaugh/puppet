class data_analysis {
  $deps = ['gfortran', 'liblapack-dev']
  package {$deps:
    ensure => latest,
  }

  package {[
    'ipython3-notebook',
    'scilab-cli',
    'weka']:
      ensure => latest,
  }

  package {[
    'numpy',
    'scipy']:
      provider => 'pip3',
      ensure   => latest,
      require  => Package[$deps],
  }
}
