require 'radiotag-models'

require 'test/unit'
require 'shoulda'
require 'mocha'

DataMapper.setup(:default, "sqlite::memory:")
DataMapper.auto_migrate!

