require '../yunsdk'

def test_baidu_oauth
  oauth = YunSDK::BaiduOAuth.new(consumer_key:'xcBJlaupNmsLNmHV',
         consumer_secret:'eryHdR4EeDs6ePVb',
         oauth_callback:'http://zhaorenzhi.cn/')

  p oauth.start_authorize

  oauth.authorize_callback "http://localhost:3000/oauth_callback/baidu?code=dd8fd9b7206055fb41b408d52bf9e804" do |result|
    p result
  end
end

def test_kuaipan_oauth
  oauth = YunSDK::KuaipanOAuth.new({
    :consumer_key=>"xcBJlaupNmsLNmHV",
    :consumer_secret=>"eryHdR4EeDs6ePVb", 
    :oauth_callback=>"http://localhost:3000/oauth_callback/kuaipan"})

  oauth.start_request do |authorize_url, info|
    p authorize_url
  end
end

def test_kuaipan_callback(url)
  oauth = YunSDK::KuaipanOAuth.new({
    :consumer_key=>"xcBJlaupNmsLNmHV",
    :consumer_secret=>"eryHdR4EeDs6ePVb", 
    :oauth_callback=>"http://localhost:3000/oauth_callback/kuaipan"})
  oauth.request_callback(url) do |result|
    p result
  end
end

test_kuaipan_callback "http://localhost:3000/oauth_callback/kuaipan?oauth_verifier=479453496&oauth_token=9412f855c9804082944a9f193937b899"