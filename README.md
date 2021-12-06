# Docpipe

Docpipe is a tool to assist technical writers with document migrations from one system/format to another.  It basically takes users through an opinionated process to help with conversions. Essentially what it does is:
Ingests a collection of files
Makes a list of all the source files and locations
Makes a list of all the images in all the source files
Makes a list of all the links in the source files
Loops the list of source files, giving the user an opportunity to rename the file/change the title of the document/change the target location of the document
Same for the images
Same for the links (gives them an opportunity to customize link rewrite rules)
Gives the user an opportunity to apply a "diff" at the end so their final changes/cleaning will be applied
Once this configuration is in place, it gives the TW a "one-click" migration of the KB from one format to another, so that they can continue to use/modify their KB during the migration.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `docpipe` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:docpipe, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/docpipe](https://hexdocs.pm/docpipe).

