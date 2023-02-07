defmodule Mqtt.Handler do
 # use Tortoise.Handler
  #require Tortoise
  require Circuits.UART
  import Kernel
  @subscription "loraserial/"
  def serial_port do
    Enum.join(Map.keys(Circuits.UART.enumerate))
  end

  def serial_get() do
    receive do

      {:circuits_uart,pid,{:error,error}} ->
        IO.puts "An error occured: #{inspect error}"
        IO.puts "Restart required"

      {:circuits_uart,pid,text} ->

        IO.puts "Recieved #{inspect text} from Serial"
       # :ok = Tortoise.publish(MqttLora,"testserial",text)
        #:emqtt.publish()
      Tortoise.publish(MqttLora,"#{@subscription}",text)


    end
    serial_get()
  end
  def init(args) do

  {:ok, mqtt_pid} =Tortoise.Connection.start_link(
      client_id: MqttLora,
     handler: {Tortoise.Handler.Logger, []},
      server: {Tortoise.Transport.Tcp, host: 'test.mosquitto.org' , port: 1883 }
    )

    IO.puts "Mqtt Client running on processID: #{inspect mqtt_pid}"

    alias Mqtt.Handler, as: Start
    {:ok,uart_pid} = Circuits.UART.start_link
    {:ok,args}
    port = Start.serial_port
    IO.puts "The Serial port of the Arduino is #{port}"
    IO.puts "Process ID of serial Genserver is #{inspect uart_pid}"
    if Circuits.UART.open(uart_pid, port, speed: 115200, active: true) ==:ok do
      IO.puts "#{port}: Opened successfully"
      Circuits.UART.configure(uart_pid, framing: {Circuits.UART.Framing.Line, separator: "\r\n"})
      Circuits.UART.configure(uart_pid, id: :pid)
      IO.puts "Serial configuration completed"





      # publish a message on the broker
      serial_get()

    else
      IO.puts "#{port}: IO ERROR"
    end


end
  def child_spec(opts) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :init, [opts]},
      type: :worker,
      restart: :permanent,
      shutdown: 500
    }
  end

  
end
