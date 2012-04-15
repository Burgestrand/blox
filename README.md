# Numerous blocks

A tiny Ruby gem to aid you when you wish to pass multiple blocks to any ruby method.

## Examples

### Passing multiple blocks to a method

```ruby
def accepts_multiple_blocks(is_awesome, &block)
  if is_awesome
    block.yield_to(:awesome, "this is awesome!") do
      puts "You may pass blocks to the blocks, too!"
    end
  else
    block.yield_to(:not_awesome, "bad, this is bad")
  end
end

accepts_multiple_blocks(:awesome) do |when|
  when.awesome do |&block|
    puts "Very awesome!"
    block.call
  end

  when.not_awesome do
    puts "Not so awesome"
  end
end
```

If you wish to enforce that at least one of the blocks are executed,
you may use `block.yield\_to!` (with a bang) instead.
