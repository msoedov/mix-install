defmodule Mix.Tasks.Install do
  use Mix.Task
  @shortdoc """
  TBD
  """

  @moduledoc """
  """

  @mix_file_name "mix.exs"

  def run(package) do
     # arg parser
     # validation

     case validate(package) do
       :ok -> nil
       {:invalid, names} ->  names |> suggest |> panic
     end


     deps = Enum.map(package, fn pkg ->
       version = pkg |> Hex.Registry.get_versions |> List.last
       {pkg, version}
     end)

     Enum.map(deps, fn dep ->
          write_mix(@mix_file_name, dep)
     end)

     Mix.Task.run "deps.get", []
     :ok
  end

  def validate(packages) do
      errors = Enum.reduce(packages, [], fn(p, acc) ->
          suggested = Hex.Registry.search(p)
          if Enum.member?(suggested, p) do
             acc
          else
             acc ++ [p]
          end
      end)
      case errors do
        [] -> :ok
        e -> {:invalid, e}
      end
  end

  @spec suggest([String.t]) :: String.t
  def suggest(packages) do
    Enum.each(packages, fn p ->
       suggested = Hex.Registry.search(p)
       IO.puts("Package #{p} was not found")
       if suggested != [] do
          suggested = Enum.join(suggested, " ")
          IO.puts("Maybe you meant: #{suggested}")
       end
    end)
    ""
  end

  def write_mix(filename, {name, version}) do
    lines = readlines(filename)
    lines
    |> find_deps_position
    |> insert(lines, name, version)
    |> write_lines(filename)
  end

  defp readlines(filename) do
    case File.read(filename) do
      {:ok, content} -> String.split(content, "\n")
      {:error, _} -> panic "Error: mix file was not found"
    end
  end

  defp find_deps_position([x|tail], pos \\ 0) do
    case Regex.match?(~r{\s+defp\sdeps\s}, x) do
      true -> find_end(tail, pos + 1)
      _ -> find_deps_position(tail, pos + 1)
    end
  end
  defp find_deps_position([], _) do
    {:error, "defp deps do .. end not found"}
  end

  defp find_end([x|tail], pos) do
    case Regex.match?(~r{\s+\]}, x) do
      true -> pos
      _ -> find_end(tail, pos + 1)
    end
  end

  defp insert(pos, lines, name, version) do
    # todo: indent
    List.insert_at(lines, pos, "      {:#{name}, \"~> #{version}\"},")
  end

  defp write_lines(lines, filename) do
    File.write!(filename, Enum.join(lines, "\n"))
  end

  def panic(msg) do
      IO.puts msg
      System.halt(1)
  end
end
