#encoding: UTF-8

# Whenever we include a Grape::API app and
# mount it via the official Padrino mounting
# mechanism, it is automatically wrapped in
# the ApplicationWrapper. This gives us a
# lot of functionality and should be consulted
# to understand what this is doing.
#   https://github.com/padrino/padrino-framework/blob/master/padrino-core/lib/padrino-core/mounter.rb
#
# The downside is that we have to clone a lot of
# those methods, because it's a wrapper
#
# There is also the reloader, that we need
# to play nice with as a project.
#
#  https://github.com/padrino/padrino-framework/blob/master/padrino-core/lib/padrino-core/reloader.rb
#

module PadrinoGrape
  module Extend
    def reload?
      true
    end

    def setup_padrino_application(options)
      Grape::API.logger = Padrino.logger
    end

    def reload
      ""
    end

    def call(env)
      if Padrino::Reloader.changed?
        reload!
      end
      super(env)
    end

    def reload!
      self.reset!
      @padrino_wrapper.require_dependencies
    end

    # The default application writer (as of this)
    # change, currently has a misnamed method.
    # here, we alias it to make it work correctly.
    #def prerequisites
    #  dependencies
    #end
  end

  def self.extended base
    base.__send__ :extend, ::PadrinoGrape::Extend
    #base.__send__ :setup_application!
  end

  def self.included base
    base.__send__ :extend, ::PadrinoGrape::Extend
    #base.__send__ :setup_application!
  end

end
