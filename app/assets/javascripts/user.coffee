angular.module('lessons').service 'USER', [
  "$http"
  "$rootScope"
  "RESOURCES"
  "$q"
  "$state"
  "alertify"
 ( $http, $rootScope, RESOURCES, $q, $state, alertify ) ->

  get_user: -> # get user and all associations

    $q ( resolve, reject ) ->
      $http(
        method: 'GET'
        url: "#{ RESOURCES.DOMAIN }/teacher/get"
        headers: { "Content-Type": "application/json" }
        # params: 
        #   email: 
      ).then( ( result ) ->
        # console.log "get user"
        # console.log result.data
        $rootScope.USER = result.data.teacher
        
        resolve result.data
      ).catch( ( err_result ) ->
        console.log err_result
        reject err_result
      )

  check_user: ->
    if !$rootScope.USER.is_teacher
      alertify.error "You must be a teacher to view this"
      $state.go "welcome"
  
]




angular.module('lessons').factory 'User', [
  "COMMS"
  "$http"
  "$rootScope"
  "$q"
  "$state"
 ( COMMS, $http, $rootScope, $q, $state ) ->
  # instantiate our initial object

  

  User = ( cb ) ->
    self = this
    $q ( resolve, reject ) ->
      $http.get("/api/teacher/#{ $rootScope.user.id }").then( (response) ->
        
        user = self.update_all( response.data.teacher )
        resolve user
      ).catch( ( err ) ->
        console.log "failed to get teacher"
        console.log err
      )
        
        # response

  # define the getProfile method which will fetch data
  # from GH API and *returns* a promise

  User::update_all = ( teacher ) ->
    @first_name = teacher.first_name
    @last_name = teacher.last_name
    @email = teacher.email
    @id = teacher.id
    @is_teacher = teacher.is_teacher
    @overview = teacher.overview
    @profile = teacher.profile
    @view_count = teacher.view_count
    @location = teacher.location
    @photos = teacher.photos
    @qualifications = teacher.qualifications
    @subjects = teacher.subjects
    @profile_url = @.get_profile()
    $rootScope.User = @
    

  User::get_full_name = ->
    
    return @.first_name + ' ' + @.last_name

  User::update = ->
    COMMS.POST(
      "/teacher"
      @
    ).then( ( resp ) ->
      console.log "User class updated "
      console.log resp
    ).catch( ( err ) ->
      console.log "Failed to update user class"
    )

  User::update_profile = ( pic_id ) ->
    self = @
    console.log pic_id
    self.profile = pic_id
    return COMMS.PUT(
      "/teacher/#{ self.id }"
      profile: pic_id, id: $rootScope.USER.id
    ).then( ( resp ) ->
      console.log resp
      self.get_profile()
    ).catch( ( err ) ->
      console.log err 
    )

  User::change_user_type = ( type ) ->
    self = this
    self.is_teacher == type
    COMMS.POST(
      "/teacher"
      self
    ).then( ( resp ) ->
      console.log "User class updated "
      console.log resp
      $rootScope.User = self
      if $rootScope.User.is_teacher then $state.go( "teacher", id: $rootScope.User.id ) else $state.go( 'student_profile', id: $rootScope.USER.id )
    ).catch( ( err ) ->
      console.log "Failed to update user class"
    )

  User::get_location = ->
    self = this
    return self.location

  User::set_location = ( location ) ->
    self = this
    return self.location = location

  User::get_photos = ->
    
    return @.photos

  User::set_photos = ( photos ) ->
    self = this
    self.photos = photos
    return self

  User::get_subjects = ->
    self = this
    return self.subjects

  User::set_subjects = ( subjects ) ->
    self = this
    return self.subjects = subjects


  User::get_profile = ->
    for photo in @.photos
      # console.log photo.avatar.url
      if parseInt( photo.id ) == parseInt( @.profile )
        @.profile_url = photo.avatar.url
        console.log @.profile_url
    @.profile_url
        



  User


  do ->
    console.log 'do'
    console.log $rootScope.User?
    if !$rootScope.User?
      new User().then( ( res ) ->
        console.log 'end of do'
        console.log $rootScope.User
      )

]

angular.module('lessons').run [
  "$rootScope"
  "USER"
  "User"
  "$state"
  "alertify"
  ( $rootScope, USER, User, $state, alertify ) ->
    
    $rootScope.$on 'auth:validation-success', ( e ) ->
      console.log 'validation success'
      # console.log $rootScope.user

      # $rootScope.user = new User().then( ( resp ) ->
      #   console.log $rootScope.User
      #   console.log $rootScope.User.get_full_name()
      # )
      

    $rootScope.$on 'auth:validation-error', ( e ) ->
      $rootScope.User = null
      $state.go 'welcome'
      alertify.error "There was an error"
      console.log e

    $rootScope.$on 'auth-login-success', ( e, user ) ->
      console.log 'login'
      console.log e
      console.log user

]