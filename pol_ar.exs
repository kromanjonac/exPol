defmodule Pol do
  def divp(a,b) do
    #{a,b} = _normalise(a,b)
    q = List.duplicate(0, length(a))
    _div_pol(a,b,q)
  end

  def cont([]) do
    1
  end

  def cont(polynomial) do
    polynomial = Enum.map(polynomial, fn x -> round(x) end)
    Gcd.get_mul(polynomial)
  end

  def primitive_euclidian([0],b) do
    [0]
  end

  def primitive_euclidian(a,b) do
    c = pp(a)
    d = pp(b)
    primitive_euclidian(a,b,c,d)
  end



  defp primitive_euclidian(a,b,c,[0]) do

    gamma = [Gcd.get(cont(a),cont(b))] ##has to be pol
    mul(c,gamma)

  end

  defp primitive_euclidian(a,b,c,d) do

    #IO.inspect(c)
    #IO.inspect(d)
    #IO.puts("------------------")

    {_, r} = pseudodiv(c,d)
    c = d
    d = pp(r)

    primitive_euclidian(a,b,c,d)
  end



  def pseudodiv(a,b) do
    divp(mul(a,[pseudodivison_factor(a,b)]), b)
  end

  def pp([0]) do
    [0]
  end

  def pp([]) do
    [0]
  end

  def pp([h|[]]) do
    [1]
  end

  def pp(polynomial) do
    {res, _ } = divp(polynomial, [cont(polynomial)]) #polynomial has to be in list form even if it is a constant
    res
  end



  def deg(polynomial) do
    _deg(polynomial)
  end

  defp _deg([0|t]) do
    _deg(t)
  end

  def pseudodivison_factor(a,b) when length(a) >= length(b) do
    beta = lcoef(b)
    l = deg(a) - deg(b) + 1
    :math.pow(beta,l) |> round
  end

  def pseudodivison_factor(a,b) do
    pseudodivison_factor(b,a)
  end

  defp _deg(polynomial) do
    length(polynomial)
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
    IO
    _div_pol(a, b, q)

  end

  defp _div_pol(a,b,q) when length(a) < length(b) do
    {Enum.reverse(q) |> remove_zeros, a}
  end

  def mul(a,b) do
    _mul(a,Enum.reverse(b), List.duplicate(0,length(a)),0)
  end

  defp _mul(a, b = [h | t], sol, offset) do
    #coeficents of b are reversed so that we can pattern match against [h|t]
    #offset allows us to know the current exponent of a multiplicand
    to_add = Enum.reduce(a,[], fn x, acc -> [x * h | acc] end)
    to_add = Enum.reverse(to_add)

    to_add = to_add ++ List.duplicate(0, offset)

    sol =
      Enum.zip(sol,to_add)
      |>Enum.map(fn {a,b} -> a + b end)


    _mul(a, t, [0 | sol], offset + 1)
  end

  defp _mul(_,[], sol, _) do
    remove_zeros(sol)
  end

  def add(a,b) when length(a) >= length(b) do
    sol = _add(a,b)
    remove_zeros(sol)
  end

  def add(a,b) when length(a) < length(b) do
    _add(b,a)
  end

  defp _add(a,b) do
    b = List.duplicate(0, length(a) - length(b)) ++ b
    Enum.zip(a,b) |> Enum.map(fn {a,b} -> a + b end)

  end

  def sub(a,b) do
    add(a, mul(b,[-1]))
  end

  def exp(a, n) do
    _exp(a,n,a)
  end

  defp _exp(a, n, sol) when n > 1 do

    new = mul(sol,a)
    _exp(a,n-1,new)
  end

  defp _exp(a,1,sol) do
    sol
  end

  defp _exp(a,0,sol) do
    [1]
  end

  def derivative(a) do
    [h | t] = Enum.reverse(a)
    _derivative(t,[],1)
  end


  defp _derivative([h | t], sol, curr) do
    _derivative(t, [h * curr | sol], curr + 1)
  end

  defp _derivative([], [], curr) do
    [0]
  end

  defp _derivative([], sol, curr) do
    sol
  end


  def sffactor (a) do
    _sffactor_start(a,[])
  end

  defp _sffactor_start(a, sol) do
    i = 1
    b = derivative(a)
    c = primitive_euclidian(a,b)
    {w , _} = divp(a,c)
    _sffactor(c,w,i, [[1]])

  end

  defp _sffactor([1.0],w, i, sol) do
    IO.puts("there")
    [exp(w,i) | sol]
  end

  defp _sffactor([c],w,i,sol) when c != [1.0] do
    IO.puts("here")
    _sffactor([1.0],w,i,[[c] | sol])
  end



  defp _sffactor(c,w,i,sol) when c != [1.0] do
    y = primitive_euclidian(w,c)
    {z,_} = divp(w,y)
    sol = [exp(z,i) | sol]
    {c,_} =divp(c,y)
    _sffactor(c,y,i+1,sol)
  end





  defp remove_zeros([h | t]) when h < 0.0000001 and h > -0.0000001 do
    remove_zeros(t)
  end

  defp remove_zeros([0 | t]) do
    remove_zeros(t)
  end


  defp remove_zeros(a) do
    a
  end

  def lcoef([0|t]) do
    lcoef(t)
  end

  def lcoef([h]) do
    h
  end

  def lcoef([h|t]) do
    h
  end




end
