defmodule ASTProcessorTest do
  use ExUnit.Case
  alias Docpipe.ASTProcessor
  doctest Docpipe

  test "test" do
    content = """
    <title>Title text</title>
    <h1>Heading 1</h1>
    <div>
      <p>p one</p>
      <p>p two</p>
    </div>
    """
    {:ok, ast} = Panpipe.ast(content, [from: :html])
    ASTProcessor.apply(ast) |> IO.inspect()
  end

end
