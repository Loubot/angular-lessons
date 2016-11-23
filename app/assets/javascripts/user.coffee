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
 ( COMMS, $http, $rootScope, $q ) ->
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
    @first_name = teacher.first_name || null
    @last_name = teacher.last_name || null
    @email = teacher.email || null
    @id = teacher.id || null
    @is_teacher = teacher.is_teacher || null
    @overview = teacher.overview || null
    @profile = teacher.profile || null
    @view_count = teacher.view_count || null
    @location = teacher.location || null
    @photos = teacher.photos || null
    @qualifications = teacher.qualifications || null
    @subjects = teacher.subjects || null
    $rootScope.User = @
    console.log "Instantiated"
    return $rootScope.User
    

  User::get_full_name = ->
    
    return @.first_name + ' ' + @.last_name

  User::update = ->
    COMMS.POST(
      "/teacher"
      @
    ).then( ( resp ) ->
      console.log "User class updated "
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