defmodule MixInstallTest do
  use ExUnit.Case
  alias Mix.Tasks.Install

  doctest Install

  test "Extarct package version" do

  end

  test "Mix writter" do
    # Install.write_mix("mix.exs", {"ecto", "0.5.0"})
  end
end
