# require 'rubygems'
require 'rbench'

require 'active_record'
ActiveRecord::Base.establish_connection(
  :adapter => "sqlite3",
  :database  => ":memory:"
)
ActiveRecord::Base.connection.execute("CREATE TABLE active_record_models (id INTEGER UNIQUE, title STRING, text STRING)")


class ActiveRecordModel < ActiveRecord::Base; end
# Have AR scan the table before the benchmark
ActiveRecordModel.new

class PlainModel
  attr_accessor :id, :title, :text

  def initialize(attrs = {})
    attrs.each{|attr, value| setter = "#{attr}="; self.send(setter, value) if self.respond_to?(setter) }
    self
  end
end

ATTRS = {:id => 1, :title => "Foo", :text => "Bar"}

RBench.run(100_000) do

  column :times
  column :plain,       :title => "Class"
  column :hash,        :title => "Hash"
  column :ar,          :title => "AR #{ActiveRecord::VERSION::STRING}"
  column :ar2,         :title => "AR no protection"

  report ".new()" do
    plain do
      PlainModel.new
    end
    hash do
      Hash.new
    end
    ar do
      ActiveRecordModel.new
    end
    ar2 do
      ActiveRecordModel.new nil, :without_protection => true
    end

  end

  report ".new(#{ATTRS.inspect})" do
    plain do
      PlainModel.new ATTRS
    end
    hash do
      Hash.new ATTRS
    end
    ar do
      ActiveRecordModel.new ATTRS
    end
    ar2 do
      ActiveRecordModel.new ATTRS, :without_protection => true
    end
  end
end
