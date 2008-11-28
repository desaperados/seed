require 'test/unit'
require 'FileUtils'

begin
  require File.dirname(__FILE__) + '/../../../../config/boot'
  require 'active_record'
rescue LoadError
  require 'rubygems'
  require_gem 'activerecord'
end

require 'active_record/fixtures'

require File.dirname(__FILE__) + '/../lib/acts_as_indexed'

ActiveRecord::Base.logger = Logger.new(File.dirname(__FILE__) + '/test.log')
ActiveRecord::Base.configurations = YAML::load(IO.read(File.dirname(__FILE__) + '/database.yml'))
ActiveRecord::Base.establish_connection(ENV['DB'] || 'mysql')

load(File.dirname(__FILE__) + '/schema.rb')

Test::Unit::TestCase.fixture_path = File.dirname(__FILE__) + '/fixtures/'
$LOAD_PATH.unshift(Test::Unit::TestCase.fixture_path)

class Test::Unit::TestCase #:nodoc:
  self.use_transactional_fixtures = true
  self.use_instantiated_fixtures  = false
  
  def destroy_index
    FileUtils::rm_rf(index_loc) if File.exists?(index_loc)
    assert !File.exists?(index_loc)
    true
  end
  
  def build_index
    # Makes a query to invoke the index build.
    assert_equal [], Post.find_with_index('badger')
    assert File.exists?(index_loc)
    true
  end
  
  protected
  
  def index_loc
    File.join(File.dirname(__FILE__),'index')
  end
  
end
