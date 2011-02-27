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


//void CListener::BeginContact(b2Contact* contact)
//{ // handle begin event
//	const b2Body* bodyA = contact->GetFixtureA()->GetBody();		
//	const b2Body* bodyB = contact->GetFixtureB()->GetBody();
//	GameObject* o1 = (GameObject*)bodyA->GetUserData();
//	GameObject* o2 = (GameObject*)bodyB->GetUserData();
//	if ([o2 class] == [GamePig class]) {
//		if (bodyA->GetType() == b2_dynamicBody) {
//		    contact->SetEnabled(false);
//			if (sent == false) {
//				sent = true;
//				[[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"pigCollided" object:o2]];
//			}
//		}
//	}
//	else if ([o1 class] == [GamePig class])
//		if (bodyB->GetType() == b2_dynamicBody) {
//		    contact->SetEnabled(false);
//			if (sent == false) {
//				sent = true;
//				[[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"pigCollided" object:o1]];
//			}
//		}
//	
//}
void CListener::PreSolve(b2Contact* contact, const b2Manifold* oldManifold)
{
	const b2Body* bodyA = contact->GetFixtureA()->GetBody();		
	const b2Body* bodyB = contact->GetFixtureB()->GetBody();
	if (bodyA->GetType() != b2_dynamicBody)
		return;
	if (bodyB->GetType() != b2_dynamicBody)
		return;	
	GameObject* o1 = (GameObject*)bodyA->GetUserData();
	GameObject* o2 = (GameObject*)bodyB->GetUserData();
	if (!o1 || !o2) {
		contact->SetEnabled(false);
		return;
	}
		
	if (([o2 class] == [GamePig class]) || ([o1 class] == [GamePig class])) {
		b2WorldManifold worldManifold;
		contact->GetWorldManifold(&worldManifold);		
		b2PointState state1[2], state2[2];	
		b2GetPointStates(state1, state2, oldManifold, contact->GetManifold());		
		if (state2[0] == b2_addState)		
		{		
			b2Vec2 point = worldManifold.points[0];		
			b2Vec2 vA = bodyA->GetLinearVelocityFromWorldPoint(point);		
			b2Vec2 vB = bodyB->GetLinearVelocityFromWorldPoint(point);
			float32 approachVelocity = b2Dot(vB-vA, worldManifold.normal);
			if (fabs(approachVelocity) > 30.0f)
			{			
				if ([o2 class] == [GamePig class]) {
						contact->SetEnabled(false);
						if (sent == false) {
							sent = true;
							[[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"pigCollided" object:o2]];
						}
				}
				else if ([o1 class] == [GamePig class]) {
						contact->SetEnabled(false);
						if (sent == false) {
							sent = true;
							[[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"pigCollided" object:o1]];
						}
				}
			}
		}
	}
	if ([o1 class] == [GameBreath class] || [o2 class] == [GameBreath class])
		if ([o1 class] == [GameBlock class] || [o2 class] == [GameBlock class]) {
			contact->SetEnabled(false);
			if ([o1 class] == [GameBlock class]) {
				if ([(GameBlock*)o1 category] == straw) {
					[o2 setState:stale];
					[o1 setState:gg];
				}
				else
					[o2 setState:gg];
			}
			else {
				if ([(GameBlock*)o2 category] == straw) {
					[o1 setState:stale];
					[o2 setState:gg];
				}
				else
					[o1 setState:gg];
			}
		}
	//End breath stuff
	
}

void CListener::Reset() {
	sent = false;
}


