class Organization < CandlepinObject
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  self.element_name = "owner"
  #self.attrs :key, :displayName, :upstreamUuid

#  attr_reader :id
#  attr_accessor :key, :displayName

  validates_presence_of :key
  validates_format_of :displayName,
    :with => /\A[^\/#]*\Z/, 
    :message => 'cannot contain / or #'


#  def initialize(hash)
#    @id = hash['id']
#    @key = hash['key']
#    @name = hash['displayName'] || hash['name']
#  end


  def id
    return self.key
  end

end
