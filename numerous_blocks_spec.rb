require 'minitest/autorun'
require 'minitest/spec'

$LOAD_PATH.unshift File.dirname(__FILE__)
require 'numerous_blocks'

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
