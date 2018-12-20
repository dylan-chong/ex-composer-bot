defmodule Mix.Tasks.Generate do
  @moduledoc "Generate some music"

  use Mix.Task

  alias ExComposerBot.{PartimentoChordsGenerator, FileExport}

  @shortdoc "Generate some music"
  def run(_) do
    generate_something
  end

  defp generate_something do
    bass = PartimentoChordsGenerator.generate_bass()
    s = FileExport.to_lily_string([bass, bass])

    IO.puts("\n\n\n")
    IO.puts(s)
    IO.puts("\n\n\n")

    nil
  end
end
