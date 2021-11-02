defmodule ASTProcessorTest do
  use ExUnit.Case
  alias Docpipe.ASTProcessor
  doctest Docpipe

  test "test" do
    content = """
    <html>
      <body>
        <p>tes test <a href="https://www.example.com/content/1">Test Link</a></p>
        <a href='https://www.w3schools.com/'>Visit W3Schools.com!</a>
      </body>
    </html>
    """
    {:ok, ast} = Panpipe.ast(content, [from: :html])
    ASTProcessor.apply(ast)
  end

end
