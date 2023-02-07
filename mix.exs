defmodule SerialMqtt.MixProject do
  use Mix.Project

  def project do
    [
      app: :serial_mqtt,
      version: "0.1.0",
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end
  #def start(_type,_args) do
  #  IO.puts "This is now starting the module"
  #end
  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {Mqtt,[]},
      extra_applications: [:logger]
    #,mod: {SerialMqtt,[]}


    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
        {:circuits_uart, "~> 1.3"},
        #{:emqtt, "~> 1.2"}
        {:tortoise, "~> 0.10.0"}
      #{:jackalope, "~> 0.7.2"}
        #{:mqtt_potion, github: "brianmay/mqtt_potion", branch: "master"}
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
    ]
  end
end
