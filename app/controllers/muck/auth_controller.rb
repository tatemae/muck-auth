class Muck::AuthController < ApplicationController
  
  def callback
    debugger
    # store the returned values
    #env['rack.auth']
    {
      'uid' => '12356',
      'provider' => 'twitter',
      'user_info' => {
        'name' => 'User Name',
        'nickname' => 'username',
        # ...
      }
    }
    t = 0
  end
  
end