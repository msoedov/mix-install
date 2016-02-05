defmodule Mix.Tasks.Install.CLI do

    @moduledoc """
    -g, --github: install package from github
    -t, --test: test only
    -d, --dev: development only
    -h --help: print help

    Usage:

    mix install foo bar -t -d
    mix install fizz -g
    mix install bazz
    """
    @options [t: :test, g: :github, d: :dev, h: :help]

    def parse(args) do
      {flags, packages, errors} = OptionParser.parse(args, aliases: @options)
      IO.puts(inspect(flags))
      IO.puts(inspect(errors))
      if errors == [] or flags.help do
          raise @moduledoc
      else
        {flags, packages}
      end

    end

    def help do
      IO.puts(@moduledoc)
    end
end
