$LOAD_PATH << File.dirname(__FILE__)

require 'remote/response'
require 'remote/connection_error'

# load either foundation framework (macruby) or other frameworks
if defined?(RUBY_ENGINE) && RUBY_ENGINE == "macruby"
  framework 'foundation'
  require 'remote/macruby_connection'
elsif defined?(RUBY_ENGINE) && RUBY_ENGINE == "jruby"
  # not yet implemented...
  # require'remote/jruby_connection'
else
  # not yet implemented...
  # require'remote/mri_connection'
end

module Remote
  # generic remote stuff goes here...
end
