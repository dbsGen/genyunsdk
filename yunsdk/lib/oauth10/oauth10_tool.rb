module YunSDK

end

class String
		def oauth_encode
			result = ""
			self.each_char do |c|
				if c.match(/[.\-_~a-zA-Z0-9]/)
					result += c
				else
					result += "%#{c.ord.to_s(16).upcase}"
				end
			end
			result
		end
	end