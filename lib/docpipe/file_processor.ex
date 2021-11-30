defmodule Docpipe.DocumentProcessor do
  alias Docpipe.PlaintextRules
  alias Docpipe.ASTProcessor

  def apply(path) do
    {:ok, content} = File.read(path)

    content = PlaintextRules.apply_rules(content, PlaintextRules.list(), [phase: :pre])
    {:ok, ast} = Panpipe.ast(content)
    ast = ASTProcessor.apply(ast)
  end
end
