var kGlobalValuesId = "vlukXcEDqN";

var defaults={
    CareMob: {
        hidden:false,
        featured: false,
        points:0,
        level:0,
		effectivePoints:0,
		todayPoints:0,
		totalMobActions:0,
		totalMobActionValue:0,
		effectiveTotalMobActionValue:0,
		totalMobActionValueToday:0,
    },
    MobAction: {
        value:0,
        points:0,        
    },
    SubMob: {
	    actionType:"hold",
        totalUsers:0,
        level: 0,
        points:0,   
		effectivePoints:0,
		todayPoints:0,
        totalMobActions:0,		
		totalMobActionValue:0,
		effectiveTotalMobActionValue:0,
		totalMobActionValueToday:0,
    }
}

/////////////////////////////////
// before/afterSave
/////////////////////////////////
Parse.Cloud.beforeSave(Parse.User, function(request, response) {
  if (request.object.isNew()) {
    request.object.set("points",0);
    request.object.set("effectivePoints",0);
    request.object.set("todayPoints", 0);
    request.object.set("level",0);
    request.object.set("effectivePoints",0);
    request.object.set("todayPoints",0);
    request.object.set("totalMobActions", 0);
    request.object.set("totalMobActionValue", 0);
    request.object.set("effectiveTotalMobActionValue",0);
    request.object.set("totalMobActionValueToday", 0);
    request.object.set("influence", 0);
    request.object.set("effectiveInfluence", 0);
    request.object.set("todayInfluence", 0);
    request.object.set("subMobsStarted", 0);
    request.object.set("mobActionsCreated", 0);
    request.object.set("followerCount", 0);
    request.object.set("followingCount", 0);

    response.success();
  } else {
	// See if user leveled up
	var user = request.object;
	
	var points = user.get("points");
	var oldLevel = user.get("level");
	var newLevel = calculateUserLevelForPoints(points);
	
	if (oldLevel < newLevel) {
	  user.set("level", newLevel);
	  CreateActivity_UserLeveledUp(user).then(
	    function() {
		  response.success();
	    },
	    function(error) {
		  response.success();
	    }	
	  );
	} else {
	  response.success();
	}
  }
});

Parse.Cloud.beforeSave("RedeemablePoints", function(request, response) {
  if (request.object.isNew()) {
	request.object.set("wasRedeemed", false);
	response.success();
  } else {
    response.success();	
  }
});

Parse.Cloud.beforeSave("MobActionFootprint", function(request, response) {
  Parse.Cloud.useMasterKey();

  DeleteAllMobActionFootprintsForUser(request.user).then(
    function() {
		/*
		var footprint = request.object;
		var careMob = footprint.get("careMob");
		var subMob = footprint.get("subMob");
		
		var careMobQuery = new Parse.Query("CareMob");
		careMobQuery.equalTo("objectId", careMob.id);
		careMobQuery.include("subMobs");
		careMobQuery.first().then(
			function(obj) {
				var careMob = obj;
				var subMobs = careMob.get("subMobs");
				
				if (careMob.get("sourceUser") != undefined && request.user.id == careMob.get("sourceUser").id && (careMob.get("originalCategory") == undefined || careMob.get("originalCategory") == "")) {
					var category = "";
					for (var i = 0; i < subMobs.length; i++) {
						var nextSubMob = subMobs[i];
						if (nextSubMob.id == subMob.id) 
							category = nextSubMob.get("category");
					}	
				
				    if (category != "") {
				    	careMob.set("originalCategory", category);
						careMob.save().then(
							function() {
								CreateActivity_UserCreatedCareMob(user, careMob, subMob).then(
									function() {
										response.success();
									}, 
									function(error) {
										response.success();
									}
								)
							}, 
							function(error) {
								response.success();
							}
						)
				    } else {
				    	response.success();				
				    }
					
				} else {
					response.success();				
				}
			},
			function(error) {
				response.error(error);
			}
		)	
		*/
		response.success();
    },
    function(error) {
	  response.error(error);
    }	
  );
	
});

Parse.Cloud.beforeSave("CareMob", function(request, response) {
    var mobObject = request.object;
    /* we return if the save is not for a new object 
     * we return success because this is not an error, only that we don't have to do any action 
     * */
    if (!mobObject.isNew()) response.success();        
     
    //we get the admin rights, to not be limited by the access rights of the current user
    Parse.Cloud.useMasterKey();  
         
    if (defaults.CareMob) {
        for (var defaultKey in defaults.CareMob) {    
            mobObject.set(defaultKey, defaults.CareMob[defaultKey]);
        }
    }
    if (Parse.User.current()) {
        mobObject.set("createdBy",Parse.User.current());
    }
    else {
        //mobObject.set("createdBy",request.object.user);
    }
    var categoriesQuery = new Parse.Query("Categories");
    //we get all the categories to create "6" SubMob objects
    var listSubMobs=new Array();
    categoriesQuery.find().then(function(categories){
        for (var i = 0; i < categories.length; ++i) {
            var SubMob=Parse.Object.extend("SubMob");
            var SubMobObject = new SubMob();
            /** set action type with category name */
            SubMobObject.set("category", categories[i].get("name"));
            /** setting the defaults */
            if (defaults.SubMob) {
                for (var defaultKey in defaults.SubMob) {        
                    SubMobObject.set(defaultKey, defaults.SubMob[defaultKey]);
                }
            }    
            listSubMobs[i]=SubMobObject;
        }
        //create all categories in SubMob
        Parse.Object.saveAll(listSubMobs,{
            success: function(list) {
                var subMobArray=[];
                for (var i = 0; i < list.length; ++i) {
                    subMobArray[i]=list[i];
                }
                mobObject.set("subMobs",subMobArray);
				
				response.success();
            },
            error: function(error) {
                response.error("failure on creating categories in SubMob")
            }
             
        });
    });     
 
});
  
Parse.Cloud.afterSave("CareMob", function(request) {
	Parse.Cloud.useMasterKey();
  
	if (!request.object.existed()) {
  		var careMob = request.object;
  
		// If this is a user created mob, send the notification to followers
		if (careMob.get("sourceUser") != undefined && careMob.get("originalCategory") != undefined) {
  			CreateActivity_UserCreatedCareMob(careMob.get("sourceUser"), careMob, careMob.get("originalCategory"));
		}
	}
});

Parse.Cloud.beforeSave("MobAction", function(request, response) {
	Parse.Cloud.useMasterKey(); 
	
	// In this before save, we need to update the points for this MobAction and propogate them up the 
	// object hierarchy (MobAction -> SubMob -> CareMob) as well as apply points to the User
	
	// We also need to keep track of the difference in value from the last time this MobAction was saved, so we
	// can propogate the new value up to the parent SubMob
	
	var mobAction = request.object;
	
	var User = Parse.Object.extend("_User");
	var user = new User();
	user.id = mobAction.get("user").id;
	
	var CareMob = Parse.Object.extend("CareMob");
	var careMob = new CareMob();
	careMob.id = mobAction.get("careMob").id;
	
	var SubMob = Parse.Object.extend("SubMob");
	var subMob = new SubMob();
	subMob.id = mobAction.get("subMob").id;
	
	// GlobalValues is a single object class that aggregates total values -- its ID is known
	var GlobalValues = Parse.Object.extend("GlobalValues");
	var globalValues = new GlobalValues();
	globalValues.id = kGlobalValuesId;
	
	var followingUser = mobAction.get("followingUser");
	
	if (mobAction.isNew()) {
		// Set points to default of 0
		mobAction.set("points", 0);
	}
	
	if (mobAction.get("points") == undefined) mobAction.set("points",0);
	
	var points = mobAction.get("points");
	var value = mobAction.get("value");
	var lastValue = mobAction.get("lastValue");
	if (lastValue == undefined) lastValue = 0;
	
	var newPoints = calculateMobActionPointsForTime(value);
	
	//if (newPoints > points) {    // NOTE: we are updating more than just points now, so we run through this update every time
		var pointsDiff = newPoints - points;
		var valueDiff = value - lastValue;
		
		mobAction.set("points", newPoints);
        mobAction.set("lastValue", value);

		var list = [];
		list.push(user);
		list.push(careMob);
        list.push(subMob);
        list.push(globalValues);
        // NOTE: followingUser pushed to save list below when checking if mobAction is new
        //if (followingUser != undefined) list.push(followingUser);
		
		// Pass the newly earned points to the submob, the mob, and the user
		// First we need to fetch all three (is there a better way than this?)
		user.fetch().then(
		  function(fetchedUser) {
		   careMob.fetch().then(
			  function(fetchedCareMob) {
			    subMob.fetch().then(
				  function(fetchedSubMob) {
					
					// Level up flags (used to determine if we need to generate activity objects)
					var notifyUserLeveledUp = new Parse.Promise();
					var notifySubMobLeveledUp = new Parse.Promise();
					var notifyCareMobLeveledUp = new Parse.Promise();
					var notifyFollowingUser = new Parse.Promise();
					
					// Update the user's points
					var newUserPoints = user.get("points") + pointsDiff;
					var newUserLevel = calculateUserLevelForPoints(newUserPoints);
					var oldUserLevel = user.get("level");
				    user.set("points", newUserPoints);
					user.set("effectivePoints", user.get("effectivePoints") + pointsDiff);
					user.set("todayPoints", user.get("todayPoints") + pointsDiff);
					
				    // Update the user level if we need to
				    if (newUserLevel > oldUserLevel) {
					  user.set("level", newUserLevel);
					  notifyUserLeveledUp = CreateActivity_UserLeveledUp(user);
				    } else notifyUserLeveledUp.resolve();    
				
				    // Update the CareMob point totals
				    var newCareMobPoints = careMob.get("points") + pointsDiff;
					var newCareMobLevel = calculateCareMobLevelForPoints(newCareMobPoints);
					var oldCareMobLevel = careMob.get("level");
					
				    careMob.set("points", newCareMobPoints);
					careMob.set("effectivePoints", careMob.get("effectivePoints") + pointsDiff);
					careMob.set("todayPoints", careMob.get("todayPoints") + pointsDiff);
					
					// Update the level if we need to
				    if (newCareMobLevel > oldCareMobLevel) {
					  careMob.set("level", newCareMobLevel);
					  notifyCareMobLeveledUp = CreateActivity_CareMobLeveledUp(careMob);
				    } else notifyCareMobLeveledUp.resolve();
				
				    // Update the SubMob point totals 
					var newSubMobPoints = subMob.get("points") + pointsDiff;
					var newSubMobLevel = calculateSubMobLevelForPoints(newSubMobPoints);
					var oldSubMobLevel = subMob.get("level");
					
				    subMob.set("points", newSubMobPoints);	
					subMob.set("effectivePoints", subMob.get("effectivePoints") + pointsDiff);
					subMob.set("todayPoints", subMob.get("todayPoints") + pointsDiff);
					
					// Update the level if we need to
				    if (newSubMobLevel > oldSubMobLevel) {
					  subMob.set("level", newSubMobLevel);
					  notifySubMobLeveledUp = CreateActivity_SubMobLeveledUp(subMob, careMob);
				    } else notifySubMobLeveledUp.resolve();
				
				    // Update the user, careMob & subMob totalMobActionValue and totalMobActions (if this is a new MobAction)
				    careMob.set("totalMobActionValue", careMob.get("totalMobActionValue") + valueDiff);
                    careMob.set("effectiveTotalMobActionValue", careMob.get("effectiveTotalMobActionValue") + valueDiff);
					careMob.set("totalMobActionValueToday", careMob.get("totalMobActionValueToday") + valueDiff);
				
				    subMob.set("totalMobActionValue", subMob.get("totalMobActionValue") + valueDiff);
                    subMob.set("effectiveTotalMobActionValue", subMob.get("effectiveTotalMobActionValue") + valueDiff);
					subMob.set("totalMobActionValueToday", subMob.get("totalMobActionValueToday") + valueDiff);
												
				    user.set("totalMobActionValue", user.get("totalMobActionValue") + valueDiff);
				    user.set("effectiveTotalMobActionValue", user.get("effectiveTotalMobActionValue") + valueDiff);
				    user.set("totalMobActionValueToday", user.get("totalMobActionValueToday") + valueDiff);				
				    if (mobAction.isNew()) {
					  var totalSubMobActions = subMob.get("totalMobActions");
					  var totalCareMobActions = careMob.get("totalMobActions");
					
					  // If totalMobActions is 0 for this subMob, then this user started the submob!
					  if (totalSubMobActions == 0) {
						var subMobsStarted = user.get("subMobsStarted");
						if (subMobsStarted == undefined) subMobsStarted = 0;
						user.set("subMobsStarted", subMobsStarted + 1);
					  }
					
					  subMob.set("totalMobActions", totalSubMobActions + 1);
					  careMob.set("totalMobActions", totalCareMobActions + 1);
					
					  // Increase the users mobActionsCreated value as well
					  var mobActionsCreated = user.get("totalMobActions");
					  if (mobActionsCreated == undefined) mobActionsCreated = 0;
					  mobActionsCreated++;
					  user.set("totalMobActions", mobActionsCreated);
					  
					}
				
                    // And also notify the user (if any) we followed in
                    if (mobAction.isNew()) {
	                  if (followingUser == undefined)
	                    notifyFollowingUser.resolve();
	                  else {
	                    notifyFollowingUser = CreateActivity_NotifyFollowingUser(user, subMob, careMob, followingUser);
	
	                    followingUser.increment("influence",1);
	                    followingUser.increment("effectiveInfluence",1);
	                    followingUser.increment("todayInfluence",1);		
	
	                    // Add the following user to the save list
	                    list.push(followingUser);
	                  }
                    } else notifyFollowingUser.resolve();
								
					// Finally update the GlobalValues
					if (mobAction.isNew()) globalValues.increment("totalMobActions", 1);
					globalValues.increment("totalMobActionValue", valueDiff);
								
		            Parse.Object.saveAll(list).then(
			          function(list) {
				          // Fire any notifications
				          notifyUserLeveledUp.then(
					        function() {
						      notifySubMobLeveledUp.then(
							    function() {
								  notifyCareMobLeveledUp.then(
									function() {
									  notifyFollowingUser.then(
										function() {
									      response.success();
									    },
									    function(error) {
										  console.error(error);
										  response.success();
									    }
								      );
								    },
								    function(error) {
									  console.error(error);
									  response.success();
								    }
								  );
							    },
							    function(error) {
							      console.error(error);
								  response.success();	  
							    }
							  );
					        },
					        function(error) {
						      console.error(error);
						      response.success();
					        }
					      );
			          },
				      function(error) {
					    response.error(error.message);	
					  } 
			        );		    
				  }
				);	
			  }
			);	
          }
		);
	//} else response.success();
});

Parse.Cloud.afterSave("MobAction", function(request) {
  Parse.Cloud.useMasterKey();

  // Delete any MobActionFootprint objects for this user since they have now left a mob
  DeleteAllMobActionFootprintsForUser(request.user);	
});

Parse.Cloud.afterSave("MobActionFootprint", function(request) {
  Parse.Cloud.useMasterKey();

  var mobActionFootprint = request.object;
  var mobActionFootprintQuery = new Parse.Query("MobActionFootprint");
  mobActionFootprintQuery.equalTo("objectId", mobActionFootprint.id);
  mobActionFootprintQuery.include("subMob");
  mobActionFootprintQuery.include("careMob");
  mobActionFootprintQuery.include("user");
  mobActionFootprintQuery.first().then(
	function(object) {
	  mobActionFootprint = object;
	  var user = mobActionFootprint.get("user");
	  var subMob = mobActionFootprint.get("subMob");
	  var careMob = mobActionFootprint.get("careMob");
	
	  // Check if any MobAction exists already
	  var mobActionQuery = new Parse.Query("MobAction");
	  mobActionQuery.equalTo("user", user);
	  mobActionQuery.equalTo("subMob", subMob);
	  mobActionQuery.first().then(
	    function(object) {
		  if (object == undefined) {
  		    CreateActivity_UserEnteredSubMob(user, subMob, careMob);
          } else {
	        var updatedAt = object.updatedAt;
	        var now = new Date();
	        if (now.getTime() - updatedAt.getTime() > 60*60*2*1000) {
		      CreateActivity_UserEnteredSubMob(user, subMob, careMob);
	        }
	        
          }
	    },
	    function(error) {
		  // Just don't send the push
	    }
	  );
	},
	function(error) {
	  console.log("afterSave: MobActionFootprint: error fetching full object");
	}
  );	
});

Parse.Cloud.beforeSave("Follow", function(request, response) {
  Parse.Cloud.useMasterKey();

  if (request.object.isNew()) {
	
	var followedUser = request.object.get("followedUserId");
	var followingUser = request.object.get("followingUserId");
	
  	followedUser.increment("followerCount",1);
    followingUser.increment("followingCount",1);	

    var list = [];
    list.push(followedUser);
    list.push(followingUser);

    Parse.Object.saveAll(list).then(
	  function() {
		response.success();
	  },
	  function(error) {
	    response.error("Failed to save");	
	  }
	);
  }
});

Parse.Cloud.beforeDelete("Follow", function(request, response) {
  Parse.Cloud.useMasterKey();

  var followedUser = request.object.get("followedUserId");
  var followingUser = request.object.get("followingUserId");
	
  followedUser.increment("followerCount",-1);
  followingUser.increment("followingCount",-1);	

  var list = [];
  list.push(followedUser);
  list.push(followingUser);

  Parse.Object.saveAll(list).then(
    function() {
  	  response.success();
	},
	function(error) {
	  response.error("Failed to save");	
	}
  );
});

Parse.Cloud.afterSave("Follow", function(request) {
  Parse.Cloud.useMasterKey();
	
  if (!request.object.existed()) {
    var followedUser = request.object.get("followedUserId");
    var followingUser = request.object.get("followingUserId");
	
	// Fetch the following user so we can get their name
	followingUser.fetch().then(
	  function(fetchedFollowingUser) {
		followingUser = fetchedFollowingUser;
		
		CreateActivity_UserFollowedUser(followedUser, followingUser).then(
		  function() {		
		    
		  },
		  function(error) {
		    console.log("afterSave: Follow: " + error);	
		  }	
		);
		
	  },
	  function(error) {
	    console.log("afterSave: Follow: " + error);	
	    // Do nothing, we just don't create activity	
	  }	
	);
  }
});

/////////////////////////////////
// Cloud functions
/////////////////////////////////

// Redeem the points for a given activity
Parse.Cloud.define("RedeemPoints", function(request, response) {
  Parse.Cloud.useMasterKey();

  var user = request.user;
  var activityId = request.params.activity;	

  if (activityId == undefined) response.error("No activity specified");
  else {
    var activityQuery = new Parse.Query("Activity");
    activityQuery.equalTo("objectId", activityId);
    activityQuery.include("targetRedeemablePoints");
    activityQuery.include("targetRedeemablePoints.user");
    activityQuery.first().then(
	  function(activity) {
		var redeemablePoints = activity.get("targetRedeemablePoints");
		if (redeemablePoints == undefined) response.error("No points to redeem!");
		else if (redeemablePoints.get("wasRedeemed") == true) response.error("Points already redeemed");
		else {
		  var pointsUser = redeemablePoints.get("user");
		  if (pointsUser.id != user.id) response.error("Calling user doesn't match points user");
		  else {
		    var points = redeemablePoints.get("points");
		    user.increment("points", points);
		    user.increment("todayPoints", points);
		    user.increment("effectivePoints", points);
				
		    redeemablePoints.set("wasRedeemed", true);
		
		    user.save().then(
			  function() {
				redeemablePoints.save().then(
				  function() {
					response.success(activity);	
				  },
				  function(error) {
					response.error("Error saving points");
				  }	
				);
			  },
			  function(error) {
			    response.error("Error saving user");	
			  }
			);	
		  }	
		}
	  },
	  function(error) {
	    response.error(error);	
	  }
	);	
  }
});

// Notify the calling user's Facebook friends that this user has joined
Parse.Cloud.define("NotifyUsersFacebookFriendsOfSignup", function(request, response) {
  Parse.Cloud.useMasterKey();

  var user = request.user;
  user.fetch().then(
	function(fetchedUser) {
      user = fetchedUser;
	  var fbFriendIds = user.get("fbFriendIds");
	
	  // Fetch the list of facebook friend users using this friendIds array
	  var friendsQuery = new Parse.Query(Parse.User);
	  friendsQuery.containedIn("fbUserId", fbFriendIds);
	  friendsQuery.find().then(  
	    function(friends) {
	
	  	  CreateActivity_UserJoined(user, friends).then(
	        function() {
		      response.success();
	        },
	        function(error) {
		      response.error(error);
	        }
	      );
	    },
	    function(error) {
		  response.error(error);
	    }
      );
	
    },
    function(error) {
	  response.error(error);
    }
  );
  
});

// Fetch user's current points, level, points to last level and points to next level
Parse.Cloud.define("GetUserPointsAndLevel", function(request, response) {
  Parse.Cloud.useMasterKey();
	
  var user = request.user;
	
  var result = {};
  result["points"] = user.get("points");
	
  var level = user.get("level");
	
  result["level"] = level;
  result["pointsToCurrentLevel"] = calculateUserPointsRequiredForLevel(level);
  result["pointsToNextLevel"] = calculateUserPointsRequiredForLevel(level + 1);
	
  response.success(result);
});

// Return a dictionary containing the point totals for all submob categories
Parse.Cloud.define("GetUserSubmobPointTotals", function(request, response) {
  Parse.Cloud.useMasterKey();

  var userId = request.params.userId;
  var user = new Parse.User({id:userId});

  var result = {};

  console.log("Getting user submob point totals for " + userId);

  console.log("Fetched user!");
	
  // Fetch all user's mobActions
  var mobActionQuery = new Parse.Query("MobAction");
  mobActionQuery.equalTo("user", user);
  mobActionQuery.include("subMob");
  mobActionQuery.find().then(
	function(results) {
	  console.log("Got " + results.length + " mobActions");
		
	  for (var i = 0; i < results.length; i++) {
	    var mobAction = results[i];
	    var subMob = mobAction.get("subMob");
	    var subMobCategory = subMob.get("category");
		
	    if (result[subMobCategory] == undefined) result[subMobCategory] = mobAction.get("points");
	    else result[subMobCategory] = result[subMobCategory] + mobAction.get("points");
		
		//console.log("Adding category total for " + subMobCategory + " with points " + mobAction.get("points"));
	  }
		
	  response.success(result);
	},
	function(error) {
		response.error(error);
	}
  );
});

// Return the user's rank by counting all users with more points and adding 1
Parse.Cloud.define("GetUserRank", function(request, response) {
	Parse.Cloud.useMasterKey();
	
	var userId = request.params.userId;
	//var userPoints = request.params.userPoints;
	var user = new Parse.User({id:userId});
	
	result = {};
	var rank = 0;
	
	// Get the user's rank by counting all users with greater points and adding 1
	user.fetch().then(
	  function(fetchedUser) {
		user = fetchedUser;
		
		var points = user.get("points");
		
	    var rankQuery = new Parse.Query("_User");
	    rankQuery.greaterThan("points", points);
	    rankQuery.count().then(
	      function(cnt) {
		    rank = cnt + 1;
		    result["rank"] = rank;
		    result["totalMobActions"] = user.get("totalMobActions");
		    result["caremobsCreated"] = user.get("caremobsCreated");
		    result["subMobsStarted"] = user.get("subMobsStarted");
		
	  	    response.success(result);
	      },
	      function(error) {
	        response.error(error);	
	      }	
	    );
	  
        },
        function(error) {
	      response.error(error);
        }
    );
});

// Create a CareMob object from a FeedStory, or return the existing CareMob if one exists
Parse.Cloud.define("CreateCareMobFromFeedStory", function(request, response) {
  Parse.Cloud.useMasterKey();

  var user = request.user;
  var feedStoryId = request.params.feedStoryId;

  var feedStoryQuery = new Parse.Query("FeedStory");
  feedStoryQuery.equalTo("objectId", feedStoryId);
  feedStoryQuery.first().then(
	function (feedStory) {
	  if (feedStory == undefined) {
		response.error("CreateCareMobFromFeedStory: Can't find FeedStory with id " + feedStoryId);
	  } else {
	    var careMobQuery = new Parse.Query("CareMob");
	    careMobQuery.equalTo("feedStory", feedStory);
	    careMobQuery.find().then(
		  function (results) {
		    if (results.length == 0) {
		      // Create a new caremob from the FeedStory and return it	
		      var CareMob = Parse.Object.extend("CareMob");
		      var careMob = new CareMob();
		    
		      careMob.set("createdBy", user);
		      careMob.set("feedStory", feedStory);
		      careMob.set("image", feedStory.get("image"));
		      careMob.set("title", feedStory.get("title"));
		      careMob.set("long_text", feedStory.get("description"));
		      careMob.set("short_text", feedStory.get("description"));
		      careMob.set("url", feedStory.get("url"));
		      careMob.set("source", feedStory.get("source"));
		      careMob.save().then(
			    function (result) {
				  response.success(result);
			    },
			    function (error) {
			      response.error(error);	
			    }
			  );
		    } else {
			  // Return the CareMob
			  var careMob = results[0];
			  response.success(careMob);
		    }	
		  },
		  function (error) {
		    response.error(error);
		  }
	    );
      }
	},
	function (error) {
	  response.error(error);
	}
  );	
});


/////////////////////////////////
// Utility functions
/////////////////////////////////

// The following methods return a promise and do one simple task

// Delete all MobActionFootprint objects for the given user
function DeleteAllMobActionFootprintsForUser(user) {
  var promise = new Parse.Promise();

  var mobActionFootprintQuery = new Parse.Query("MobActionFootprint");
  mobActionFootprintQuery.equalTo("user", user);
  mobActionFootprintQuery.find(
	function(results) {
	  Parse.Object.destroyAll(results).then(
		function() {
          promise.resolve();
		},
		function(error) {
		  promise.reject(error);
		}
	  );
	},
	function(error) {
      promise.reject(error);		
	}
  );

  return promise;
}

/////////////////////////////////
// Notification functions
/////////////////////////////////

// The following functions will create Activity objects based on occurences in CareMob - e.g., a CareMob or SubMob levels up
function CreateActivity_NotifyFollowingUser(user, subMob, careMob, followingUser) {
  var promise = new Parse.Promise();

  var Activity = Parse.Object.extend("Activity");
  var activity = new Activity();

  /* REMOVED 10.28.2015 no more redeemable points
  var RedeemablePoints = Parse.Object.extend("RedeemablePoints");
  var redeemablePoints = new RedeemablePoints();

  redeemablePoints.set("user", followingUser);
  redeemablePoints.set("points", 1);
  */

  activity.set("type", "UserFollowedIntoSubMob");
  activity.set("user", followingUser);
  activity.set("targetUser", user);
  activity.set("targetCareMob", careMob);
  activity.set("targetSubMob", subMob);
  //activity.set("targetRedeemablePoints", redeemablePoints);

  activity.save().then(
   function() {
     var usersToPushQuery = new Parse.Query(Parse.Installation);
     usersToPushQuery.equalTo('user', followingUser);
     Parse.Push.send({
       where: usersToPushQuery, // sets our installation query
       data : {
	     alert: 'You just inspired ' + user.get("name") + ' to follow you into a ' + subMob.get("category") + ' mob',
	     sound: "default",
	     categoryContext : subMob.get("category"),
	   }
	 }).then(
	   function() {		
	     promise.resolve();
	   },
	   function(error) {
  	     promise.resolve();
       }
     );
   },
   function(error) {
     promise.reject(error);
   }
  );

  return promise;	
}

function CreateActivity_UserEnteredSubMob(user, subMob, careMob) {
  var promise = new Parse.Promise();

  var activityList = [];
  var userList = [];

  // Get a list of all followers for this user
  var followersQuery = new Parse.Query("Follow");
  followersQuery.equalTo("followedUserId", user);
  followersQuery.find().then(
    function(followers) {
	  for (var i = 0; i < followers.length; i++) {
	    var follower = followers[i].get("followingUserId");
		
        var Activity = Parse.Object.extend("Activity");
        var activity = new Activity();
        activity.set("type", "UserEnteredSubMob");
        activity.set("user", follower);
        activity.set("targetUser", user);
        activity.set("targetSubMob", subMob);
        activity.set("targetCareMob", careMob);
        activityList.push(activity);
        userList.push(follower);
     }  

     Parse.Object.saveAll(activityList).then(
	   function(list) {
	     // Send a push to all users	
         var usersToPushQuery = new Parse.Query(Parse.Installation);
         usersToPushQuery.containedIn('user', userList);
         Parse.Push.send({
	       where: usersToPushQuery, // sets our installation query
           data : {
		     alert: user.get("name") + ' is uniting live in a ' + subMob.get("category") + ' mob',
		     sound: "default",
		     categoryContext : subMob.get("category"),
		   }
	     }).then(
		   function() {		
	         promise.resolve();
	       },
	       function(error) {
		     promise.resolve();
	       }
	     );
  	   },
       function(error) {
	     promise.reject(error);
       }
      );  
 
       
    },
    function(error) {
	  promise.reject(error);
    }
  );

  return promise;	
}

function CreateActivity_UserCreatedCareMob(user, careMob, category) {
  var promise = new Parse.Promise();
 
  var activityList = [];
  var userList = [];
 
  user.fetch().then(
	  function(obj) {
	  
		  user = obj;
		  
  // Get a list of all followers for this user
  var followersQuery = new Parse.Query("Follow");
  followersQuery.equalTo("followedUserId", user);
  followersQuery.find().then(
    function(followers) {
      for (var i = 0; i < followers.length; i++) {
        var follower = followers[i].get("followingUserId");
         
        var Activity = Parse.Object.extend("Activity");
        var activity = new Activity();
        activity.set("type", "UserCreatedCareMob");
        activity.set("user", follower);
        activity.set("targetUser", user);
        activity.set("stringValue", category);
        activity.set("targetCareMob", careMob);
        activityList.push(activity);
        userList.push(follower);
     }  
 
     Parse.Object.saveAll(activityList).then(
       function(list) {
         // Send a push to all users    
         var usersToPushQuery = new Parse.Query(Parse.Installation);
         usersToPushQuery.containedIn('user', userList);
         Parse.Push.send({
           where: usersToPushQuery, // sets our installation query
           data : {
             alert: user.get("name") + ' just started a ' + category + ' mob',
             sound: "default",
             categoryContext : category,
           }
         }).then(
           function() {     
             promise.resolve();
           },
           function(error) {
             promise.resolve();
           }
         );
       },
       function(error) {
         promise.reject(error);
       }
      );  
  
        
    },
    function(error) {
      promise.reject(error);
    }
  );
  
  
	},
	function(error) {
		promise.reject(error);
	}
  );

  return promise;   
}

function CreateActivity_UserFollowedUser(followedUser, followingUser) {
  var promise = new Parse.Promise();

  var activityList = [];
  var userList = [];

  var Activity = Parse.Object.extend("Activity");
  var activity = new Activity();
  activity.set("type", "UserFollowed");
  activity.set("user", followedUser);
  activity.set("targetUser", followingUser);

  activityList.push(activity);
  userList.push(followedUser);

  Parse.Object.saveAll(activityList).then(
	function(list) {
	  // Send a push to all users	
      var usersToPushQuery = new Parse.Query(Parse.Installation);
      usersToPushQuery.containedIn('user', userList);
      Parse.Push.send({
	    where: usersToPushQuery, // sets our installation query
        data : {
		  alert: followingUser.get("name") + ' just started following you!',
		  sound: "default"
		}
	  }).then(
		function() {		
	      promise.resolve();
	    },
	    function(error) {
		  promise.resolve();
	    }
	  );
  	},
    function(error) {
	  promise.reject(error);
    }
  );  

  return promise;	
}

function CreateActivity_UserJoined(user, friends) {
	var promise = new Parse.Promise();
	
	var activityList = [];
	var userList = [];
	
    var Activity = Parse.Object.extend("Activity");
	for (var i = 0; i < friends.length; i++) {
	  var activity = new Activity();
	  var friend = friends[i];
	  
	  activity.set("type", "UserJoined");
	  activity.set("user", friend);
	  activity.set("targetUser", user);
	 
	  activityList.push(activity);
	  userList.push(friend);
	}
	
	Parse.Object.saveAll(activityList).then(
	  function(list) {
	    // Send a push to all users	
	    var usersToPushQuery = new Parse.Query(Parse.Installation);
	    usersToPushQuery.containedIn('user', userList);
	    Parse.Push.send({
	      where: usersToPushQuery, // sets our installation query
	      data : {
	  	    alert: 'Your friend ' + user.get("name") + ' joined Caremob!',
			sound: "default"
		  }
		}).then(
		  function() {		
		    promise.resolve();
		  },
		  function(error) {
		    promise.resolve();
		  }
		);
	  },
	  function(error) {
	    promise.reject(error);
	  }
	);
	
	return promise;
}

function CreateActivity_UserLeveledUp(user) {
  var promise = new Parse.Promise();

  promise.resolve();

  /* REMOVED 10.28.2015
  // For now, we just create a notification for the user him/herself
  // TODO: notify all followers of the user as well
  
  var activityList = [];
  var userList = [];

  var Activity = Parse.Object.extend("Activity");
  var activity = new Activity();
  activity.set("type", "UserLeveledUp");
  activity.set("user", user);
  activity.set("targetUser", user);
  activity.set("numberValue", user.get("level"));

  activityList.push(activity);
  userList.push(user);

  Parse.Object.saveAll(activityList).then(
	function(list) {
	  // Send a push to all users	
      var usersToPushQuery = new Parse.Query(Parse.Installation);
      usersToPushQuery.containedIn('user', userList);
      Parse.Push.send({
	    where: usersToPushQuery, // sets our installation query
        data : {
		  alert: 'Your participation level as a mobber just grew!',
		  sound: "default"
		}
	  }).then(
		function() {		
	      promise.resolve();
	    },
	    function(error) {
		  promise.resolve();
	    }
	  );
  	},
    function(error) {
	  promise.reject(error);
    }
  );
  */

  return promise;	
}

function CreateActivity_SubMobLeveledUp(subMob, careMob) {
  var promise = new Parse.Promise();
	
  var mobCategory = subMob.get("category");
  var mobTitle = careMob.get("title");

  var activityList = [];
  var userList = [];
  var Activity = Parse.Object.extend("Activity");
	
  var RedeemablePoints = Parse.Object.extend("RedeemablePoints");
	
  // Get all the MobActions in this SubMob
  var mobActionQuery = new Parse.Query("MobAction");
  mobActionQuery.equalTo("subMob", subMob);
  mobActionQuery.include("careMob");
  mobActionQuery.include("user");
  mobActionQuery.find().then(
    function(results) {
  	  for (var i = 0; i < results.length; i++) {
		var mobAction = results[i];
			
		/* REMOVED 10.28.2015 no more redeemable points	
		var redeemablePoints = new RedeemablePoints();

		redeemablePoints.set("user", mobAction.get("user"));
		redeemablePoints.set("points", 1);
		*/
		  
		var activity = new Activity();
		activity.set("type", "SubMobLeveledUp");
		activity.set("user", mobAction.get("user"));
		activity.set("targetCareMob", mobAction.get("careMob"));
		activity.set("targetSubMob", subMob);
		activity.set("numberValue", subMob.get("level"));
		//activity.set("targetRedeemablePoints", redeemablePoints);
			
		activityList.push(activity);
		userList.push(mobAction.get("user"));
	   }
		
	   Parse.Object.saveAll(activityList).then(
	     function(list) {
			  /*
			  // Send a push to all users
			  console.log("CreateActivity_SubMobLeveledUp: sending push to " + userList.length + " users.");
		      var usersToPushQuery = new Parse.Query(Parse.Installation);
		      usersToPushQuery.containedIn('user', userList);
		      Parse.Push.send({
			    where: usersToPushQuery, // sets our installation query
		        data : {
				  alert: 'Your ' + mobCategory + ' mob for ' + mobTitle + ' grew!',
				  sound: "default",
				  categoryContext : subMob.get("category"),
				}
			  }).then(
				function() {		
			      promise.resolve();
			    },
			    function(error) {
				  promise.resolve();
			    }
			  );
			 */
			 promise.resolve();
	     },
         function(error) {
	       promise.reject(error);	
	     }
      );
    },
    function(error) {
      promise.reject(error);
    }
  );
	
  return promise;
}

function CreateActivity_CareMobLeveledUp(careMob) {
  var promise = new Parse.Promise();

  promise.resolve();

  /* NOTE: removed for now because CareMob leveling has no contextual meaning for users	
  var activityList = [];
  var Activity = Parse.Object.extend("Activity");
	
  // Get all the MobActions in this SubMob
  var mobActionQuery = new Parse.Query("MobAction");
  mobActionQuery.equalTo("careMob", careMob);
  mobActionQuery.include("user");
  mobActionQuery.find().then(
	function(results) {
	  for (var i = 0; i < results.length; i++) {
		var mobAction = results[i];
			
		var activity = new Activity();
		activity.set("type", "CareMobLeveledUp");
		activity.set("user", mobAction.get("user"));
		activity.set("targetCareMob", careMob);
	    activity.set("numberValue", careMob.get("level"));
			
		activityList.push(activity);
	  }
		
	  Parse.Object.saveAll(activityList).then(
		function() {
	  	  promise.resolve();
	    },
	    function(error) {
	      promise.reject(error);	
	    }
	  );
	},
	function(error) {
      promise.reject(error);
    }
  );
  */

  return promise;
}

/////////////////////////////////
// Jobs
/////////////////////////////////

Parse.Cloud.job("UpdateSubMobTotals", function(request, status) {
  Parse.Cloud.useMasterKey();

  var subMobQuery = new Parse.Query("SubMob");
  subMobQuery.each(
	function(subMob) {
	  var totalMobActionValue = subMob.get("totalMobActionValue");
	  subMob.set("effectiveTotalMobActionValue", totalMobActionValue);
	  subMob.set("totalMobActionValueToday", 0);
	  return subMob.save();	
	}
  ).then(
	function() {
	  status.success();
	},
	function(error) {
	  status.error(error);	
	}
  );
});

Parse.Cloud.job("UpdateCareMobTotals", function(request, status) {
  Parse.Cloud.useMasterKey();

  var careMobCount = 0;

  var careMobQuery = new Parse.Query("CareMob");
  careMobQuery.include("subMobs");
  careMobQuery.each(
	function(careMob) {
	  careMobCount++;
	  return UpdateCareMobTotal(careMob);
	}
  ).then(
	function() {
	  status.success("Completed with " + careMobCount + " CareMobs");
	},
	function(error) {
	  status.error(error);	
	}
  );	
});

function UpdateCareMobTotal(careMob) {
  var promise = new Parse.Promise();
  
  var mobActionCount = new Parse.Query("MobAction");
  mobActionCount.equalTo("careMob", careMob);
  mobActionCount.count(
  	function(count) {
	  if (count != undefined) 
	    careMob.set("totalMobActions", count);
		
  	  var totalMobActionValue = 0;
			
	  var list = careMob.get("subMobs");
	  for (var i = 0; i < list.length; i++) {
	    totalMobActionValue += list[i].get("totalMobActionValue");	
	  }
		
	  careMob.set("totalMobActionValue", totalMobActionValue);
	  careMob.set("effectiveTotalMobActionValue", totalMobActionValue);
	  careMob.set("totalMobActionValueToday", 0);
		
	  careMob.save().then(
	    function() {
	      promise.resolve();
	    },
	    function(error) {
	      promise.reject(error);
	    }
	  );
	},
	function(error) {
	  promise.reject(error);
	}
  );

  return promise;
}

Parse.Cloud.job("UpdateFollowerCounts", function(request, status) {
  Parse.Cloud.useMasterKey();

  var userQuery = new Parse.Query(Parse.User);
  userQuery.each(
	function(user) {
	  return updateFollowerCounts(user);
	}
  ).then(
	function() {
      status.success();		
	},
	function(error) {
	  status.error(error);	
	}
  );	
});

function updateFollowerCounts(user) {
  var promise = new Parse.Promise();

  var followerCountQuery = new Parse.Query("Follow");
  followerCountQuery.equalTo("followedUserId", user);
  followerCountQuery.count(
    function(count) {
	  user.set("followerCount", count);
	
	  var followingCountQuery = new Parse.Query("Follow");
	  followingCountQuery.equalTo("followingUserId", user);
	  followingCountQuery.count(
	    function(count) {
		  user.set("followingCount", count);

          user.save().then(
	        function() {
		      promise.resolve();
	        },
	        function(error) {
		      promise.reject(error);
 	        }
	      );
	    },
	    function(error) {
		  promise.reject(error);
	    }	
	  );
    },
    function(error) {
	  promise.reject(error);
    }	
  );
  return promise;	
}

Parse.Cloud.job("UpdateGlobalValues", function(request, status) {
  Parse.Cloud.useMasterKey();

  var GlobalValues = Parse.Object.extend("GlobalValues");
  var globalValues = new GlobalValues();
  globalValues.id = kGlobalValuesId;

  var totalMobActionValue = 0;
  var totalMobActions = 0;

  var mobActionsQuery = new Parse.Query("MobAction");
  mobActionsQuery.each(
    function(mobAction) {
      totalMobActionValue += mobAction.get("value");
      totalMobActions++;

	  var p = new Parse.Promise();
	  return p.resolve();
	}
  ).then(
	function() {
	  globalValues.set("totalMobActions", totalMobActions);
	  globalValues.set("totalMobActionValue", totalMobActionValue);
	
	  globalValues.save().then(
		function() {
	  	  status.success();
	    },
	    function(error) {
		  status.error(error);
	    }
	  )
	}, 
	function(error) {
	  status.error(error);
	}
  );	

});

Parse.Cloud.job("UpdateUserLevels", function(request, status) {
  Parse.Cloud.useMasterKey();

  var userQuery = new Parse.Query(Parse.User);
  userQuery.each(
	function(user) {
	  var points = user.get("points");
	  var level = calculateUserLevelForPoints(points);
	  user.set("level", level);
	  return user.save();	
	}
  ).then(
	function() {
	  status.success("Finished job");
	},
	function(error) {
	  status.error(error);
	}
  );	
});

Parse.Cloud.job("UpdateCareMobLevels", function(request, status) {
  Parse.Cloud.useMasterKey();

  var careMobQuery = new Parse.Query("CareMob");
  careMobQuery.each(
	function(careMob) {
	  var points = careMob.get("points");
	  var level = calculateCareMobLevelForPoints(points);
	  careMob.set("level", level);
	  return careMob.save();	
	}
  ).then(
	function() {
	  status.success("Finished job");
	},
	function(error) {
	  status.error(error);
	}
  );	
});

Parse.Cloud.job("UpdateSubMobLevels", function(request, status) {
  Parse.Cloud.useMasterKey();

  var subMobQuery = new Parse.Query("SubMob");
  subMobQuery.each(
	function(subMob) {
	  var points = subMob.get("points");
	  var level = calculateSubMobLevelForPoints(points);
	  subMob.set("level", level);
	  return subMob.save();	
	}
  ).then(
	function() {
	  status.success("Finished job");
	},
	function(error) {
	  status.error(error);
	}
  );	
});

Parse.Cloud.job("CategoryConversion", function(request, status) {
  Parse.Cloud.useMasterKey();

  var alertSubMobQuery = new Parse.Query("SubMob");
  alertSubMobQuery.equalTo("category", "alert");

  var prayerSubMobQuery = new Parse.Query("SubMob");
  prayerSubMobQuery.equalTo("category", "prayer");
  	
  var orQuery = Parse.Query.or(alertSubMobQuery, prayerSubMobQuery);
  orQuery.each(
	function(subMob) {
	  var category = subMob.get("category");
	  if (category == "alert") subMob.set("category", "celebration");
	  if (category == "prayer") subMob.set("category", "mourning");
	
	  return subMob.save();	
	}
  ).then(
    function() {
	  status.success("Finished job");
    },
    function(error) {
	  status.error(error);
    }	
  );
});

Parse.Cloud.job("UpdateEffectivePoints", function(request, status) {
  // Set up to modify user data
  Parse.Cloud.useMasterKey();

  var decayConstant = 0.8;

  // At this stage, we are assuming there are fewer than 1000 CareMob and SubMob objects.  We will need to expand this soon!
  var careMobCounter = 0;
  var subMobCounter = 0;
  var userCounter = 0;

  var careMobQuery = new Parse.Query("CareMob");
  careMobQuery.each(
	function(careMob) {
	  var effectivePoints = careMob.get("effectivePoints");
	  careMob.set("effectivePoints", effectivePoints * decayConstant);
	  careMob.set("todayPoints", 0);
	
	  var effectiveTotalMobActionValue = careMob.get("effectiveTotalMobActionValue");
	  careMob.set("effectiveTotalMobActionValue", effectiveTotalMobActionValue * decayConstant);
	  careMob.set("totalMobActionValueToday", 0);
	
	  careMobCounter += 1;
	
	  return careMob.save();
    }
  ).then(
    function() {
      var subMobQuery = new Parse.Query("SubMob");
      subMobQuery.each(
        function(subMob) {
  	      var effectivePoints = subMob.get("effectivePoints");
		  subMob.set("effectivePoints", effectivePoints * decayConstant);
		  subMob.set("todayPoints", 0);
		
		  var effectiveTotalMobActionValue = subMob.get("effectiveTotalMobActionValue");
		  subMob.set("effectiveTotalMobActionValue", effectiveTotalMobActionValue * decayConstant);
		  subMob.set("totalMobActionValueToday", 0);
		
		  subMobCounter += 1;
		
		  return subMob.save();
	    }  
      ).then(
	    function() {
	      var userQuery = new Parse.Query(Parse.User);
	      userQuery.each(
		    function(user) {
		      var effectivePoints = user.get("effectivePoints");
			  user.set("effectivePoints", effectivePoints * decayConstant);
			  user.set("todayPoints", 0);

              var effectiveInfluence = user.get("effectiveInfluence");
			  user.set("effectiveInfluence", effectiveInfluence * decayConstant);
			  user.set("todayInfluence", 0);
			
			  var effectiveTotalMobActionValue = user.get("effectiveTotalMobActionValue");
			  user.set("effectiveTotalMobActionValue", effectiveTotalMobActionValue * decayConstant);
			  user.set("totalMobActionValueToday", 0);
			
			  userCounter += 1;

			  return user.save();
		    }  
	      ).then(
	        function() {
              status.success("UpgradeEffectivePoints ran successfully against " + careMobCounter + " CareMobs and " + subMobCounter + " SubMobs and " + userCounter + " users");	  
            },
            function(error) {
	          status.error("UpgradeEffectivePoints failed: " + error);
            }
          );
        }
      );
      
    }
  );

});

/////////////////////////////////
// Helper methods
/////////////////////////////////

// User time, points and level calculations
function calculateMobActionPointsForTime(time) {
  var points = 0;

  while (points < 10000000) {
    if (calculateMobActionTimeToPoints(points) > time) return points - 1;
      points++;
    }

  return -1;	
}

function calculateMobActionTimeToPoints(points) {
  var b = 5.0;

  var multiplier = 0.0;

  for (var i = 1; i <= points; i++) {
    multiplier += i;
  }

  return b * multiplier;
}

function calculateUserLevelForPoints(points) {
	var level = 0;
	
	while  (level < 10000000) {
	  if (calculateUserPointsRequiredForLevel(level) > points) return level - 1;
	  level++;	
	}
	
	return -1;
}

function calculateUserPointsRequiredForLevel(level) {
	if (level == 0) return 0;
	
	var a = 5.0;
	var e = 1.14;
	var m = 1.0;
	var b = -4.0;
	
	//var points = Math.floor(Math.pow(e,level)) + (m * level) + b;
	var points = Math.floor(a * Math.pow(e,level) + (m * level * level) + b);
	
	return points;
}

// CareMob points and level calculations
function calculateCareMobLevelForPoints(points) {
	var level = 0;
	
	while  (level < 10000000) {
	  if (calculateCareMobPointsRequiredForLevel(level) > points) return level - 1;
	  level++;	
	}
	
	return -1;
}

function calculateCareMobPointsRequiredForLevel(level) {
	if (level == 0) return 0;
	
	var a = 5.0;
	var e = 1.14;
	var m = 1.0;
	var b = -4.0;
	
	//var points = Math.floor(Math.pow(e,level)) + (m * level) + b;
	var points = Math.floor(a * Math.pow(e,level) + (m * level * level) + b);
	
	return points;
}

// SubMob points and level calculations
function calculateSubMobLevelForPoints(points) {
	var level = 0;
	
	while  (level < 10000000) {
	  if (calculateSubMobPointsRequiredForLevel(level) > points) return level - 1;
	  level++;	
	}
	
	return -1;
}

function calculateSubMobPointsRequiredForLevel(level) {
	if (level == 0) return 0;
	
	var a = 5.0;
	var e = 1.14;
	var m = 1.0;
	var b = -4.0;
	
	//var points = Math.floor(Math.pow(e,level)) + (m * level) + b;
	var points = Math.floor(a * Math.pow(e,level) + (m * level * level) + b);
	
	return points;
}


/*  
Parse.Cloud.beforeSave("MobAction", function(request, response) {
    var caremob = request.object.get("careMob");
    var SubMob=request.object.get("SubMob");
    var seconds=request.object.get("seconds");;
    var currentUser = request.user;
     
    var MobAction=Parse.Object.extend("MobAction");
    var mobActionObject = new MobAction();
    mobActionObject.set("careMob",caremob);
    mobActionObject.set("SubMob",SubMob);
    mobActionObject.set("value",seconds);
    mobActionObject.set("user",currentUser);
     
    response.success(result);
});
*/  
  
  
  
  
  
  
