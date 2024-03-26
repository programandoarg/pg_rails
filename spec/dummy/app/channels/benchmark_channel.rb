class BenchmarkChannel < ActionCable::Channel::Base
  def subscribed
    stream_from 'my_stream'
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def broadcast(data)
    # byebug
    # puts "aslkdjask"
    # AnyCable.broadcast("my_stream", { text: data['message'] })
    ActionCable.server.broadcast('my_stream', data['message'])
  end

  def echo(_data)
    # byebug
    # puts "aslkdjask"
    AnyCable.broadcast('my_stream', 'ECHOOO')
    # ActionCable.server.broadcast("some_channel", "ECHOOO")
  end
end
