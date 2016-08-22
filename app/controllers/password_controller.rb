module DeviseTokenAuth
  class SessionsController < ::DeviseTokenAuth::SessionsController
    # note :: for loading root constants(::DeviseTokenAuth::SessionsController)
    # otherwise you'll get circular dependency error

    def create 
      p "hup !!!!!!!!!!!!!!"

    end
    protected
    # custom rendering
  end
end