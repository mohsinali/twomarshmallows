RedisBrowser::Web.class_eval do
  use Rack::Auth::Basic, "Protected Area" do |username, password|
    username == 'foo' && password == 'bar'
  end
end