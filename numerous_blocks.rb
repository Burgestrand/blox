module NumerousBlocks
  def yield_to(name, *args, &block)
    multi_call(name, *args, &block).__result__
  end

  def yield_to!(name, *args, &block)
    multi_call(name, *args, &block).__result__!
  end

  private

  def multi_call(name, *args, &block)
    multi_block = BasicObject.new
    (class << multi_block; self; end).instance_eval do
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

    call(multi_block)
    multi_block
  end
end

Proc.send(:include, NumerousBlocks)
