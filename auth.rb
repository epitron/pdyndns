module Sinatra
  module Authorization
   
    def auth
      @auth ||= Rack::Auth::Basic::Request.new(request.env)
    end
   
    def unauthorized!(realm="pdyndns")
      headers 'WWW-Authenticate' => %(Basic realm="#{realm}")
      throw :halt, [ 401, 'Authorization Required' ]
    end
   
    def bad_request!
      throw :halt, [ 400, 'Bad Request' ]
    end
   
    def authorized?
      request.env['REMOTE_USER']
    end
   
    def authorize(username, password)
      username == "admin" and password == "seeecrreetttsss"
    end
   
    def authenticated!
      return          if authorized?
      unauthorized!   unless auth.provided?
      bad_request!    unless auth.basic?
      unauthorized!   unless authorize(*auth.credentials)
      
      request.env['REMOTE_USER'] = auth.username
    end
   
  end
end
