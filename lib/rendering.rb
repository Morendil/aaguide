# The gem "sinatra-mustache", incorporated here for bugfix reasons

require 'sinatra'
require 'tilt'
require 'mustache'
require 'yaml'

module Tilt
  class MustacheTemplate < Template
    def initialize_engine
      return if defined? ::Mustache
      require_template_library 'mustache'
    end

    def prepare
      ::Mustache.template_path = file.gsub(File.basename(file), '') if file
      @engine = ::Mustache.new
      @output = nil
    end

    def evaluate(scope, locals, &block)
      if data =~ /^(\s*---(.+)---\s*)/m
        yaml = $2.strip
        template = data.sub($1, '')

        YAML.each_document(yaml) do |front_matter|
          # allows partials to override locals defined higher up
          front_matter.delete_if { |key,value| locals.has_key?(key)}
          locals.merge!(front_matter)
        end
      else
        template = data
      end

      scope.instance_variables.each do |instance_variable|
        symbol = instance_variable.to_s.gsub('@','').to_sym

        if ! locals[symbol]
          locals[symbol] = scope.instance_variable_get(instance_variable)
        end
      end

      locals[:yield] = block.nil? ? '' : yield
      locals[:content] = locals[:yield]

      # Force encoding to work around a bug in tilt 1.2.2
      @output = ::Mustache.render(template.force_encoding("UTF-8"), locals)
    end
  end
  register 'mustache', MustacheTemplate
end

module Sinatra
  class Base
    # Workaround for a bug hindering "template chaining" (see below)
    alias :old_render :render
    def render(engine, data, options={}, locals={}, &block)
      old_render(engine,data,options,locals,&block).tap {@default_layout = nil}
    end
  end

  module Templates 
    def mustache(template, options={}, locals={})
      render :mustache, template, options, locals 
    end
  end
end

