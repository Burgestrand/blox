module Blox
  def yield_to(name, *args, &block)
    blox_call(name, *args, &block).__result__
  end

  def yield_to!(name, *args, &block)
    blox_call(name, *args, &block).__result__!
  end

  private

  def blox_call(name, *args, &block)
    blox_block = BasicObject.new
    (class << blox_block; self; end).instance_eval do
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
          @result = handler.call(*args, &block)
        end
      end
    end

    call(blox_block)
    blox_block
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
