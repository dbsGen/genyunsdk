require 'net/http'
require 'net/https'
require 'digest/hmac'
require 'oauth10/oauth10_tool'
require 'json'

class OAuth10
	attr_accessor :request_path, :oauth_info, :oauth_callback
	@consumer_key
	@consumer_secret

	def initialize(params = {})
		@consumer_key = params[:consumer_key]
		@secret = params[:consumer_secret]
		@oauth_callback = params[:oauth_callback]
	end

	def startRequest 
		response = request(@request_path, 
					"GET",
				 	oauth_nonce:nonce,
					oauth_timestamp:Time.now.to_i,
				 	oauth_signature_method:"HMAC-SHA1",
				 	oauth_version:"1.0",
					oauth_consumer_key:@consumer_key,
				 	oauth_callback:@oauth_callback)

		result = JSON.parse(response.body)
		if block_given?
			yield "https://www.kuaipan.cn/api.php?ac=open&op=authorise&oauth_token=#{result['oauth_token']}"
		end
	end

	def request(path, method, params = {})

		uri = URI.parse(path)

		http = Net::HTTP.new(uri.host, uri.port)
		http.use_ssl = true if uri.scheme == 'https'

		params["oauth_signature"] = signature(method, path, params)

		uri.query = URI.encode_www_form(params)

		request = Net::HTTP::Get.new(uri.request_uri)

		http.request(request)
	end

	#
	def nonce
		"#{Time.now.to_i}#{rand}"
	end

	def signature(method, url, params = {})
		query_string = ""
		first = true
		params.keys.sort.each do |x|
			add = "#{x.to_s.oauth_encode}=#{params[x].to_s.oauth_encode}"
			query_string += first ? add : "&#{add}"
			first = false
		end
		
		data = "#{method}&#{url.oauth_encode}&#{query_string.oauth_encode}"

		begin
			oauth_secret = "#{@secret}&#{@oauth_info['oauth_token_secret']}"
		rescue Exception => e
			oauth_secret = "#{@secret}&"
		end

		Digest::HMAC.base64digest(data, oauth_secret , Digest::SHA1)
	end
end