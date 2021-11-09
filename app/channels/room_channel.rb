class RoomChannel < ApplicationCable::Channel

  # Webブラウザ側のコネクションが確立すると、subscribedメソッドが呼び出される
  def subscribed
    stream_from 'room_channel'
  end

  # コネクションが切断されると呼び出されるメソッド
  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  # receiveでdata(email, messageを受け取る)
  def receive(data)
    # emailからどのuserかを取得する
    user = User.find_by(email: data['email'])

    # メッセージを作成
    if message = Message.create(content: data['message'], user_id: user.id)

      # ActionCable.server.broadcastは、Webブラウザ全てにデータを送信するためのメソッド
      ActionCable.server.broadcast 'room_channel', { message: data['message'], name: user.name, created_at: message.created_at }
    end
  end
end
