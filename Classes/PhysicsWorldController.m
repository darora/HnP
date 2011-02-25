//
//  PhysicsWorldController.m
//  HnP
//
//  Created by Divyanshu Arora on 2/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PhysicsWorldController.h"

#define DEF_HEIGHT 768.0
#define DEF_WIDTH 1024.0

@implementation PhysicsWorldController



-(void)createPhysicsWorld
{
	CGSize screenSize = CGSizeMake(DEF_WIDTH, DEF_HEIGHT);
	
	b2Vec2 gravity;
	gravity.Set(0.0f, -9.81f);
	
	bool doSleep = false;
	
	world = new b2World(gravity, doSleep);
	
	world->SetContinuousPhysics(true);
	
	// Define the ground body.
	b2BodyDef groundBodyDef;
	groundBodyDef.position.Set(0, 0); // bottom-left corner
	
	b2Body* groundBody = world->CreateBody(&groundBodyDef);
	
	b2EdgeShape groundBox;
	
	// bottom
	groundBox.Set(b2Vec2(0,0), b2Vec2(screenSize.width/PTM_RATIO,0));
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

-(void)addPhysicalBodyForView:(UIView *)physicalView
{
	b2BodyDef bodyDef;
//	if ([physicalView isKindOfClass:[PolygonView class]] && [physicalView dynamic])
//		bodyDef.type = b2_dynamicBody;
//	else
		bodyDef.type = b2_dynamicBody;
	CGPoint p = physicalView.center;
	
	
	bodyDef.position.Set(p.x/PTM_RATIO, (DEF_HEIGHT - p.y)/PTM_RATIO);
	bodyDef.userData = physicalView;
	
	// Tell the physics world to create the body
	b2Body *body = world->CreateBody(&bodyDef);
	b2PolygonShape dynamicBox;
//	if ([physicalView class] == [CircleView class]) {
//		CircleView* c = (CircleView*)physicalView;
//		b2CircleShape dynamicBox;
//		//dynamicBox.m_p = b2Vec2(c.center.x/PTM_RATIO, (1024.0-c.center.y)/PTM_RATIO);
//		dynamicBox.m_radius = c.radius/PTM_RATIO;
//		// Define the dynamic body fixture.
//		b2FixtureDef fixtureDef;
//		fixtureDef.shape = &dynamicBox;
//		fixtureDef.density = 3.0f;
//		fixtureDef.friction = 0.3f;
//		fixtureDef.restitution = 0.6f; // 0 is a lead ball, 1 is a super bouncy ball
//		body->CreateFixture(&fixtureDef);
//	}
//	else {
//		b2PolygonShape dynamicBox;
//		
//		if ([physicalView class] == [PolygonView class]) {
//			PolygonView* tmp = (PolygonView*)physicalView;
//			int32 n = (int32)[tmp n];
//			float32 width = tmp.frame.size.width/2,
//			height = tmp.frame.size.height/2;
//			
//			b2Vec2* vertices = (b2Vec2*)malloc(n*sizeof(b2Vec2));
//			CGPoint* cv = [tmp vertices];
//			for (int32 i = 0; i<n; i++) {
//				b2Vec2 tmp = b2Vec2();
//				tmp.x = ((float32)cv[i].x - width)/PTM_RATIO;
//				tmp.y = ((float32)cv[i].y - height)/PTM_RATIO;
//				vertices[i] = tmp;
//			}
//			dynamicBox.Set(vertices, n);
//			free(vertices);
//		}
//		else
		{
			//For UIViews added from Interface Builder
			CGPoint boxDimensions = CGPointMake(physicalView.bounds.size.width/PTM_RATIO/2.0,physicalView.bounds.size.height/PTM_RATIO/2.0);
			dynamicBox.SetAsBox(boxDimensions.x, boxDimensions.y);
		}
		b2FixtureDef fixtureDef;
		fixtureDef.shape = &dynamicBox;
		fixtureDef.density = 5.0f;
		fixtureDef.friction = 0.3f;
		fixtureDef.restitution = 0.25f; // 0 is a lead ball, 1 is a super bouncy ball
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
			//if (gravitySource.x != -1) {
//				//NSLog(@"Hey gravity's not zero: %lf, %lf", gravitySource.x, gravitySource.y);
//				b2Vec2 pos = b->GetPosition();
//				b2Vec2 loc = b2Vec2(gravitySource.x/PTM_RATIO, (1024-gravitySource.y)/PTM_RATIO);
//				b2Vec2 d = loc - pos;
//				float force = 10.0f * d.LengthSquared();
//				d.Normalize();
//				b2Vec2 F = force * d;
//				b->ApplyForce(F, pos);
//			}	
//			
			UIView *oneView = (UIView *)b->GetUserData();
			
			// y Position subtracted because of flipped coordinate system
			CGPoint newCenter = CGPointMake(b->GetPosition().x * PTM_RATIO,
											DEF_HEIGHT - b->GetPosition().y * PTM_RATIO);
			oneView.center = newCenter;
			
			CGAffineTransform transform = CGAffineTransformMakeRotation(- b->GetAngle());
			
			oneView.transform = transform;
		}
	}
}

-(id)initWithViews:(NSMutableArray*)views {
	//Should be nil terminated array of views
	for (UIView *oneView in views)
	{
		[self addPhysicalBodyForView:oneView];
	}
	
	//TODO: This code is to be ported into the global controller.
	[[UIAccelerometer sharedAccelerometer] setUpdateInterval:(1.0 / 60.0)];
	[[UIAccelerometer sharedAccelerometer] setDelegate:self];
	tickTimer = [NSTimer scheduledTimerWithTimeInterval:1.0/60.0 target:self selector:@selector(tick:) userInfo:nil repeats:YES];
}

@end
