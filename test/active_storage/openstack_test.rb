require "test_helper"

class Activestorage::OpenstackTest < ActiveSupport::TestCase
  test "has version number" do
    refute_nil ::ActiveStorage::Openstack::VERSION
  end
end
