//
//  PhysicsWorldController.h
//  HnP
//
//  Created by Divyanshu Arora on 2/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Box2D/Box2D.h"
#import <QuartzCore/QuartzCore.h>
#import <GameObject.h>
#import <GameBreath.h>
#import "Helpers.h"

#define PTM_RATIO 10	//Pixel to meter ratio for Box2D

@interface PhysicsWorldController : NSObject {
	b2World* world;
	CListener* cl;
	NSTimer *tickTimer;
}

@property (assign) CListener* cl;
@property (retain) NSTimer* tickTimer;

-(id)initWithObjectsArray:(NSMutableArray*)objects;
-(void)removeBody:(GameObject*)body;
-(void)tick:(NSTimer *)timer;
-(void)addPhysicalBodyForGameObject:(GameObject *)object;
-(void)createPhysicsWorld;

@end
