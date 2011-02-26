/*
 *  Helpers.cpp
 *  HnP
 *
 *  Created by Divyanshu Arora on 2/23/11.
 *  Copyright 2011 __MyCompanyName__. All rights reserved.
 *
 */

#include "Helpers.h"

void createBodyHelper(b2Body* b, UIView* v) {
	b->SetType(b2_dynamicBody);
	v.tag = (int)b;
}


void CListener::BeginContact(b2Contact* contact)
{ // handle begin event
	const b2Body* bodyA = contact->GetFixtureA()->GetBody();		
	const b2Body* bodyB = contact->GetFixtureB()->GetBody();
	GameObject* o1 = (GameObject*)bodyA->GetUserData();
	GameObject* o2 = (GameObject*)bodyB->GetUserData();
	if ([o2 class] == [GamePig class]) {
		if (bodyA->GetType() == b2_dynamicBody) {
		    contact->SetEnabled(false);
			if (sent == false) {
				sent = true;
				[[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"pigCollided" object:o2]];
			}
		}
	}
	else if ([o1 class] == [GamePig class])
		if (bodyB->GetType() == b2_dynamicBody) {
		    contact->SetEnabled(false);
			if (sent == false) {
				sent = true;
				[[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"pigCollided" object:o1]];
			}
		}
	
}
void CListener::PreSolve(b2Contact* contact, const b2Manifold* oldManifold)
{
	const b2Body* bodyA = contact->GetFixtureA()->GetBody();		
	const b2Body* bodyB = contact->GetFixtureB()->GetBody();
	GameObject* o1 = (GameObject*)bodyA->GetUserData();
	GameObject* o2 = (GameObject*)bodyB->GetUserData();
	if ([o2 class] == [GamePig class]) {
		if (bodyA->GetType() == b2_dynamicBody) {
		    contact->SetEnabled(false);
			if (sent == false) {
				sent = true;
				[[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"pigCollided" object:o2]];
			}
		}
	}
	else if ([o1 class] == [GamePig class])
		if (bodyB->GetType() == b2_dynamicBody) {
			contact->SetEnabled(false);
			if (sent == false) {
				sent = true;
				[[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"pigCollided" object:o1]];
			}
		}
}

void CListener::Reset() {
	sent = false;
}


