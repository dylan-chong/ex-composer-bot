# ExComposerBot

A program that will eventually generate music.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `composer_bot` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:composer_bot, "~> 0.1.0"}]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/composer_bot>.

### Install `lilypond` commandline tool

One Mac OS, I would recommend using `brew cask install lilypond`. Otherwise,
try installing from <http://lilypond.org/download.html>.

## Instructions

### Running

See the module documentation in `lib/mix/tasks/generate.ex`

Currently, my process to listen to the outputted midi files is to open the midi
file in Sibelius. Other options exist

### Tests

`mix test` or `mix test.watch`
