# MixInstall (Beta)

An alternative way of adding dependencies to your Elixir project with mix (Similar to gem/pip install)

Usage
-----

```Shell
mix install ecto
```

```Shell
mix install poolboy plug
```

Only for `:dev` and `:test` environment
```Shell
mix install mix_test_watch --test --dev

# or

mix install mix_test_watch -t -d
```

Install task will update `:deps` in mix.exs file to
```Elixir
defp deps do
  [
    {:ecto, "~> 1.1.3", },
    {:poolboy, "~> 1.5.1", },
    {:plug, "~> 1.1.0", },
    {:mix_test_watch, "~> 0.2.5", only: ~w(dev test)a},
  ]
end
```

## Installation

TBD

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add mix_install to your list of dependencies in `mix.exs`:

        def deps do
          [{:mix_install, "~> 0.0.1"}]
        end

  2. Ensure mix_install is started before your application:

        def application do
          [applications: [:mix_install]]
        end
