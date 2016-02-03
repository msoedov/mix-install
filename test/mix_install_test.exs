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

  test "Mix writter" do
    # Install.write_mix("mix.exs", {"ecto", "0.5.0"})
  end
end
