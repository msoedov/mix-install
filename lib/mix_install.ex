defmodule Mix.Tasks.Install do
  use Mix.Task
  @shortdoc """
  TBD
  """

  @moduledoc """
  """

  @mix_file_name "mix.exs"

  @spec get_version(String.t, String.t) :: String.t
  def get_version(data, package) do
    lines = String.split(data, "\n")
    line? = Enum.filter(lines, &String.starts_with?(&1, package) )
    packages = Enum.map(line?, fn arg ->
      [name, version] = String.split(arg, ~r{\s+})
      {name, version}
    end)
    matched = Enum.filter(packages, fn {name, _} ->
       name == package
    end)
    case matched do
      [] -> :error
      [{_, version}] -> {:ok, version}
    end
  end

  def write_mix(filename, dependency) do
    readlines(filename)
    |> find_deps_position()
    |> inspect |> IO.puts()
  end

  def run(package) do
     package
     |> inspect
     |> IO.puts
     Mix.shell.info "rly? #{package}"

     packages = Mix.Task.run "hex.search", [package]
     get_version(packages, package)

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
end
