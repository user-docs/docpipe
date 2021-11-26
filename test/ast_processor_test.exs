defmodule ASTProcessorTest do
  use ExUnit.Case
  alias Docpipe.ASTProcessor
  doctest Docpipe

  test "test" do
    content = """
    <title>Title text</title>
    """
    {:ok, ast} = Panpipe.ast(content, [from: :html])
    ASTProcessor.apply(ast) |> IO.inspect()
  end

end
