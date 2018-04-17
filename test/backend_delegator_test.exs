defmodule BackendDelegatorTest do
  use ExUnit.Case
  doctest Import.BackendDelegator

  alias Import.{BackendsRegistrator, BackendDelegator, StateToken}

  describe "process_options/1" do
    test "Returns the state token without any changes when there are errors present" do
      token = %StateToken{errors: [{:error, :unrecognized_arguments_type}]}

      assert token == BackendDelegator.process_options(token)
    end

    test "Sets the specific backend errors when there's errors processing data for a backend or a backend is unrecognized" do
      token = %StateToken{selected_backend: "foobar", data_location: "bazquux"} |> BackendsRegistrator.get_backends()

      %StateToken{errors: errors, softwares: []} = BackendDelegator.process_options(token)

      assert [{:error, :unrecognized_backend_type}] == errors
    end

    test "Sets the parsed software structures when a backend successfuly imports data"
  end
end
