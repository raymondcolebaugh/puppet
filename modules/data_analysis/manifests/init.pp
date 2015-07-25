# Install various packages and python modules for data analysis
class data_analysis {
  $deps = ['gfortran', 'liblapack-dev']
  package {$deps:
    ensure => latest,
  }

  package {[
    'ipython3-notebook',
    'scilab-cli',
    'libfreetype6-dev',
    'weka']:
      ensure => latest,
  }

  package {[
    'numpy',
    'scipy',
    'pandas',
    'matplotlib']:
      ensure   => latest,
      provider => 'pip3',
      require  => Package[$deps],
  }
}
