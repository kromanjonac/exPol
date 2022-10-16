Code.require_file("pol_ar.exs")

defmodule Gcd do
  def get(a,b) do
    _get(abs(a),abs(b), false)
  end

  def get_mul([h|[]]) do
    round(h)
  end

  def get_mul([h|t]) do
    _get_multiple(round(h),t)
  end

  def get_extended(a,b) do
    c = abs(a)
    d = abs(b)
    c1 = 1
    c2 = 0
    d1 = 0
    d2 = 1
    get_extended(a,b,c,d,c1,c2,d1,d2)
  end

  defp get_extended(a,b,c,d,c1,c2,d1,d2) when d != 0 do
    q = div(c,d)
    r = c - q * d
    r1 = c1 - q * d1
    r2 = c2 - q * d2
    get_extended(a,b,d,r,d1,d2,r1,r2)
  end

  defp get_extended(a,b,c,d,c1,c2,d1,d2) do
    g = abs(c)
    s = div(c1, sign(a) * sign(c))
    t = div(c2, sign(b) * sign(c))
    {g,s,t}
  end

  defp sign(a) when a < 0 do
    -1
  end

  defp sign(a) do
    1
  end

  def get_extended_pol(a,b) when length(a) >= length(b) do
    get_extended_pol(a,b,true)
  end

  def get_extended_pol(a,b) do
    get_extended_pol(b,a,false)
  end

  defp get_extended_pol(a,b,switch?) when length(a) >= length(b) do
    c = norm_pol(a)
    d = norm_pol(b)
    c1 = [1]
    c2 = [0]
    d1 = [0]
    d2 = [1]
    get_extended_pol(a,b,c,d,c1,c2,d1,d2,switch?)
  end




  defp get_extended_pol(a,b,c,d,c1,c2,d1,d2,switch?) when d != [] do
    IO.inspect(c)
    IO.inspect(d)
    IO.inspect("-----------------")


    {q, _} = Pol.divp(c,d)
    r = Pol.sub(c, Pol.mul(q,d))
    r1 = Pol.sub(c1, Pol.mul(q,d1))
    r2 = Pol.sub(c2, Pol.mul(q,d2))
    get_extended_pol(a,b,d,r,d1,d2,r1,r2,switch?)
  end

  defp get_extended_pol(a,b,c,d,c1,c2,d1,d2,switch?) do

    g = norm_pol(c)

    IO.inspect(g)
    IO.inspect(hd(a))
    IO.inspect(hd(c))


    s = Pol.divp(c1,[hd(a)*hd(c)])
    t = Pol.divp(c2,[hd(b)*hd(c)])
    {g,c1,c2,a,b,c}
    {g,s,t}
    return_extended_pol(g, s, t, switch?)

    #inspekt za commit

  end

  defp return_extended_pol(g,s,t,true) do
    {g,s,t}
  end

  defp return_extended_pol(g,s,t,false) do
    {g,t,s}
  end




  def get_pol(a,b) do
    _get_pol(norm_pol(a), norm_pol(b))
  end

  defp _get_multiple(current_gcd,[0|t]) do
    _get_multiple(current_gcd, t)
  end

  defp _get_multiple(current_gcd,[h|[]]) do
    get(current_gcd,h)
  end

  defp _get_multiple(current_gcd,[]) do
    current_gcd
  end

  defp _get_multiple(current_gcd,[h|t]) do
    _get_multiple(get(current_gcd,round(h)), t)
  end


  defp norm_pol(a = [h|t]) do
    Enum.map(a, fn x -> x / h end)
  end

  defp _get_pol(a,b) do

    if all_zero(b) do
      norm_pol(a)
    else
      {q,rem} = div_pol(a,b)
      _get_pol(b,rem)
    end
  end

  defp all_zero([0.0|t]) do
    all_zero(t)
  end

  defp all_zero([]) do
    true
  end

  defp all_zero(n) do
    false
  end



  def get_all(a,b) do
    _get(abs(a),abs(b),true)
  end

  defp _get(c, d, all?) do
    c1 = 1
    c2 = 0
    d1 = 0
    d2 = 1
    _get(c,d,c1,c2,d1,d2, all?)
  end

  defp _get(c,d,c1,c2,d1,d2, all?) when d != 0 do
    q = div(c,d)
    r = c - q*d
    r1 = c1 - q*d1
    r2 = c2 - q*d2
    _get(d,r,d1,d2,r1,r2, all?)
  end

  defp _get(c,0,c1,c2,d1,d2,all?) when all? do
    {abs(c),c1,c2}
  end

  defp _get(c,0,c1,c2,d1,d2,all?) when not all? do
    abs(c)
  end

  def div_pol(a,b) do
    #{a,b} = _normalise(a,b)
    q = List.duplicate(0, length(a))
    _div_pol(a,b,q)
  end

  defp _div_pol(a,b,q) when length(a) >= length(b) do

    len_a = length(a)
    len_b = length(b)

    h_a = hd(a)
    h_b = hd(b)

    coef = h_a / h_b

    b_help = Enum.map(b, fn x -> x * coef end)

    b_help = b_help ++ List.duplicate(0, len_a - len_b)

    a = Enum.zip(a, b_help) |> Enum.map(fn {x,y} -> x - y end)

    a = remove_zeros(a)

    q = List.replace_at(q, len_a - len_b, coef)

    _div_pol(a, b, q)

  end

  defp _div_pol(a,b,q) when length(a) < length(b) do
    {Enum.reverse(q),a}
  end

  defp remove_zeros([0.0 | t]) do
    remove_zeros(t)
  end

  defp remove_zeros(a) do
    a
  end


  def _get_lead_index([h|t]) do
    if h != 0 do
      0
    else
      1 + _get_lead_index(t)
    end
  end

  def _get_lead_index([]) do
    0
  end

  defp _normalise(a,b) do
    len_a = length(a)
    len_b = length(b)

    if len_a > len_b do
      add = len_a - len_b
      ret = List.duplicate(0, add)
      ret = ret ++ b
      {a,ret}
    else
      add = -len_a + len_b
      ret = List.duplicate(0, add)
      ret = ret ++ a
      {b,ret}
    end
  end





end
