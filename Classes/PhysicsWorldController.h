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
//REQUIRES: Array of GameObjects which are in the gameArea. Just pass global controller's objects array
//MODIFIES: calls createPhysicsWorld, then calls addPhysicalBodyForGameObject for each of the objects in the array passed to it
//			Also creates a timer that triggers teh tick function every 1/60secs to process physics
//RETURNS: self

-(void)removeBody:(GameObject*)body;
//REQUIRES: A valid gameobject that has a corresponding body in the physics world
//MODIFIES: the physics world - destroys the body corresponding to the given object
//RETURNS: -

-(void)tick:(NSTimer *)timer;
//REQUIRES: Called by timer started in init
//MODIFIES: Processes physics, removes object/halves strength of breath as necessary due to changes made by the Contact Listener class from Helpers.cpp
//RETURNS: -

-(void)addPhysicalBodyForGameObject:(GameObject *)object;
//REQUIRES: A valid gameobject derivative
//MODIFIES: world: adds a body corresponding to the gameobject's properties
//RETURNS: -

-(void)createPhysicsWorld;
//REQUIRES: -
//MODIFIES: Creates the global physics world
//RETURNS: -


@end
