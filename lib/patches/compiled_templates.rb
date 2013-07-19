# Rails 2.3.5, Ruby 1.9. ERB returns templates with an ASCII-8BIT encoding, unless they contain
# an unicode character, and when you render a partial with unicode chars into a layout without,
# the infamous "incompatible character encodings: ASCII-8BIT and UTF-8" error comes out.
#
# This module monkey-patches module_eval into the ActionView::Base::CompiledTemplates module to
# convert the first argument encoding to UTF-8, if needed.
#
# Put it into lib/patches/compiled_templates.rb and require it into the config.after_initialize
# block of your environment.rb.
#
# LH ticket x-reference: https://rails.lighthouseapp.com/projects/8994/tickets/2188
#
# - vjt@openssl.it
#
module Patches
  module CompiledTemplates
    def self.extended(base)
      base.metaclass.alias_method_chain(:module_eval, :utf8)
    end
 
    def module_eval_with_utf8(*args, &block)
      if args.first.respond_to?(:encoding) && args.first.encoding != Encoding::UTF_8
        args.first.force_encoding(Encoding::UTF_8)
      end
      module_eval_without_utf8(*args, &block)
    end
  end
 
  begin
    RUBY_VERSION.to_f >= 1.9 &&
      ActionView::Base::CompiledTemplates.method(:module_eval_with_utf8)
  rescue NameError
    ActionView::Base::CompiledTemplates.extend Patches::CompiledTemplates
  end
end