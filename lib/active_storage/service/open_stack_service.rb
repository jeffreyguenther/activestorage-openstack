require "fog/openstack"

class ActiveStorage::Service::OpenStackService < ActiveStorage::Service
  attr_reader :client, :container

  def initialize(container:, openstack_username:, openstack_api_key:, openstack_auth_url:, openstack_domain_id: "default", openstack_project_name:, openstack_temp_url_key:, connection_options: {})
    @client = Fog::Storage::OpenStack.new(
      openstack_auth_url: openstack_auth_url,
      openstack_username: openstack_username,
      openstack_api_key: openstack_api_key,
      openstack_project_name: openstack_project_name,
      openstack_domain_id: openstack_domain_id,
      openstack_temp_url_key: openstack_temp_url_key,
      connection_options: connection_options
    )
    @container = @client.directories.get(container)
  end

  def upload(key, io, checksum: nil)
    instrument :upload, key, checksum: checksum do
      # FIXME: Max file size is 5GB. If support for files
      # larger than that is desired, we have to
      # segment the upload.
      file = container.files.create(key: key, body: io, etag: checksum)
      file.reload

      if checksum.present? && convert_to_base64_digest(file.etag) != checksum
        file.destroy
        raise ActiveStorage::IntegrityError
      end
    end
  end

  def download(key)
    if block_given?
      instrument :streaming_download, key do
        # stream(key, &block)
        yield file_for(key).body
      end
    else
      instrument :download, key do
        file_for(key).body
      end
    end
  end

  def delete(key)
    instrument :delete, key do
      file_for(key).try(:destroy)
    end
  end

  def exist?(key)
    instrument :exist, key do |payload|
      answer = file_for(key).present?
      payload[:exist] = answer
      answer
    end
  end

  def url(key, expires_in:, disposition:, filename:, content_type:)
    instrument :url, key do |payload|
      expire_at = unix_timestamp_expires_at(expires_in)
      generated_url = file_for(key).url(expire_at,
        content_disposition: content_disposition_with(type: disposition, filename: filename),
        content_type: content_type
      )

      payload[:url] = generated_url

      generated_url
    end
  end

  def url_for_direct_upload(key, expires_in:, content_type:, content_length:)
    instrument :url, key do |payload|
      expire_at = unix_timestamp_expires_at(expires_in)
      generated_url = client.create_temp_url(container.key, key, expire_at, "PUT",
        content_disposition: content_disposition_with(type: disposition, filename: filename),
        content_type: content_type
      )

      payload[:url] = generated_url

      generated_url
    end
  end

  def headers_for_direct_upload(key, content_type:, content_length:, checksum:, **)
    {"Content-Type" => content_type, "Etag" => checksum, "Content-Length" => content_length}
  end

  private
    def unix_timestamp_expires_at(seconds_from_now)
      Time.current.advance(seconds: seconds_from_now).to_i
    end

    def file_for(key)
      container.files.get(key)
    end

    def stream(key, options = {}, &block)
      file_for(key) do | data, remaining, content_length |
        yield data
      end
    end

    def convert_to_base64_digest(hex_digest)
      [[hex_digest].pack("H*")].pack("m0")
    end
end
