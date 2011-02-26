/*
 *  Helpers.h
 *  HnP
 *
 *  Created by Divyanshu Arora on 2/23/11.
 *  Copyright 2011 __MyCompanyName__. All rights reserved.
 *
 */

#import <UIKit/UIKit.h>
#import <Box2D.h>
#import <GameObject.h>
#import <GamePig.h>

void createBodyHelper(b2Body* b, UIView* v);
class CListener : public b2ContactListener

{
public:
	//void BeginContact(b2Contact* contact);
	void PreSolve(b2Contact* contact, const b2Manifold* oldManifold);
	void Reset();
private:
	bool sent;
};