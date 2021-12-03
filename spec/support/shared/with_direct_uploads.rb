#-- encoding: UTF-8



class WithDirectUploads
  attr_reader :context

  def initialize(context)
    @context = context
  end

  ##
  # We need this so calls to rspec mocks (allow, expect etc.) will work here as expected.
  def method_missing(method, *args, &block)
    if context.respond_to?(method)
      context.send method, *args, &block
    else
      super
    end
  end

  def before(example)
    stub_config example

    mock_attachment
    stub_frontend redirect: redirect?(example) if stub_frontend?(example)

    stub_uploader
  end

  def stub_frontend?(example)
    example.metadata[:js]
  end

  def redirect?(example)
    example.metadata[:with_direct_uploads] == :redirect
  end

  def around(example)
    example.metadata[:driver] = :chrome_billy

    csp_config = SecureHeaders::Configuration.instance_variable_get("@default_config").csp
    csp_config.connect_src = ["'self'", "test-bucket.s3.amazonaws.com"]
    csp_config.form_action = ["'self'", "test-bucket.s3.amazonaws.com"]

    begin
      example.run
    ensure
      csp_config.connect_src = %w('self')
      csp_config.form_action = %w('self')
    end
  end

  def mock_attachment
    allow_any_instance_of(::Attachments::PrepareUploadService)
      .to receive(:instance) do
      # We don't use create here because this would cause an infinite loop as FogAttachment's #create
      # uses the base class's #create which is what we are mocking here. All this is necessary to begin
      # with because the Attachment class is initialized with the LocalFileUploader before this test
      # is ever run and we need remote attachments using the FogFileUploader in this scenario.
      FogAttachment.new
    end

    # This is so the uploaded callback works. Since we can't actually substitute the Attachment class
    # used there we get a LocalFileUploader file for the attachment which is not readable when
    # everything else is mocked to be remote.
    allow_any_instance_of(FileUploader).to receive(:readable?).and_return true
  end

  def stub_frontend(redirect: false)
    proxy.stub("https://" + ProyeksiApp::Configuration.remote_storage_upload_host + ":443/", method: 'options').and_return(
      headers: {
        'Access-Control-Allow-Methods' => 'POST',
        'Access-Control-Allow-Origin' => '*'
      },
      code: 200
    )

    if redirect
      stub_with_redirect
    else # use status response instead of redirect by default
      stub_with_status
    end
  end

  def stub_with_redirect
    proxy
      .stub("https://" + ProyeksiApp::Configuration.remote_storage_upload_host + ":443/", method: 'post')
      .and_return(Proc.new do |_params, _headers, body, _url, _method|
        key = body.scan(/key"\s*([^\s]+)\s/m).flatten.first
        redirect_url = body.scan(/success_action_redirect"\s*(http[^\s]+)\s/m).flatten.first
        ok = body =~ /X-Amz-Signature/ # check that the expected post to AWS was made with the form fields

        {
          code: ok ? 302 : 403,
          headers: {
            'Location' => ok ? redirect_url + '?key=' + CGI.escape(key) : nil,
            'Access-Control-Allow-Methods' => 'POST',
            'Access-Control-Allow-Origin' => '*'
          }
        }
      end)
  end

  def stub_with_status
    proxy
      .stub("https://" + ProyeksiApp::Configuration.remote_storage_upload_host + ":443/", method: 'post')
      .and_return(Proc.new do |_params, _headers, body, _url, _method|
        {
          code: body =~ /X-Amz-Signature/ ? 201 : 403, # check that the expected post to AWS was made with the form fields
          headers: {
            'Access-Control-Allow-Methods' => 'POST',
            'Access-Control-Allow-Origin' => '*'
          }
        }
      end)
  end

  def stub_uploader
    creds = config[:fog][:credentials]

    allow_any_instance_of(FogFileUploader).to receive(:fog_credentials).and_return creds

    allow_any_instance_of(FogFileUploader).to receive(:aws_access_key_id).and_return creds[:aws_access_key_id]
    allow_any_instance_of(FogFileUploader).to receive(:aws_secret_access_key).and_return creds[:aws_secret_access_key]
    allow_any_instance_of(FogFileUploader).to receive(:provider).and_return creds[:provider]
    allow_any_instance_of(FogFileUploader).to receive(:region).and_return creds[:region]
    allow_any_instance_of(FogFileUploader).to receive(:directory).and_return config[:fog][:directory]

    allow(ProyeksiApp::Configuration).to receive(:direct_uploads?).and_return(true)
  end

  def stub_config(example)
    WithConfig.new(context).before example, config
  end

  def config
    {
      attachments_storage: :fog,
      fog: {
        directory: MockCarrierwave.bucket,
        credentials: MockCarrierwave.credentials
      }
    }
  end
end

RSpec.configure do |config|
  config.before(:each) do |example|
    next unless example.metadata[:with_direct_uploads]

    WithDirectUploads.new(self).before example

    class FogAttachment < Attachment
      # Remounting the uploader overrides the original file setter taking care of setting,
      # among other things, the content type. So we have to restore that original
      # method this way.
      # We do this in a new, separate class, as to not interfere with any other specs.
      alias_method :set_file, :file=
      mount_uploader :file, FogFileUploader
      alias_method :file=, :set_file
    end
  end

  config.around(:each) do |example|
    enabled = example.metadata[:with_direct_uploads]

    if enabled
      WithDirectUploads.new(self).around example
    else
      example.run
    end
  end
end
