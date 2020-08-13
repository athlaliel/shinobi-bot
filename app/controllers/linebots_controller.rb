class LinebotsController < ApplicationController
  require 'line/bot'  # gem 'line-bot-api'

  # callbackアクションのCSRFトークン認証を無効
  protect_from_forgery :except => [:callback]

  def client
    @client ||= Line::Bot::Client.new { |config|
      config.channel_secret = ENV['LINE_BOT_CHANNEL_SECRET']
      config.channel_token = ENV['LINE_BOT_CHANNEL_TOKEN']
    }
  end

  def send(line_ids, message)

    @post=Post.offset( rand(Post.count) ).first
    # Postからランダムで返事を選ぶ。
      post('/v1/events', {
            to: line_ids,
            content: {
                contentType: ContentType::TEXT,
                toType: ToType::USER,
                text: @post.name #返事をPostから取ってくる。
            },
            toChannel: TO_CHANNEL,
            eventType: EVENT_TYPE,
        })

end
