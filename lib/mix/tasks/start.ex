defmodule Mix.Tasks.Start do
  require Circuits.UART
  use Mix.Task


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
     # Tortoise.publish(LoraSerial,"subscription",text)

    end
    serial_get()
  end
  def run(_), do:  main()
  def main do
    alias Mix.Tasks.Start, as: Start


    {:ok,uart_pid} = Circuits.UART.start_link
    port = Start.serial_port
    IO.puts "The Serial port of the Arduino is #{port}"
    IO.puts "Process ID of serial Genserver is #{inspect uart_pid}"
    if Circuits.UART.open(uart_pid, port, speed: 115200, active: true) ==:ok do
      IO.puts "#{port}: Opened successfully"
      Circuits.UART.configure(uart_pid, framing: {Circuits.UART.Framing.Line, separator: "\r\n"})
      Circuits.UART.configure(uart_pid, id: :pid)
      IO.puts "Serial configuration completed"


    #  Tortoise.Supervisor.start_child(
     #   client_id: "my_client_id",
      #  handler: {Tortoise.Handler.Logger, []},
      # 3 server: {Tortoise.Transport.Tcp, host: 'localhost', port: 1883},
       # subscriptions: [{"foo/bar", 0}])

      # publish a message on the broker
      #Tortoise.publish("my_client_id", "foo/bar", "Hello from the World of Tomorrow !", qos: 0)
      serial_get()

    else
      IO.puts "#{port}: IO ERROR"
    end
  end

  @moduledoc false
  
end


