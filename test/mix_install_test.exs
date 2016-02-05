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
          "  {:mix_test_watch, \"~> 0.2.5\"}",], "ecto")
  end

  test "installed? should be true" do
    assert Install.installed?(["    {:dogma, only: ~w(dev test)a}",
          "  {:ecto, \"~> 0.2.5\"}",], "ecto")
  end

  test "installed? when commented" do
    refute Install.installed?(["  \#{:ecto, \"~> 0.2.5\"}",], "ecto")
    refute Install.installed?(["  \#  {:ecto, \"~> 0.2.5\"}",], "ecto")
  end
end
