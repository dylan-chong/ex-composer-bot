defmodule ComposerBot.Scale do
  @moduledoc """
  Methods to generate `Pitch` structs
  """

  alias ComposerBot.{Scale, Pitch}

  @spec major_scale(Pitch.t) :: list
  def major_scale(%Pitch{note_num: base_note_num, alteration: base_alt}) do
    if base_note_num != 0 || base_alt != 0 do
      raise "NYI"
    end

    Pitch.c_major_note_nums()
    # TODO transpose
    |> Enum.map(fn num -> %Pitch{note_num: num} end)
  end
end
