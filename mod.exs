Code.require_file("gcd.exs")
Code.require_file("pol.exs")


defmodule Mod do

  def get_pol(pol = [h | t], b) do
    get_pol(pol,b,[])
  end

  def get(a, b) do
    a - round(a / b) * b
  end

  defp get_pol([h | t], b, sol) do
    h = get(h, b)
    get_pol(t, b, [h | sol])
  end

  defp get_pol([], _, sol) do
    Pol.remove_zeros(Enum.reverse(sol))
    Enum.reverse(sol) |> Pol.remove_zeros |> Pol.check
  end

  def multiplicative_inverse(a, p) do # returns multiplicative inverse of a in Z mod b, if b is a prime it will always return a good result
    {g,s,_} = Gcd.get_extended(a,p)
    if g == 1 do
      {:exists, s}
    else
      {:error, 0}
    end
  end

  def m_inverse_float(f, p) do
    a = round(:math.pow(f,-1))
    multiplicative_inverse(a, p)
  end
end
