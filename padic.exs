Code.require_file("mod.exs")
Code.require_file("pol.exs")

defmodule Padic do

  def get(a, p) do
    #get p-adic representation of an integer, u0 + u1*p + u2*p^2 ...
    sol = []
    u = Mod.get(a, p)
    sol = [u | sol]
    sum_current_representation = u

    get(a,p,sol,sum_current_representation,1)
  end

  defp get(a, p, sol, sum_current_representation, power) when sum_current_representation != a do

    divisor = :math.pow(p,power) |> round

    new_a = div((a - sum_current_representation), divisor)
    u = Mod.get(new_a, p)

    sol = [u | sol]
    sum_current_representation = sum_current_representation + divisor * u

    get(a, p, sol, sum_current_representation, power + 1)
  end

  defp get(_, _, sol, _, power) do
    Enum.reverse sol
  end


  def get_pol(pol, p) do

    ##get p-adic representation of polynomial in form u0(x) + u1(x)*p + u2(x)*p^2 ...
    ##returns a list [u0,u1,u2]

    u0 = Mod.get_pol(pol, p)
    sol = [u0]
    cumulative = u0
    power = 1

    terimate? = if u0 == [0] do true else false end



    get_pol(pol, p, sol, cumulative, power, terimate?)
  end

  defp get_pol(pol, p, sol, cumulative, power, false) do

    divisor = :math.pow(p, power) |> round
    IO.inspect(Pol.sub(pol, cumulative))
    {new_pol, _ } = Pol.divp(Pol.sub(pol, cumulative), [divisor])

    terimate? = if Pol.check(new_pol) == [0] do true else false end ##hacky pol.check, should be fixed

    u = Mod.get_pol(Pol.check(new_pol), p)

    sol = [Pol.check(u) | sol]

    cumulative = Pol.add(cumulative, Pol.mul(u, [divisor]))
    get_pol(pol, p, sol, cumulative, power + 1, terimate?)

  end

  defp get_pol(_, _, [_ | sol], _, _, true) do
    Enum.reverse sol
  end




end
