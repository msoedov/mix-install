defmodule MixInstallTest do
  use ExUnit.Case
  alias Mix.Tasks.Install

  doctest Install

  test "validation when :invalid" do
    pkgs = ["whatever", "foo", "ecto", "bar"]
    expected = {:invalid, ["whatever", "foo", "bar"]}
    assert expected == Install.validate(pkgs)
  end

  test "validation when :ok" do
    pkgs = ["dogma", "ecto", ]
    assert :ok == Install.validate(pkgs)

  end

  test "installed? for empty deps" do
    refute Install.installed?([], "ecto")
  end

  test "installed? should be false "  do
    refute Install.installed?(["    {:dogma, only: ~w(dev test)a}",
          ~s(  {:mix_test_watch, "~> 0.2.5"}),], "ecto")
  end

  test "installed? should be true" do
    assert Install.installed?(["    {:dogma, only: ~w(dev test)a}",
          ~s(  {:ecto, "~> 0.2.5"}),], "ecto")
  end

  test "installed? when commented" do
    refute Install.installed?([~s(  \#{:ecto, "~> 0.2.5"}),], "ecto")
    refute Install.installed?([~s(  #  {:ecto, "~> 0.2.5"}),], "ecto")
  end

  test "opt_line -d -t" do
     assert "only: ~w(dev test)a" ==
        Install.opt_line([dev: true, test: true, foo: 2], "whatever")
  end

  test "opt_line -g elixir-lang/foobar" do
     assert "git: https://github.com/elixir-lang/foobar.git, only: test" ==
            Install.opt_line([git: true, test: true], "elixir-lang/foobar")
  end
end
