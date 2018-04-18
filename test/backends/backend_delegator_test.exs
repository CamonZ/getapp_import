defmodule BackendDelegatorTest do
  use ExUnit.Case
  doctest Import.BackendDelegator

  alias Import.{BackendsRegistrator, BackendDelegator, StateToken, Software}

  describe "process_options/1" do
    test "Returns the state token without any changes when there are errors present" do
      token = %StateToken{errors: [{:error, :unrecognized_arguments_type}]}

      assert token == BackendDelegator.process_options(token)
    end

    test "Sets errors when a backend is unrecognized" do
      token = %StateToken{selected_backend: "foobar", data_location: "bazquux"} |> BackendsRegistrator.get_backends()

      %StateToken{errors: errors, softwares: []} = BackendDelegator.process_options(token)

      assert [{:error, :unrecognized_backend_type}] == errors
    end

    test "Sets errors when a backend returns an error" do
      token =
        %StateToken{selected_backend: "dummy", data_location: "bazquux"}
        |> Map.put(:registered_backends, %{"dummy" => BackendDelegatorTest.DummyFailureBackend})

      %StateToken{errors: errors, softwares: []} = BackendDelegator.process_options(token)

      assert [{:error, :data_location_does_not_exist}] == errors
    end

    test "Sets the parsed software structures when a backend successfuly imports data" do
      token =
        %StateToken{selected_backend: "dummy", data_location: "bazquux"}
        |> Map.put(:registered_backends, %{"dummy" => BackendDelegatorTest.DummySuccessfulBackend})

      %StateToken{errors: [], softwares: softwares} = BackendDelegator.process_options(token)

      assert softwares == [%Software{name: "Dummy", categories: ["Dummy", "Test"], twitter: "@dummy_software_inc"}]
    end
  end

  defmodule DummySuccessfulBackend do
    def process(_) do
      {:ok, [Software.new("Dummy", ["Dummy", "Test"], "@dummy_software_inc")]}
    end
  end

  defmodule DummyFailureBackend do
    def process(_) do
      {:error, :data_location_does_not_exist}
    end
  end
end
