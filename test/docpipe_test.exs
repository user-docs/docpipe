defmodule DocpipeTest do
  use ExUnit.Case
  doctest Docpipe

  test "greets the world" do
    assert Docpipe.hello() == :world
  end
end
