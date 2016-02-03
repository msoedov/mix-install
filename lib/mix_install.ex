defmodule Mix.Tasks.Install do
  use Mix.Task
  @shortdoc """
  TBD
  """

  @moduledoc """
  """

  @mix_file_name "mix.exs"

  @spec get_version(String.t, String.t) :: String.t
  def get_version(packages, package) do
    # lines = String.split(data, "\n")
    # line? = Enum.filter(lines, &String.starts_with?(&1, package) )
    # packages = Enum.map(line?, fn arg ->
    #   [name, version] = String.split(arg, ~r{\s+})
    #   {name, version}
    # end)
    # matched = Enum.filter(packages, fn {name, _} ->
    #    name == package
    # end)
    # case matched do
    #   [] -> :error
    #   [{_, version}] -> {:ok, version}
    # end
  end

  def write_mix(filename, {name, version}) do
    lines = readlines(filename)
    position = find_deps_position(lines)
    insert(lines, position, name, version)
    |> write_lines(filename)
    |> inspect()
    |> IO.puts()
  end

  def run(package) do
     Mix.shell.info "rly? #{package}"
     packages = Hex.Registry.search(package)

     Enum.each(package, fn pkg ->
       version = Hex.Registry.get_versions(pkg) |> List.last()
       write_mix(@mix_file_name, {pkg, version})
     end)
     Mix.Task.run "deps.get", []
  end

  defp readlines(filename) do
    case File.read(filename) do
      {:ok, content} -> String.split(content, "\n")
      {:error, _} -> IO.puts "Error: mix file not found"; System.halt(1)
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

  defp insert(lines, pos, name, version) do
    # todo: indent
    List.insert_at(lines, pos, "      {:#{name}, \"~> #{version}\"},")
  end

  defp write_lines(lines, filename) do
    File.write!(filename, Enum.join(lines, "\n"))
  end
end
