require "thx_cli"
require "thor"
require "faraday"
require "json"
require "pp"
require "yaml"

module ThxCli
  class CLI < Thor
    class_option :help, :type => :boolean, :aliases => '-h', :desc => 'help message.'
    class_option :version, :type => :boolean, :aliases => '-v', :desc => 'version'
    API_VERSION = "v1"

    desc "configure", "Configure Thx CLI command."
    def configure
      @api_host, email, password, password_confirmation = "", "", "", ""
      while @api_host.empty?
        @api_host = ask("API HOST (required): ")
      end
      while email.empty?
        email = ask("Email (required): ")
      end
      while password.empty?
        password = ask("Password (required): ")
      end
      while password_confirmation.empty?
        password_confirmation = ask("Password Confirmation (required): ")
      end
      name = ask("Your name (optional): ")
      @conn = Faraday.new(url: "http://#{@api_host}", headers: { 'Content-Type' => 'application/json' })
      begin
        res = @conn.post do |req|
          req.url "/#{API_VERSION}/users"
          req.body = {
            email: email,
            password: password,
            password_confirmation: password_confirmation,
            name: name
          }.to_json
        end
      rescue => e
        say(e.message)
        return false
      end
      body = JSON.parse res.body
      unless res.success?
        say(body["developerMessage"])
        return false
      end
      say(body)
      sign_in(email, password)
      say("ログインに成功しました。")
    end

    desc "sign_in", "Sign in command."
    def sign_in(email="", password="")
      begin
        res = @conn.post do |req|
          req.url "/#{API_VERSION}/users/sign_in"
          req.body = {
            email: email,
            password: password
          }.to_json
        end
      rescue => e
        say(e.message)
        return false
      end
      body = JSON.parse res.body
      unless res.success?
        say(body["developerMessage"])
        return false
      end
      body["api_host"] = @api_host
      YAML.dump(body, File.open('credentials.yml', 'w'))
    end

    desc "ls", "show users list"
    def ls
      credential = open('credentials.yml', 'r') { |f| YAML.load(f) }
      conn = Faraday.new(url: "http://#{credential["api_host"]}", headers: { 'Content-Type' => 'application/json', 'Authorization' => "Bearer #{credential["access_token"]}" })
      begin
        res = conn.get do |req|
          req.url "/#{API_VERSION}/users/"
        end
      rescue => e
        say(e.message)
        return false
      end
      body = JSON.parse res.body
      pp body
    end
  end
end