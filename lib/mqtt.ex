defmodule Mqtt do
  @moduledoc false
  
  use Application
  use Supervisor
  require Mqtt.Handler

  def start(_type,_args) do
    start_link(_args)
   Mqtt.Handler.init(_args)
  end
@impl true
  def init(_opts) do
    children = [
    #{Mqtt.Handler,[]},
     # {Tortoise.Connection,
      #  [
       #   client_id: LoraSerial,
        #  server: {
         #   Tortoise.Transport.Tcp,
          #  host: 'public.mqtthq.com',# Application.get_env(:mqttconf, :mqtt_host),
           # port: 1883,
         # },
        #handler: {Mqtt.Handler,[]}
        #]}
    ]
    opts = [strategy: :one_for_one, name: Mqtt.Supervisor]
    IO.puts " We got here"
    Supervisor.init(children, opts)

  end
  def start_link(opts) do
    Supervisor.start_link(__MODULE__, opts, name: __MODULE__)
  end
end