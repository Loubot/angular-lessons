// Generated by CoffeeScript 1.11.1
'use strict';
angular.module('lessons').controller("RegisterController", [
  "$scope", "$rootScope", "USER", "$state", "$auth", "alertify", "COMMS", function($scope, $rootScope, USER, $state, $auth, alertify, COMMS) {
    var get_county_coords;
    console.log("RegisterController");
    USER.get_user();
    $scope.scrollevent = function($e) {};
    $scope.register_with_facebook = function() {
      return $auth.authenticate('facebook', {
        params: {
          resource_class: 'Teacher'
        }
      });
    };
    $scope.register_teacher = function() {
      var att;
      $scope.register_teacher_form.email2.$error.matching_email = false;
      $scope.register_teacher_form.confirm_password.$error.matching_password = false;
      if ($scope.teacher.email !== $scope.teacher.confirm_email) {
        console.log("Error");
        $scope.register_teacher_form.email2.$error.matching_email = true;
        return false;
      } else if ($scope.teacher.password !== $scope.teacher.confirm_password) {
        console.log("no dice");
        $scope.register_teacher_form.confirm_password.$error.matching_password = true;
        return false;
      } else {
        console.log("No error");
        $scope.register_teacher_form.email2.$error.matching_email = false;
        $scope.register_teacher_form.confirm_password.$error.matching_password = false;
        for (att in $scope.register_teacher_form.email2.$error) {
          if ($scope.register_teacher_form.email2.$error.hasOwnProperty(att)) {
            console.log(att);
            $scope.register_teacher_form.email2.$setValidity(att, true);
          }
        }
      }
      $scope.teacher.is_teacher = true;
      if ($scope.teacher.county == null) {
        return alertify.error("You must select your county");
      } else {
        console.log("made it");
        console.log($scope.county_lists["" + $scope.teacher.county]);
        return $auth.submitRegistration($scope.teacher).then(function(resp) {
          $rootScope.USER = resp.data.data;
          console.log($rootScope.USER);
          alertify.success("Welcome " + resp.data.data.email);
          if ($rootScope.USER.is_teacher) {
            alertify.success("Registered as teacher");
          }
          if (!$rootScope.USER.is_teacher) {
            alertify.success("Registered as student");
          }
          return COMMS.POST("/teacher/" + $rootScope.USER.id + "/location", get_county_coords($scope.teacher.county)).then(function(resp) {
            console.log(resp);
            alertify.success("Created location");
            return $state.go('teacher', {
              id: $rootScope.USER.id
            });
          })["catch"](function(err) {
            console.log(err);
            return alertify.error("Failed to create loctation");
          });
        })["catch"](function(resp) {
          console.log(resp);
          return alertify.error("Failed to register");
        });
      }
    };
    $scope.county_list = ['Antrim', 'Armagh', 'Carlow', 'Cavan', 'Clare', 'Cork', 'Derry', 'Donegal', 'Down', 'Dublin', 'Fermanagh', 'Galway', 'Kerry', 'Kildare', 'Kilkenny', 'Laois', 'Leitrim', 'Limerick', 'Longford', 'Louth', 'Mayo', 'Meath', 'Monaghan', 'Offaly', 'Roscommon', 'Sligo', 'Tipperary', 'Tyrone', 'Waterford', 'Westmeath', 'Wexford', 'Wicklow'];
    $scope.county_lists = {
      'Antrim': {
        latitude: 54.719508,
        longitude: -6.207256
      },
      'Armagh': {
        latitude: 54.350277,
        longitude: -6.652822
      },
      'Carlow': {
        latitude: 52.836497,
        longitude: -6.934238
      },
      'Cavan': {
        latitude: 53.989637,
        longitude: -7.363272
      },
      'Clare': {
        latitude: 52.847097,
        longitude: -8.989040
      },
      'Cork': {
        latitude: 51.897887,
        longitude: -8.475431
      },
      'Derry': {
        latitude: 54.996669,
        longitude: -7.308567
      },
      'Donegal': {
        latitude: 54.832874,
        longitude: -7.485811
      },
      'Down': {
        latitude: 54.328787,
        longitude: -5.715719
      },
      'Dublin': {
        latitude: 53.346591,
        longitude: -6.265231
      },
      'Fermanagh': {
        latitude: 54.343928,
        longitude: -7.631644
      },
      'Galway': {
        latitude: 53.270672,
        longitude: -9.056779
      },
      'Kerry': {
        latitude: 52.059816,
        longitude: -9.504487
      },
      'Kildare': {
        latitude: 53.220438,
        longitude: -6.659570
      },
      'Kilkenny': {
        latitude: 52.653411,
        longitude: -7.248446
      },
      'Laois': {
        latitude: 53.032791,
        longitude: -7.300100
      },
      'Leitrim': {
        latitude: 53.945234,
        longitude: -8.086559
      },
      'Limerick': {
        latitude: 52.664942,
        longitude: -8.628080
      },
      'Longford': {
        latitude: 53.727371,
        longitude: -7.793887
      },
      'Louth': {
        latitude: 53.999672,
        longitude: -6.406295
      },
      'Mayo': {
        latitude: 53.854566,
        longitude: -9.288492
      },
      'Meath': {
        latitude: 53.647000,
        longitude: -6.697336
      },
      'Monaghan': {
        latitude: 54.248650,
        longitude: -6.969560
      },
      'Offaly': {
        latitude: 53.275140,
        longitude: -7.493240
      },
      'Roscommon': {
        latitude: 53.627545,
        longitude: -8.189194
      },
      'Sligo': {
        latitude: 54.273910,
        longitude: -8.473718
      },
      'Tipperary': {
        latitude: 52.356254,
        longitude: -7.695380
      },
      'Tyrone': {
        latitude: 54.597003,
        longitude: -7.310752
      },
      'Waterford': {
        latitude: 52.257693,
        longitude: -7.110284
      },
      'Westmeath': {
        latitude: 53.524646,
        longitude: -7.339487
      },
      'Wexford': {
        latitude: 52.333583,
        longitude: -6.474672
      },
      'Wicklow': {
        latitude: 52.980215,
        longitude: -6.060273
      }
    };
    get_county_coords = function(county) {
      console.log(county);
      console.log($scope.county_lists["" + county]);
      return $scope.county_lists["" + county];
    };
    return console.log($scope.county_lists['Antrim']);
  }
]);
