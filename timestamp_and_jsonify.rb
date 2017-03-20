require 'json'

ARGF.each do |message|
  message.strip!
  unless message.empty?
    STDOUT.syswrite JSON.dump({ "timestamp" => Time.now.to_i, "message" => message }) + "\n"
  end
end
