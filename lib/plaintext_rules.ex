defmodule Docpipe.PlaintextRules do
  import Ecto.Query, warn: false
  alias Docpipe.PlaintextRule
  @path Application.get_env(:docpipe, :plaintext_rules_config)

  def list() do
    {:ok, content} = File.read(@path)
    {:ok, map} = Jason.decode(content)
    map["data"]
    |> Enum.map(fn(attrs) -> create_struct(attrs) end)
  end

  def create_struct(attrs) do
    {:ok, struct} =
      %PlaintextRule{}
      |> PlaintextRule.changeset(attrs)
      |> Ecto.Changeset.apply_action(:insert)

    struct
  end

  def apply_rules(content, rules, opts) do
    rules
    |> maybe_filter_phase(opts[:phase])
    |> Enum.reduce(content, fn(rule, content) -> apply_rule(content, rule) end)
  end

  def maybe_filter_phase(rules, nil), do: rules
  def maybe_filter_phase(rules, phase),
    do: Enum.filter(rules, fn(rule) -> rule.phase == phase end)

  def apply_rule(content, %PlaintextRule{type: :string, pattern: pattern, replacement: replacement} = rule) do
    String.replace(content, pattern, replacement)
  end

  def apply_rule(content, %PlaintextRule{type: :regex, pattern: pattern, replacement: replacement} = rule) do
    Regex.replace(~r/#{pattern}/, content, replacement)
  end
end
