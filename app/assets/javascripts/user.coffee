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
        # $rootScope.USER = result.data.teacher
        
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

angular.module('lessons').value 'Users',
  first_name: ''
  last_name: ''
  email: ''
  get_all: ->



angular.module('lessons').factory 'User', ($http, $rootScope, Users) ->
  # instantiate our initial object

  User = () ->
    @first_name =  ''
    @last_name = ''
    @email = ''
    @id = 0

  # define the getProfile method which will fetch data
  # from GH API and *returns* a promise

  User::update_all = ( teacher ) ->
    # console.log teacher
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
    # console.log @.get_full_name()
    return

  User::get_full_name = ->
    console.log @
    return @.first_name + ' ' + @.last_name

  User::get_location = ->
    self = this
    return self.location

  User::set_location = ( location ) ->
    self = this
    return self.location = location

  User::get_photos = ->
    console.log @
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


  User::get_all = ( cb )->
    # Generally, javascript callbacks, like here the $http.get callback,
    # change the value of the "this" variable inside it
    # so we need to keep a reference to the current instance "this" :
    self = this
    $http.get("/api/teacher/#{ $rootScope.user.id }").then (response) ->
      
      self.update_all( response.data.teacher )
      cb( null, response )
      response

  User



angular.module('lessons').run [
  "$rootScope"
  "USER"
  "User"
  ( $rootScope, USER, User ) ->

    $rootScope.$on 'auth:validation-success', ( e ) ->
      console.log 'validation success'
      # console.log $rootScope.user

      $rootScope.USER = new User()
      console.log $rootScope.USER
      $rootScope.USER.get_all( ( err, resp ) ->
        console.log $rootScope.USER.get_full_name()
        if err?
          console.log err
        else
          console.log resp

      )
      
      
   
      
      
      

      

    $rootScope.$on 'auth:validation-error', ( e ) ->
      console.log 'validation error '
      console.log e

    $rootScope.$on 'auth-login-success', ( e, user ) ->
      console.log 'login'
      console.log e
      console.log user

]