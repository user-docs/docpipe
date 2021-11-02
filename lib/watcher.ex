defmodule Docpipe.Watcher do
  use GenServer

  def start_link(args) do
    IO.puts("Starting watcher")
    GenServer.start_link(__MODULE__, args)
  end

  def init(_args) do
    IO.puts("Init watcher")
    {:ok, watcher_pid} = FileSystem.start_link(dirs: [Application.get_env(:docpipe, :input_dir)])
    FileSystem.subscribe(watcher_pid)
    {:ok, %{watcher_pid: watcher_pid}}
  end

  def handle_info({:file_event, watcher_pid, {path, events}}, %{watcher_pid: watcher_pid}=state) do
    Docpipe.FileProcessor.apply(path)
    {:noreply, state}
  end

  def handle_info({:file_event, watcher_pid, :stop}, %{watcher_pid: watcher_pid}=state) do
    IO.puts("FS Event (stop)")
    {:noreply, state}
  end
end
