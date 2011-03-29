class Organization
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  attr_reader :id
  attr_accessor :key, :name

  validates_presence_of :key
  validates_format_of :name, 
    :with => /\A[^\/#]*\Z/, 
    :message => 'cannot contain / or #'

  def initialize(hash)
    @id = hash['id']
    @key = hash['key']
    @name = hash['displayName'] || hash['name']
  end

  def persisted?
    false
  end
end
