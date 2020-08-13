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
      if event.message['text'].include?("麺カタ")
        response = "コッテリ！！！！！！！！"
      elsif event.message["text"].include?("マキシマムザホルモン")
        response = "ダメチンポ！！！！！！！！"
      elsif event.message['text'].include?("予習")
        response = "復讐"
      elsif event.message['text'].include?("394")
        response = "kill all the mi○i!!!!!"
      elsif event.message['text'].include?("winny")
        response = "俺たちは絶対許さへんでぇ！"
      elsif event.message['text'].include?("霊霊霊霊霊霊霊霊")
        response = "魔魔魔魔魔魔魔魔"
      elsif event.message['text'].include?("パトカー")
        response = "燃やす"
      elsif event.message['text'].include?("チューチューラブリームニムニムラムラ")
        response = "プリンプリンボロンヌルルレロレロ"
      elsif event.message['text'].include?("ダメチンポ握れ")
        response = "GET UP BOYS！！！！！！！！"
      elsif event.message['text'].include?("益山曜")
        response = "駆け出しエンジニア"
      elsif event.message['text'].include?("浦野祐作")
        response = "ようの尊敬する天才エンジニア＠いつも助かってます"
      else
        response = @post.name
      end
      #if文でresponseに送るメッセージを格納

      case event
      when Line::Bot::Event::Message
        case event.type
        when Line::Bot::Event::MessageType::Text
          message = {
            type: 'text',
            text: response
          }
          client.reply_message(event['replyToken'], message)
        end
      end
    }
    head :ok
  end
end
