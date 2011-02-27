//
//  HnPViewController.h
//  HnP
//
//  Created by Divyanshu Arora on 2/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GameObjectDelegate.h>
#import <GameObject.h>
#import <GameWolf.h>
#import <GamePig.h>
#import <GameBlock.h>
#import <GameBreath.h>
#import <GameArrow.h>
#import <PhysicsWorldController.h>
#import <HPSavedGames.h>

@interface HPViewController : UIViewController {
	UIScrollView* gameArea;
	UIView* palette;
	int objCounter;	//Used for tagging obejcts. Allows for easy identification.
	PhysicsWorldController* phy;
	
	UIButton *load, *save, *start;
	UITextField * nameField;
	
	NSMutableArray* pObjects;	//Contains objects from the palette
	NSMutableArray* objects;	//Objects in the gameArea
	NSMutableArray* wObjects;	//Objects related to special wolf functions-the arrow etc.
	HPSavedGames* table;	//Last two used for the load button's response-display saved games
	UIPopoverController* pop;
}

@property (retain) UIScrollView* gameArea;
@property (retain) UIView* palette;
@property (retain) NSMutableArray* objects;
@property (retain) NSMutableArray* pObjects;
@property (retain) NSMutableArray* wObjects;
@property (assign) PhysicsWorldController* phy;
@property (retain) UIButton* load;
@property (retain) UIButton* save;
@property (retain) UIButton* start;
@property (retain) UITextField * nameField;
@property int objCounter;



- (void)addToGameArea:(GameObject*)o;
//REQUIRES: Valid gameobject not already passed to this function before
//MODIFIES: adds object to self.objects, adds the o.view to gameArea
//RETURNS: 

- (void)removeFromGameArea:(GameObject*)o;
//REQUIRES: GameObject present in gameArea & self.objects
//MODIFIES: Removes from gameArea, self.objects & releases o
//RETURNS: -

- (void)initializeViews;
//REQUIRES: -
//MODIFIES: Creates all the views necessary for the game-gameArea's ground & background, palette, toolbar & its buttons
//RETURNS: -

- (void)initializePalette;
//REQUIRES: Initialized view in palette
//MODIFIES: Creates wolf, pig, block in default positions
//RETURNS: -

- (void)initializeListeners;
//REQUIRES: -
//MODIFIES: Adds listeners to the default notificationsCenter for a lot of events that need to be handled by the global controller
//RETURNS: -


//All the following fns with an NSNotification argument are called to respond to a notification
//In each case, [n object] needs to be the object that sent the notification
- (void)handleTranslation:(NSNotification*)n;
//REQUIRES: [n object] to be the object that was translated
//MODIFIES: moves object from palette to gamearea if necessary
//RETURNS: -

- (void)handleDoubleTap:(NSNotification*)n;
//REQUIRES: 
//MODIFIES: Removes object from gamearea & adds back to palette if necessary
//RETURNS: 

- (void)handleSingleTap:(NSNotification*)n;
//REQUIRES: 
//MODIFIES: Shows aiming mechanism for Wolf
//RETURNS: 

- (void)handlePaletteReturn:(NSNotification*)n;
//REQUIRES: 
//MODIFIES: Returns an object to palette; position based on its class. also removes it from gameArea first. (objects -> pObjects)
//RETURNS: 

- (void)handlePigCollision:(NSNotification*)n;
//REQUIRES: 
//MODIFIES: Stops game & shows a message saying the wolf won. Removes pig from view.
//RETURNS: 

- (void)handleBreathExpired:(NSNotification*)n;
//REQUIRES: 
//MODIFIES: Removes breath from view & stops the game.
//RETURNS: 

- (void)handlePhyObjectDeletion:(NSNotification*)n;
//REQUIRES: 
//MODIFIES: Removes object from view.
//RETURNS: 

- (void)handleWolfExpired:(NSNotification*)n;
//REQUIRES: 
//MODIFIES: Kills wolf, and shows message saying wolf lost.
//RETURNS: 


- (void)resetScreen;
//REQUIRES: -
//MODIFIES: Calls removeEverything, then initializePalette. Restores everything to defaults.
//RETURNS: 

- (void)removeEverything;
//REQUIRES: 
//MODIFIES: Removes all GameObjects from gameArea, palette (& objects, pObjects, wObjects)
//RETURNS: 


- (void)saveButtonPressed;
//REQUIRES: 
//MODIFIES: Handles save button touch, shows UIAlertView asking for name to save the level under
//RETURNS: 

- (void)loadButtonPressed;
//REQUIRES: 
//MODIFIES: Shows a popover view controller showing the names of all the files that contain saved levels. selecting one loads teh level
//RETURNS: 

- (void)resetButtonPressed;
//REQUIRES: 
//MODIFIES: Calls resetScreen. Used by the reset button.
//RETURNS: 

- (void)startButtonPressed;
//REQUIRES: 
//MODIFIES: Starts the physics engine, AND creates GameBreath as dictated by the wolf's arrow
//RETURNS: 

- (void) alertView:(UIAlertView *)alert clickedButtonAtIndex:(NSInteger)buttonIndex;
//REQUIRES: 
//MODIFIES: If the user pressed 'OK', it uses the text entered as the name of the file to save the level to.
//RETURNS: 
@end

