def my_assert_file(relative, *contents)
  absolute = File.expand_path(relative, destination_root)
  assert File.exist?(absolute), "Expected file #{relative.inspect} to exist, but does not"

  read = File.read(absolute) if block_given?
  yield read if block_given?
  # assert_nothing_raised { yield read } if block_given?
end
