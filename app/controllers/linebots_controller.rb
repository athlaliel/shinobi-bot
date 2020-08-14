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
      if event.message['text'].include?("パスワード")
        response = "パスワードが違う！曲者め！"
      elsif event.message["text"].include?("覚悟")
        response = "ふん、意気込みだけでは儂に勝てぬぞ"
      elsif event.message['text'].include?("姫はどこだ")
        response = "は〜ははははは！そんな小娘のことより、己自身の心配をせい！"
      elsif event.message["text"].include?("鬼")
        response = "鬼を殺したのはお前か...。かような剛の者がおったとは....。"
      elsif event.message["text"].include?("天誅")
        response = "初代天誅のゲームを作成したのはアクワイア社です"
      elsif event.message["text"].include?("卍")
        response = "ほひや〜！ごぅ！"
      elsif event.message["text"].include?("屍")
        response = "あーいけない！！"
      elsif event.message["text"].include?("待て")
        response = "良いぞ、再び相見える時が愉しみでならぬわ"
      elsif event.message["text"].include?("冥王")
        response = "幾ら鍛錬を積もうと所詮は人〜間、儚いものよ..."
      elsif event.message["text"].include?("片岡")
        response = "だが越後屋の事もある、其方も慎重にな"
      elsif event.message["text"].include?("朱雀")
        response = "戦い続けろ...強者よ、...呪え...血塗られた...己の業を..."
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
