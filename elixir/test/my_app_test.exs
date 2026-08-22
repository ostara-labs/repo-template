defmodule MyAppTest do
  use ExUnit.Case

  test "greets the given name" do
    assert MyApp.greet("template") == "Hello, template!"
  end
end
