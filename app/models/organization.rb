class Organization < Base
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  # Candlepin calls this resource an owner:
  self.element_name = "owner"

  # Candlepin API expects an owner key as the ID:
  self.primary_key = :key

  validates_presence_of :key
  validates_format_of :displayName,
    :with => /\A[^\/#]*\Z/,
    :message => 'cannot contain / or #'

  # ActiveResource assumes anything with an ID is a pre-existing
  # resource, ID in our case is key, and key is manually assigned at creation,
  # so we must override the new check to force active record to persist our
  # new org.
  def new?
    @attributes[:id].nil?
  end

  def import(manifest_zip_path)
    puts "Uploading manifest: #{manifest_zip_path}"

    # TODO: not sure why this isn't working! Part of the OAuth plugin should
    # let us do this:
    #
    #resp = Base.send_multipart_request(:post, "/candlepin/owners/#{key}/imports",
    #  [['export.zip', File.new(manifest_zip_path)]])
    #pp resp

    # Using the Candlepin API module until we can figure out the above:
    cp = Base.candlepin_api
    cp.import key, manifest_zip_path
  end


end
