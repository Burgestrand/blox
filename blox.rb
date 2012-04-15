# Call a callable with the Blox object and return the result.
#
# @param (see Blox.object)
# @return the result of the blox object
def Blox(block, name, *args, &extra)
  Blox.object(block, name, *args, &extra).__result__
end

# Call a callable and return the result, raising if the result is undefined.
#
# @raise [LocalJumpError] if none of the blocks was invoked
# @param (see Blox.object)
# @return the result of the blox object
def Blox!(block, name, *args, &extra)
  Blox.object(block, name, *args, &extra).__result__!
end

module Blox
  # @param (see Blox)
  # @return (see Blox)
  def yield_to(*args, &extra)
    Blox(self, *args, &extra)
  end

  # @param (see Blox!)
  # @return (see Blox!)
  def yield_to!(*args, &extra)
    Blox!(self, *args, &extra)
  end

  # Construct a Blox object with the given proc, and call it with the given arguments.
  #
  # @param [#call] block
  # @param [#to_s] name
  # @param *args any additional args to the multi-block
  # @return a blox object that responds to __result__ and __result__!
  def self.object(block, name, *args, &extra)
    blox_object = BasicObject.new

    (class << blox_object; self; end).instance_eval do
      define_method(:__result__) do
        @result
      end

      define_method(:__result__!) do
        unless defined?(@result)
          Kernel.raise LocalJumpError, "no block given for #{name}"
        end

        @result
      end

      define_method("#{name}?") do
        true
      end

      define_method(:method_missing) do |method_name = :method_missing, &handler|
        if name == method_name
          @result = handler.call(*args, &extra)
        end
      end
    end

    block.call(blox_object)
    blox_object
  end
end

Proc.send(:include, Blox)

if $0 == __FILE__
  require 'minitest/autorun'
  require 'minitest/spec'

  def handler_block
    lambda do |on|
      on.some_event do |*params|
        [:first, params]
      end

      on.another_event do |*params|
        [:second, params]
      end
    end
  end

  describe Proc do
    describe "#yield_to" do
      it "yields to the matching handler and returns a result" do
        result = handler_block.yield_to(:some_event, 1, "two", :three)
        result.must_equal [:first, [1, "two", :three]]
        result = handler_block.yield_to(:another_event)
        result.must_equal [:second, []]
      end

      it "does nothing if no handler was invoked" do
        handler_block.yield_to(:nonexistant).must_equal nil
      end

      it "allows boolean operator for conditional checks" do
        lambda { |dsl|
          dsl.some_event?.must_equal true
          dsl.another_event?.must_be_nil
        }.yield_to(:some_event)
      end
    end

    describe "#yield_to!" do
      it "raises an error if no handler was invoked" do
        proc { handler_block.yield_to!(:nonexistant) }.must_raise LocalJumpError
      end
    end
  end
end
