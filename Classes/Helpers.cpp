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