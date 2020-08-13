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

  def callback

    # Postモデルの中身をランダムで@postに格納する
    @post=Post.offset( rand(Post.count) ).first
    body = request.body.read

    signature = request.env['HTTP_X_LINE_SIGNATURE']
    unless client.validate_signature(body, signature)
      head :bad_request
    end

    events = client.parse_events_from(body)

    events.each { |event|

      # event.message['text']でLINEで送られてきた文書を取得
      if event.message['string'].include?("パスワード")
        response = "パスワードが違う！曲者め！"
      elsif event.message["string"].include?("退け")
        response = "我が剣の切れ味、身を以て知るがいい"
      elsif event.message['string'].include?("何奴")
        response = "我が名は鬼陰、いずれ郷田共々に貴様の首を貰い受ける"
      elsif event.message['string'].include?("疲れた")
        response = "何やら不穏な空気.....早く戻らねば"
      # elsif event.message['text'].include?("お金")
      #   response = "己の悪行、地獄で悔いるがいい"
      # elsif event.message['text'].include?("遅刻")
      #   response = "遅れまして、誠に申し訳ございませぬ"
      # elsif event.message['text'].include?("眠い")
      #   response = "おかしな奴め、迷わず成仏せい"
      # elsif event.message['text'].include?("女")
      #   response = "女子が門前で夜稽古とは.....物騒な..."
      elsif event.message['string'].include?("覚悟")
        response = "ふん、意気込みだけでは儂に勝てぬぞ"
      elsif event.message['string'].include?("姫はどこだ")
        response = "そんな小娘のことより、己自身の心配をせい"
      else
        response = @post.name
      end
      #if文でresponseに送るメッセージを格納

      case event
      when Line::Bot::Event::Message
        case event.type
        when Line::Bot::Event::MessageType::Text
          message = {
            type: 'string',
            text: response
          }
          client.reply_message(event['replyToken'], message)
        end
      end
    }
    head :ok
  end
end
