defmodule SerialMqttTest do
  use ExUnit.Case
  doctest SerialMqtt

  test "greets the world" do
    assert SerialMqtt.hello() == :world
  end
end
