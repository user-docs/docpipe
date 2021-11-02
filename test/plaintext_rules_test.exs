defmodule PlaintextRulesTest do
  use ExUnit.Case
  alias Docpipe.PlaintextRule
  doctest Docpipe

  test "it applies string replacment rules " do
    rules = [%PlaintextRule{phase: :pre, type: :string, pattern: "test", replacement: "test2"}]
    content =
      "<p>tes test</p>"
      |> Docpipe.PlaintextRules.apply_rules(rules, [phase: :pre])

    assert content == "<p>tes test2</p>"
  end

  test "it applies regex replacement rules " do
    rules = [%PlaintextRule{phase: :pre, type: :regex, pattern: "tes.*est", replacement: "test"}]
    content =
      "<p>tes test2</p>"
      |> Docpipe.PlaintextRules.apply_rules(rules, [phase: :pre])

    assert content == "<p>test2</p>"
  end
end
