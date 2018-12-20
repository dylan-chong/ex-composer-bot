defmodule Mix.Tasks.Generate do
  @moduledoc "Generate some music"

  use Mix.Task

  alias ExComposerBot.{PartimentoChordsGenerator, FileExport}

  @default_output_directory "tmp"
  @default_output_file "output-{{TIME}}.ly"

  @shortdoc "Generate some music"
  def run(args) do
    generate_something()
  end

  defp generate_something do
    bass = PartimentoChordsGenerator.generate_bass()
    lily_string = FileExport.to_lily_string([bass, bass])

    IO.puts(lily_string)

    file_name = String.replace(@default_output_file,  "{{TIME}}", "#{System.system_time(:millisecond)}")
    file_path = "#{@default_output_directory}/#{file_name}"

    :ok = File.mkdir_p(@default_output_directory)
    :ok = File.write(file_path, lily_string)

    IO.puts("\n")
    IO.puts("Outputted to file #{file_name}")
  end
end
