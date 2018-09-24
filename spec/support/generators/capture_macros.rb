module Generators
  module CaptureMacros
    def capture
      $stdout = StringIO.new
      yield if block_given?
      output = $stdout.string
      $stdout = STDOUT
      output.each_line.map(&:strip)
    end
  end
end
