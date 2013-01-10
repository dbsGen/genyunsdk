require 'digest/hmac'
require 'oauth10/oauth10_tool'
require 'json'
require 'tools/request'

module YunSDK

	class OAuth10
		attr_accessor 	:request_path,
						:access_path,
						:authorize_path,
						:oauth_info,
						:oauth_callback
		@consumer_key
	  	@consumer_secret

		public
		def initialize(params = {})
			@consumer_key = params[:consumer_key]
			@consumer_secret = params[:consumer_secret]
			@oauth_callback = params[:oauth_callback]
		end

		def start_request 
			response = request_oauth10(@request_path, 
						"GET",
						nil ,
					 	oauth_nonce:Request.nonce,
						oauth_timestamp:Time.now.to_i,
					 	oauth_signature_method:"HMAC-SHA1",
					 	oauth_version:"1.0",
						oauth_consumer_key:@consumer_key,
					 	oauth_callback:@oauth_callback)

			result = JSON.parse(response.body)
			if result["oauth_token"]	
				self.oauth_info = result
				if block_given?
					yield "#{@authorize_path}#{result['oauth_token']}", result
				end
			else
				if block_given?
					yield 
				end
			end

		end

		def request_callback(url)
			uri = URI.parse(url)

			params = URI.decode_www_form(uri.query)

			token, verifier = Request.parse_uri_query(params, ["oauth_token", "oauth_verifier"]) 
			
			if token && verifier && @oauth_info
				response = request_oauth10(
							@access_path,
							"GET",
							@oauth_info["oauth_token_secret"],
							oauth_consumer_key:@consumer_key,
							oauth_signature_method:"HMAC-SHA1",
							oauth_timestamp:Time.now.to_i,
							oauth_nonce:Request.nonce,
							oauth_version:"1.0",
							oauth_token:token,
							oauth_verifier:verifier)
				if block_given?
					yield JSON.parse(response.body)
				end 
			else 
				if block_given?
					yield 
				end
			end
		end

		private

		def request_oauth10(path, method, secret, params = {})
			params["oauth_signature"] = Request.signature(method, path, @consumer_secret ,secret, params)
			Request.request(path, method, params)
		end

		
	end

end