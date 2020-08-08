require "json"
require "openssl"
require "faraday"
require "mimemagic"


class GroupMeApi

  def self.post_message(text, bot_id, attachment=nil)
    body = { bot_id: bot_id, text: text }
    unless attachment == nil
      body[:attachments] = [attachment]
    end
    header = { 'Content-Type': "text/json" }
    if DEV == true # Heroku SSL path is different than local
      connection = Faraday.new(GROUPME_POST_URL, :ssl => { :ca_path => CERT_PATH })
    else
      connection = Faraday.new(GROUPME_POST_URL, :ssl => { :ca_file => CERT_PATH })
    end
    resp = connection.post do |req|
      req.headers["Content-Type"] = "application/json"
      req.body = body.to_json
    end
  end

  def self.post_image(file)
    if DEV == true # Heroku SSL path is different than local
      connection = Faraday.new(GROUPME_IMAGE_URL) do |f|
        f.ssl.ca_path = CERT_PATH
        f.request :multipart
        f.request :url_encoded
        f.adapter :net_http
      end
    else
      connection = Faraday.new(GROUPME_IMAGE_URL) do |f|
        f.ssl.ca_file = CERT_PATH
        f.request :multipart
        f.request :url_encoded
        f.adapter :net_http
      end
    end
    post = connection.post do |req|
      req.headers["Content-Type"] = MimeMagic.by_magic(file).type
      req.headers["X-Access-Token"] = GROUPME_ACCESS_TOKEN
      req.headers["Content-Length"] = file.size.to_s
      req.body = Faraday::UploadIO.new(file.path, 'image/jpeg')
    end
    if post.success?
      return JSON.parse(post.body)["payload"]["url"]
    else
      raise StandardError.new "Unable to upload image"
    end
  end

end