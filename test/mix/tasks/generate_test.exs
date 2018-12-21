defmodule MixTest.Tasks.Generate do
  use ExUnit.Case
  alias Mix.Tasks.Generate
  import ExUnit.CaptureIO

  test "system has `lilypond` commandline tool installed" do
    {output, 0} = System.cmd("lilypond", ["--version"])
    assert output =~ ~r/GNU LilyPond 2\.\d+(\.\d+)?/
  end

  test "does not crash when not given arguments" do
    capture_io(fn ->
      Generate.run([])
    end)
  end

  test "creates the lilypond, pdf, and midi files" do
    output_directory = "tmp/test-output-directory/"
    File.rm_rf!(output_directory)

    capture_io(fn ->
      Generate.run([output_directory])
    end)

    assert File.exists?(output_directory)

    output_files =
      output_directory
      |> File.ls!()
      |> Enum.join("\n")

    assert output_files =~ ~r/.ly$/m
    assert output_files =~ ~r/.pdf$/m
    assert output_files =~ ~r/.midi$/m

    File.rm_rf!(output_directory)
  end
end
