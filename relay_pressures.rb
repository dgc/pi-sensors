require 'json'

ARGF.each do |message|
  message.strip!
  unless message.empty?

    bits = message.split(',').map { |x| x.strip }

    result = {}

    result["timestamp"] = Time.now.to_i

    result["0"] = bits[1] if bits[0] == "0"
    result["1"] = bits[3] if bits[2] == "0"
    result["2"] = bits[5] if bits[4] == "0"
      
    STDOUT.syswrite JSON.dump(result) + "\n"
  end
end
