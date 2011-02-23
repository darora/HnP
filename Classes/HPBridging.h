//
//  HPBridging.h
//  HnP
//
//  Created by Divyanshu Arora on 2/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum { GamePig, GameBlock, GameWolf } GameObjectType;

@interface HPBridging : NSObject {

}

-(CGPoint*)getVerticesForN:(int)n view:(UIView*)v;

@end
