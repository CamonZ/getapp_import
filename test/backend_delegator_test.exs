defmodule BackendDelegatorTest do
  use ExUnit.Case
  doctest Import.BackendDelegator

  alias Import.{BackendDelegator, CLI}

  describe "process_options/1" do
    test "Returns the state token without any changes when there are errors present" do
      token = %CLI{errors: [{:error, :unrecognized_arguments_type}]}

      assert token == BackendDelegator.process_options(token)
    end

    test "Sets the specific backend errors when there's errors processing data for a backend or a backend is unrecognized" do
      token = %CLI{importer: "foobar", location: "bazquux"}

      %CLI{errors: errors, softwares: []} = BackendDelegator.process_options(token)

      assert [{:error, :unrecognized_backend_type}] == errors
    end

    test "Sets the parsed software structures when a backend successfuly imports data"
  end
end
