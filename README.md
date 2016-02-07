# MixInstall (Beta) [![Build Status](https://travis-ci.org/msoedov/mix-install.svg?branch=master)](https://travis-ci.org/msoedov/mix-install)


An alternative way of adding dependencies to your Elixir project with mix (Similar to gem/pip install for dev environment)

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

## Todos


## Should I use it?

This tooling may be not an `idiomatic` way for Elixir and opposite to good practices I'm not sure about it. Please open an issue or notify me if you see code that smells bad.
