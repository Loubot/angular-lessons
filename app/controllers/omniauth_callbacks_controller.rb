class OmniauthCallbacksController < DeviseTokenAuth::OmniauthCallbacksController


  def omniauth_success
    p "Auth "
    pp auth_hash

    identity = Identity.find_or_initialize_by( uid: auth_hash['uid'], provider: auth_hash['provider'] )

    if teacher_signed_in?
      p "Teacher is signed in"
    else #Teacher isn't signed in
      teacher = Teacher.find_by(email: auth_hash['info']['email'])

      if teacher # Not a new teacher
        teacher.add_identity(auth_hash)
      else

      end
    end

    render json: identity.as_json

  end

  def old_one
    @resource = resource_class.where({
      uid:      auth_hash['uid'],
      provider: auth_hash['provider']
    }).first_or_initialize
    create_token_info
    set_token_on_resource
    create_auth_params

    if resource_class.devise_modules.include?(:confirmable)
      # don't send confirmation email!!!
      @resource.skip_confirmation!
    end

    p "Teacher found"
    pp @resource

    sign_in(:teacher, @resource, store: false, bypass: false)

    if @resource
      p "hup"
      @resource.save!
    end

    yield @resource if block_given?

    render_data_or_redirect('deliverCredentials', @auth_params.as_json, @resource.as_json)
  end

  def all
    pp request.env["omniauth.auth"]
    auth = request.env["omniauth.auth"]
    # uri = redirect_path(request)
    # uri = URI.parse(URI.encode(request.env['omniauth.origin'])).path
    # puts "origin!! #{URI(request.env['omniauth.origin']).path}"
    # puts "auth  #{auth['extra']['raw_info']['email']}"
    # puts "uri: #{uri}"
    identity = Identity.find_or_initialize_by(uid: auth[:uid], provider: auth[:provider])
    
    if teacher_signed_in?  #teacher signed in
      
      if identity.new_record?  #identity is new and teacher is signed in
        current_teacher.add_identity(auth)
        puts "££££££££££££££££££1"
        flash[:success] = "Login method added"
        sign_in_and_redirect current_teacher
      else # identitiy is not new and teacher is signed in
        puts "££££££££££££££££££2"
        flash[:success] = "Login method already exists"
        sign_in_and_redirect current_teacher      
      end      
    else  #teacher not signed in
      if !(identity.new_record?) #identitiy is not new and teacher is not signed in
        puts "££££££££££££££££££3"
        @teacher = identity.teacher
        redirect_to '/', notice: "no teacher id" and return if !(identity.teacher_id) 
        flash[:success] = "#{ @teacher.email } signed in succesfully"

        sign_in_and_redirect @teacher
        
      else # identity is new and teacher is not signed in
        if (teacher = Teacher.find_by(email: auth['extra']['raw_info']['email'])) #can find a teacher
          teacher.add_identity(auth)
          puts "££££££££££££££££££4"
          flash[:success] = "#{ teacher.email } signed in with #{auth[:provider]}"
          sign_in_and_redirect teacher
          
        else #could not find teacher and identity is new
          teacher = Teacher.create_new_with_omniauth(auth, URI(request.env['omniauth.origin']).path)
          puts "££££££££££££££££££5"
          redirect_to '/' and return if !teacher.valid?
          flash[:success] = "Registered succesfully using #{auth[:provider]}"
          sign_in_and_redirect teacher
          
        end
      end
    end
  end

  alias_method :facebook, :all
end