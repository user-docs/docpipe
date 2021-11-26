defmodule Docpipe.ASTProcessor do
  alias Docpipe.PlaintextRules

  def apply(%Panpipe.Document{children: children} = document) do
    tags = %{links: [], images: []}
    Enum.map_reduce(children, tags, &traverse/2)
  end

  def traverse(%{children: children} = node, acc) do
    {
      node
      |> Map.put(:children, Enum.map_reduce(children, acc, &traverse/2)),
      acc
      |> link(node)
      |> link(node)
    }
  end

  def traverse(%{}, acc) do
    {
      node,
      acc
      |> link(node)
      |> image(node)
    }
  end

  def link(state, %Panpipe.AST.Link{} = link) do
    Map.put(state, :links, [link | state.links])
  end
  def link(state, _), do: state

  def image(state, %Panpipe.AST.Image{} = image) do
    Map.put(state, :images, [image | state.images])
  end
  def image(state, _), do: state
end
