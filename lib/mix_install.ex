defmodule Mix.Tasks.Install do
  use Mix.Task
  @shortdoc """
  TBD
  """

  @moduledoc """
  """

  @spec get_version(String.t, String.t) :: String.t
  def get_version(data, package) do
    lines = String.split(data, "\n")
    line? = Enum.filter(lines, &String.starts_with?(&1, package) )
    packages = Enum.map(line?, fn arg ->
      [name, version] = String.split(arg, ~r{\s+})
      {name, version}
    end)
    matched = Enum.filter(packages, fn {name, version} ->
       name == package
    end)
    case matched do
      [] -> :error
      [{name, version}] -> {:ok, version}
    end
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
end
