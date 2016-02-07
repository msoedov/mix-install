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
      {flags, packages, _} = OptionParser.parse(args, aliases: @options)

      # if flags.help do
          # raise @moduledoc
      # else
        {Enum.sort(flags), packages}
      # end

    end

    def help do
      IO.puts(@moduledoc)
    end
end
