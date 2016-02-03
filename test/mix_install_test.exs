defmodule MixInstallTest do
  use ExUnit.Case
  alias Mix.Tasks.Install

  doctest Install

  test "Extarct package version" do
    data = """
    ar2ecto                0.1.2
    arc_ecto               0.3.1
    calecto                0.5.0
    comeonin_ecto_password 0.0.3
    couchdb_connector      0.2.0
    ecto                   1.1.3
    ecto_audit             0.0.1
    """
     assert {:ok, "1.1.3"} == Install.get_version(data, "ecto")
  end

  test "Mix writter" do
    Install.write_mix("mix.exs", {"ecto", "0.5.0"})
  end
end
