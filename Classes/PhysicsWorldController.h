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
#import "Helpers.h"

#define PTM_RATIO 10	//Pixel to meter ratio for Box2D

@interface PhysicsWorldController : NSObject {
	b2World* world;
	NSTimer *tickTimer;
	CGPoint gravitySource;
}

-(id)initWithViews:(NSMutableArray*)views;

@end
