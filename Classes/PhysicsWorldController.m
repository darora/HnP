//
//  PhysicsWorldController.m
//  HnP
//
//  Created by Divyanshu Arora on 2/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PhysicsWorldController.h"

#define DEF_HEIGHT 708.0
#define DEF_WIDTH 1600.0
#define GROUND_HEIGHT 100.0

@implementation PhysicsWorldController

@synthesize tickTimer;
@synthesize cl;

-(void)createPhysicsWorld
{
	CGSize screenSize = CGSizeMake(DEF_WIDTH, DEF_HEIGHT);
	
	b2Vec2 gravity;
	gravity.Set(0.0f, -25.62f);
	
	bool doSleep = false;
	
	world = new b2World(gravity, doSleep);
	cl = new CListener();
	cl->Reset();
	world->SetContactListener(cl);
	world->SetContinuousPhysics(true);
	
	// Define the ground body.
	b2BodyDef groundBodyDef;
	groundBodyDef.position.Set(0, 0); // bottom-left corner
	
	b2Body* groundBody = world->CreateBody(&groundBodyDef);
	
	b2EdgeShape groundBox;
	
	// bottom
	groundBox.Set(b2Vec2(0,GROUND_HEIGHT/PTM_RATIO), b2Vec2(screenSize.width/PTM_RATIO,GROUND_HEIGHT/PTM_RATIO));
	groundBody->CreateFixture(&groundBox, 0);
	
	// top
	groundBox.Set(b2Vec2(0,screenSize.height/PTM_RATIO), b2Vec2(screenSize.width/PTM_RATIO,screenSize.height/PTM_RATIO));
	groundBody->CreateFixture(&groundBox, 0);
	
	// left
	groundBox.Set(b2Vec2(0,screenSize.height/PTM_RATIO), b2Vec2(0,0));
	groundBody->CreateFixture(&groundBox, 0);
	
	// right
	groundBox.Set(b2Vec2(screenSize.width/PTM_RATIO,screenSize.height/PTM_RATIO), b2Vec2(screenSize.width/PTM_RATIO,0));
	groundBody->CreateFixture(&groundBox, 0);
}

-(void)addPhysicalBodyForGameObject:(GameObject *)object
{
	UIView* physicalView = [object view];
	b2BodyDef bodyDef;
//	if ([physicalView isKindOfClass:[PolygonView class]] && [physicalView dynamic])
//		bodyDef.type = b2_dynamicBody;
//	else
		bodyDef.type = b2_dynamicBody;
	CGPoint p = physicalView.center;
	
	
	bodyDef.position.Set(p.x/PTM_RATIO, (DEF_HEIGHT - p.y)/PTM_RATIO);
	bodyDef.userData = object;
	bodyDef.angle = - object.angle;
	
	// Tell the physics world to create the body
	b2Body *body = world->CreateBody(&bodyDef);
	b2PolygonShape dynamicBox;
		{
			//For UIViews added from Interface Builder
			CGPoint boxDimensions = CGPointMake(object.scale*physicalView.bounds.size.width/PTM_RATIO/2.0,object.scale*physicalView.bounds.size.height/PTM_RATIO/2.0);
			dynamicBox.SetAsBox(boxDimensions.x, boxDimensions.y);
		}
	b2FixtureDef fixtureDef;
	fixtureDef.shape = &dynamicBox;
	fixtureDef.density = 15.0f;
	fixtureDef.friction = 0.3f;
	fixtureDef.restitution = 0.35f;
	if ([object class] == [GameBreath class]) {
		GameBreath* tmp = (GameBreath*)object;
		float32 x = tmp.velocity;
		float32 y = tmp.trajAngle;
		body->SetLinearVelocity(b2Vec2(x,y));
	}		
	body->CreateFixture(&fixtureDef);
	createBodyHelper(body, physicalView);
	
	
}

-(void)tick:(NSTimer *)timer
{
	
	int32 velocityIterations = 8;
	int32 positionIterations = 4;
	
	world->Step(1.0f/60.0f, velocityIterations, positionIterations);
	
	for (b2Body* b = world->GetBodyList(); b; b = b->GetNext())
	{
		if (b->GetUserData() != NULL)
		{
			//UIView *oneView = (UIView *)b->GetUserData();
			GameObject* o = (GameObject*)b->GetUserData();
			
			if (o.state == gg) {
				//remove obj
				b2Body* tmp = b->GetNext();
				world->DestroyBody(b);
				b = tmp;
				[[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"phyObjectDeleted" object:o]];
			}
			else if (o.state == stale) {
				//half the speed of the breath
				o.state = fresh;
				b2Vec2 tmpbb = b->GetLinearVelocity();
				tmpbb.x /= 2;
				tmpbb.y /= 2;
				b->SetLinearVelocity(tmpbb);
			}
			else {//fresh, normal collisions
			
				// y Position subtracted because of flipped coordinate system
				CGPoint newCenter = CGPointMake(b->GetPosition().x * PTM_RATIO,	DEF_HEIGHT - b->GetPosition().y * PTM_RATIO);
				o.center = newCenter;
				double ang = - b->GetAngle();
				o.angle = ang;
				[o updateView];
				//oneView.transform = transform;
			}
		}
	}
}

-(void)removeBody:(GameObject*)body {
	for (b2Body* b = world->GetBodyList(); b; b=b->GetNext()) {
		if (b->GetUserData() != NULL) {
			GameObject* o = (GameObject*)b->GetUserData();
			if (o.number == body.number)
			{
				b2Body* tmp = b->GetNext();
				world->DestroyBody(b);
				b = tmp;
				break;
			}
		}
	}			
}

-(id)initWithObjectsArray:(NSMutableArray*)objects {
	if (self = [super init]) {
		[self createPhysicsWorld];
		for (int i=0; i<[objects count]; i++)
		{
			//UIView* oneView = [[objects objectAtIndex:i] view];
			[self addPhysicalBodyForGameObject:[objects objectAtIndex:i]];
		}
		
		//TODO: This code is to be ported into the global controller.
		//[[UIAccelerometer sharedAccelerometer] setUpdateInterval:(1.0 / 60.0)];
		//	[[UIAccelerometer sharedAccelerometer] setDelegate:self];
		if ([objects count] > 0)
			self.tickTimer = [NSTimer scheduledTimerWithTimeInterval:1.0/60.0 target:self selector:@selector(tick:) userInfo:nil repeats:YES];
	}
	else {
		self = nil;
	}
	return self;

}

- (void)dealloc {
	//TODO release world & invalidate timer
	if ([tickTimer isValid])
		[tickTimer invalidate];
	[tickTimer release];
	[super dealloc];
}

@end
