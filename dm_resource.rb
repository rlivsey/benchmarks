require 'rubygems'
require 'rbench'

require 'dm-core'
DataMapper.setup(:default, 'sqlite::memory:')

class DMPost
  include DataMapper::Resource

  property :id,         Serial
  property :title,      String
  property :text,       String
end
DataMapper.finalize
