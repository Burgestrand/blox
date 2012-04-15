# Blox

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

accepts_multiple_blocks(:awesome) do |is|
  is.awesome do |&block|
    puts "Very awesome!"
    block.call
  end

  is.not_awesome do
    puts "Not so awesome"
  end
end

accepts_multiple_blocks(:not_awesome) do |event|
  if event.not_awesome?
    puts ":("
  else
    puts "\\o/!"
  end
end
```

If you wish to enforce that at least one of the blocks are executed,
you may use `block.yield\_to!` (with a bang) instead, which will raise
an exception if no block was executed.

## License

2-clause (simplified) BSD license. See LICENSE for details.
