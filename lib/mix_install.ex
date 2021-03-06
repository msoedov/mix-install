defmodule Mix.Tasks.Install do
  alias Mix.Tasks.Install.CLI
  use Mix.Task

  @shortdoc """
  TBD
  """

  @moduledoc """
  """

  @mix_file_name "mix.exs"

  def run(args) do
     # todo: arg parser
     # todo: validation
     # todo: mix file exists?
     # todo: dep already installed
     # todo: test gen

     {flags, packages} = CLI.parse(args)
     case validate(packages) do
       :ok -> nil
       {:invalid, names} ->  names |> suggest |> panic
     end


     deps = Enum.map(packages, fn pkg ->
       version = pkg |> Hex.Registry.get_versions |> List.last
       {pkg, version}
     end)

     Enum.map(deps, fn dep ->
          write_mix(@mix_file_name, dep, flags)
     end)

     Mix.Shell.cmd("mix deps.get", fn data ->
       IO.puts(data)
     end)
     IO.puts("Done.")
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

  def write_mix(filename, {name, version}, flags) do
    lines = readlines(filename)
    if installed?(lines, name) do
      error("Package #{name} is already in mix.exs. Need to update version?")
    else
      lines
      |> find_deps_position
      |> insert(lines, {name, version}, flags)
      |> write_lines(filename)
    end
  end

  def error(msg) do
    IO.puts msg
  end

  def panic(msg) do
    error msg
    System.halt(1)
  end

  def installed? lines, pkg do
    lines
    |> Enum.filter(&Regex.match?(~r/^\s+\{\:#{pkg}.*/, &1) )
    |> Enum.any?()
  end

  def opt_line(opts, pkg)do
    opt_line(opts, pkg, "")
  end
  def opt_line([{:dev, true}, {:test, true} | tail], pkg, line) do
    opt_line(tail, pkg, line <> " only: ~w(dev test)a,")
  end
  def opt_line([{:git, true} | tail], pkg, line) do
    opt_line(tail, pkg, line <> " git: https://github.com/#{pkg}.git,")
  end
  def opt_line([{:test, true} | tail], pkg, line) do
    opt_line(tail, pkg, line <> " only: test,")
  end
  def opt_line([{:dev, true} | tail], pkg, line) do
    opt_line(tail, pkg, line <> " only: dev,")
  end
  def opt_line(_, _, line) do
    line
    |> stripify
  end

  defp stripify(s) do
    s
    |> String.strip()
    |> String.rstrip(?,)
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

  defp insert(pos, lines, {name, version}, opts) do
    # todo: indent
    options = opt_line(opts, name)
    dep_line = "      {:#{name}, \"~> #{version}\", #{options}},"
    List.insert_at(lines, pos, dep_line)
  end

  defp write_lines(lines, filename) do
    File.write!(filename, Enum.join(lines, "\n"))
  end

end
