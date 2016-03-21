# Install Mumble client for voice chat
class mumble::client {
  package {'mumble': ensure => latest}
}
