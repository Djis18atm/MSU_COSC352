
[raw_name, raw_times] = System.argv()


name = String.trim(raw_name)
times = 
  case Integer.parse(raw_times) do
    {int, _} -> int
    :error -> 1  # Default to 1 if the input is invalid
  end


Enum.each(1..times, fn _ ->
  IO.puts("Hello, #{name}!")
end)
