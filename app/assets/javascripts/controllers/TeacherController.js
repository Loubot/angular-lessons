// Generated by CoffeeScript 1.10.0
'use strict';
angular.module('lessons').controller('TeacherController', [
  '$scope', '$rootScope', '$state', 'RESOURCES', 'USER', 'alertify', 'COMMS', '$stateParams', '$auth', 'Upload', '$mdBottomSheet', function($scope, $rootScope, $state, RESOURCES, USER, alertify, COMMS, $stateParams, $auth, Upload, $mdBottomSheet) {
    var profile_pic;
    console.log("TeacherController");
    $scope.photos = null;
    $scope.upload = function(file) {
      return Upload.upload({
        url: RESOURCES.DOMAIN + "/teacher/pic",
        file: $scope.file,
        avatar: $scope.file,
        data: {
          avatar: $scope.file,
          id: $rootScope.USER
        }
      }).then(function(resp) {
        console.log(resp);
        if (resp.data !== "") {
          $scope.photos = resp.data.photos;
        }
        alertify.success("Photo uploaded ok");
        if (resp.data.status === "updated") {
          $rootScope.USER = resp.data.teacher;
          profile_pic();
          alertify.success("Profile pic set");
        }
        return $scope.file = null;
      })["catch"](function(err) {
        return console.log(err);
      });
    };
    if (!($rootScope.USER != null)) {
      USER.get_user().then(function(user) {
        alertify.success("Got user");
        console.log($rootScope.USER.overview === null);
        if ($rootScope.USER.id !== parseInt($stateParams.id)) {
          $state.go('welcome');
          alertify.error("You are not allowed to view this");
          return false;
        }
        return COMMS.GET("/teacher/profile", {
          id: $rootScope.USER.id
        }).then(function(resp) {
          console.log(resp);
          $scope.photos = resp.data.photos;
          $scope.subjects = resp.data.subjects;
          $scope.experiences = resp.data.experiences;
          $scope.quals = resp.data.qualifications;
          return profile_pic();
        })["catch"](function(err) {
          return console.log(err);
        });
      })["catch"](function(err) {
        alertify.error("No user");
        $rootScope.USER = null;
        $state.go('welcome');
        return false;
      });
    }
    $scope.make_profile = function(id) {
      return COMMS.POST('/teacher', {
        profile: id,
        id: $rootScope.USER.id
      }).then(function(resp) {
        console.log(resp);
        alertify.success("Updated profile pic");
        if (resp.data.status === "updated") {
          $rootScope.USER = resp.data.teacher;
          return profile_pic();
        }
      })["catch"](function(err) {
        console.log(err);
        return alertify.error("Failed to update profile");
      });
    };
    profile_pic = function() {
      var i, len, photo, ref, results;
      ref = $scope.photos;
      results = [];
      for (i = 0, len = ref.length; i < len; i++) {
        photo = ref[i];
        if (parseInt(photo.id) === parseInt($rootScope.USER.profile)) {
          $scope.profile = photo.avatar.url;
          console.log($scope.profile);
          results.push($scope.profile_pic);
        } else {
          results.push(void 0);
        }
      }
      return results;
    };
    $scope.get_subjects = function() {
      console.log($scope.searchText);
      return COMMS.GET('/subjects', {
        search: $scope.searchText
      }).then(function(resp) {
        console.log(resp);
        $scope.subjects = resp.data;
        return resp.data;
      })["catch"](function(err) {
        console.log(err);
        return alertify.error("Failed to get subjects");
      });
    };
    $scope.select_subject = function(subject) {
      return COMMS.POST("/teacher/add-subject", {
        subject: subject,
        teacher: $rootScope.USER
      }).then(function(resp) {
        console.log(resp);
        alertify.success("Successfully added subject");
        return $scope.subjects = resp.data.subjects;
      })["catch"](function(err) {
        console.log(err);
        if (err.data.error != null) {
          alertify.error(err.data.error);
        }
        return $scope.subjects = err.data.subjects;
      });
    };
    $scope.remove_subject = function(subject) {
      return COMMS.DELETE('/teacher/remove-subject', {
        subject: subject
      }).then(function(resp) {
        console.log(resp);
        alertify.success("Successfully removed subject");
        return $scope.subjects = resp.data.subjects;
      })["catch"](function(err) {
        console.log(err);
        return alertify.error(err.data.error);
      });
    };
    $scope.add_experience = function() {
      return COMMS.POST("/experience", $scope.experience).then(function(resp) {
        console.log(resp);
        $scope.experiences = resp.data.experiences;
        alertify.success("Experience added");
        $scope.experience.title = null;
        return $scope.experience.description = null;
      })["catch"](function(err) {
        console.log(err);
        return alertify.error("Failed to add experience");
      });
    };
    $scope.remove_experience = function(experience) {
      return COMMS.DELETE("/experience/" + experience.id, experience).then(function(resp) {
        console.log(resp);
        $scope.experiences = resp.data.experiences;
        return alertify.success("Removed experience");
      })["catch"](function(err) {
        console.log(err);
        return alertify.error("Failed to delete subject");
      });
    };
    $scope.update_teacher = function() {
      return COMMS.POST('/teacher', $scope.USER).then(function(resp) {
        console.log(resp);
        alertify.success("Updated your profile");
        $rootScope.USER = resp.data.teacher;
        return $mdBottomSheet.hide();
      })["catch"](function(err) {
        console.log(err);
        return alertify.error("Failed to update teacher");
      });
    };
    $scope.create_qualification = function() {
      return COMMS.POST("/teacher/" + $rootScope.USER.id + "/qualification", $scope.qualification).then(function(resp) {
        console.log(resp);
        $scope.quals = resp.data.qualifications;
        alertify.success("Created qualification");
        console.log($scope.quals);
        return $mdBottomSheet.hide();
      })["catch"](function(err) {
        console.log(err);
        return alertify.error(err.errors.full_messages);
      });
    };
    $scope.show_overview_sheet = function() {
      return $mdBottomSheet.show({
        templateUrl: "sheets/overview_sheet.html",
        controller: "TeacherController"
      });
    };
    return $scope.show_qualification_sheet = function() {
      return $mdBottomSheet.show({
        templateUrl: "sheets/qualification_sheet.html"
      });
    };
  }
]);
