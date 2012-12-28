require '../oauth10/oauth10'

oauth = OAuth10.new(consumer_key:'xcBJlaupNmsLNmHV',
			 consumer_secret:'eryHdR4EeDs6ePVb',
			 oauth_callback:'http://zhaorenzhi.cn/')
oauth.request_path = 'https://openapi.kuaipan.cn/open/requestToken'

oauth.startRequest  do |authorizeUrl|
	p authorizeUrl
end
