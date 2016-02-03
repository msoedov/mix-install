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
     Mix.shell.info "rly? #{package}"
     packages = Hex.Registry.search(package)

     deps = Enum.map(package, fn pkg ->
       version = Hex.Registry.get_versions(pkg) |> List.last()
       {pkg, version}
     end)

     Enum.map(deps, fn dep ->
          write_mix(@mix_file_name, dep)
     end)

     Mix.Task.run "deps.get", []
     :ok
  end

  def write_mix(filename, {name, version}) do
    lines = readlines(filename)
    position = find_deps_position(lines)
    insert(lines, position, name, version)
    |> write_lines(filename)
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
