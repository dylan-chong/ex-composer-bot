defmodule Mix.Tasks.Generate do
  @moduledoc "Generate some music"

  use Mix.Task

  alias ExComposerBot.{PartimentoChordsGenerator, FileExport}

  @shortdoc "Generate some music"
  def run(_) do
    generate_something()
  end

  defp generate_something(path \\ default_file_path()) do
    bass = PartimentoChordsGenerator.generate_bass()
    lily_string = FileExport.to_lily_string([bass, bass])

    IO.puts(lily_string)

    File.mkdir_p!(Path.dirname(path))
    File.write!(path, lily_string)

    IO.puts("\n")
    IO.puts("Outputted to file: #{path}")
  end

  defp default_file_path, do: "tmp/output-#{System.system_time(:millisecond)}.ly"
end
