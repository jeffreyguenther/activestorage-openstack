require "fog/openstack"

class ActiveStorage::Service::OpenStackService < ActiveStorage::Service
  attr_reader :client, :container

  def initialize(container:, credentials:, connection_options: {})
    if connection_options.present?
      settings = credentials.reverse_merge({connection_options: connection_options})
    else
      settings = credentials
    end

    @client = Fog::Storage::OpenStack.new(settings)
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
        # FIXME: Stream the download
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
      generated_url = file_for(key).url(expire_at)

      payload[:url] = generated_url

      generated_url
    end
  end

  def url_for_direct_upload(key, expires_in:, content_type:, content_length:)
    instrument :url, key do |payload|
      expire_at = unix_timestamp_expires_at(expires_in)
      generated_url = client.create_temp_url(container.key, key, expire_at, "PUT")

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
