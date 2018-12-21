defmodule Mix.Tasks.Generate do
  @moduledoc """
  Generate some music (see tests for more information)

      mix generate [output_directory]
  """

  use Mix.Task

  alias ExComposerBot.{PartimentoChordsGenerator, FileExport}

  @shortdoc "Generate some music"
  def run([output_directory]), do: do_run(output_directory)
  def run(_), do: do_run()

  defp do_run(output_directory \\ default_directory()) do
    lily_string = generate_lily_string()
    IO.puts(lily_string)

    lily_pond_file_path = Path.join(output_directory, default_file_name())
    FileExport.write_to(lily_string, lily_pond_file_path)

    run_conversion(output_directory, lily_pond_file_path)
  end

  defp run_conversion(output_directory, lily_pond_file_path) do
    report_conversion_results System.cmd("lilypond", [
      "--silent",
      "--output",
      output_directory,
      lily_pond_file_path
    ]), output_directory
  end

  defp report_conversion_results({_, 0}, output_directory) do
    IO.puts "Successfully created files: #{Enum.join(File.ls!(output_directory), ", ")}"
    IO.puts "  in directory: #{output_directory}"
  end

  defp report_conversion_results({_, error_code}, _) do
    IO.puts "Failed to convert lily pond with the exit code #{error_code}"
  end

  defp generate_lily_string do
    bass = PartimentoChordsGenerator.generate_bass()
    FileExport.to_lily_string([bass, bass])
  end

  defp default_directory, do: "tmp/output_#{System.system_time(:millisecond)}/"

  defp default_file_name, do: "generated_music.ly"
end
