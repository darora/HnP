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
#import <GameObjectFoundry.h>
#import <PhysicsWorldController.h>
#import <HPSavedGames.h>

@interface HPViewController : UIViewController {
	UIScrollView* gameArea;
	UIView* palette;
	int objCounter;
	PhysicsWorldController* phy;
	
	UIButton *load, *save;
	UITextField * nameField;
	
	NSMutableArray* pObjects;
	NSMutableArray* objects;
	NSMutableArray* wObjects;
	HPSavedGames* table;
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
@property (retain) UITextField * nameField;
@property int objCounter;

- (void)initializeViews;

- (void)addToGameArea:(GameObject*)o;
- (void)removeFromGameArea:(GameObject*)o;
- (void)initializeViews;
- (void)initializePalette;
- (void)initializeListeners;
- (void)handleTranslation:(NSNotification*)n;
- (void)handleDoubleTap:(NSNotification*)n;
- (void)handleSingleTap:(NSNotification*)n;
- (void)handlePaletteReturn:(NSNotification*)n;
- (void)handlePigCollision:(NSNotification*)n;
- (void)handleBreathExpired:(NSNotification*)n;

- (void)resetScreen;
- (void)removeEverything;

- (void)saveButtonPressed;
- (void)loadButtonPressed;
- (void)resetButtonPressed;
- (void)startButtonPressed;
@end

