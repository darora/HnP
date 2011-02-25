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
#import <GameObjectFoundry.h>
#import <PhysicsWorldController.h>

@interface HPViewController : UIViewController {
	UIScrollView* gameArea;
	UIView* palette;
	int objCounter;
	PhysicsWorldController* phy;
	
	NSMutableArray* pObjects;
	NSMutableArray* objects;
}

@property (retain) UIScrollView* gameArea;
@property (retain) UIView* palette;
@property (retain) NSMutableArray* objects;
@property (retain) NSMutableArray* pObjects;
@property (retain) PhysicsWorldController* phy;
@property int objCounter;

- (void)initializeViews;



- (void)addToGameArea:(GameObject*)o;
- (void)removeFromGameArea:(GameObject*)o;
- (void)initializeViews;
- (void)initializePalette;
- (void)handleTranslation:(NSNotification*)n;
- (void)handleDoubleTap:(NSNotification*)n;
- (void)handleSingleTap:(NSNotification*)n;
- (void)handlePaletteReturn:(NSNotification*)n;
@end

