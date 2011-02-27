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
#import <GameBreath.h>
#import <GameBlock.h>

void createBodyHelper(b2Body* b, UIView* v);

class CListener : public b2ContactListener

{
public:
	void PreSolve(b2Contact* contact, const b2Manifold* oldManifold);
	//This method is used by box2d's world to resolve contact points
	//It modifies the 'state'/ quality of certain objects as dictated by the PS
	//These changes in state are handled by the world in PhysicsWorldController
	//Pig's collisions within some perimeters results in a pigCollided notification, which is handled by the global controller.
	
	void Reset();
	//Only here for legacy reason..should be able to remove this w/o problems soon..
	
private:
	bool sent;
};