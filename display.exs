defmodule Display do
  def of(pol) do
    of(Enum.reverse(pol),"", 0)
  end

  defp of([h | t], s, exp) when h > 0 do
    s = "+ #{h}x^#{exp} " <> s
    of(t,s, exp + 1)
  end

  defp of([h | t], s, exp) when h < 0 do
    s = "- #{abs(h)}x^#{exp} " <> s
    of(t,s, exp + 1)
  end

  defp of([h | t], s, exp) when h == 0 do
    of(t,s, exp + 1)
  end

  defp of([], s, exp) do
    String.slice(s,1..-1) |> String.trim
  end
end
