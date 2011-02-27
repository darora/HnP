//
//  GameObject.h
//  HnP
//
//  Created by Divyanshu Arora on 2/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import "GameObjectDelegate.h"

#define d2r(x) (M_PI * x / 180.0)

//Default positions on the pallette.
#define pigDefault CGRectMake(300, 0, 60, 60)
#define wolfDefault CGRectMake(0, 0, 90, 60)
#define blockDefault CGRectMake(175, 0, 60, 60)
typedef enum { fresh, stale, gg} quality;

@interface GameObject : UIViewController <NSCoding> {
	CGSize size;
	CGFloat angle;
	CGFloat scale;
	CGPoint center;
	int number;
	GameObjectDelegate* deleg;
	quality state;
}

@property quality state;
@property CGPoint center;
@property CGSize size;
@property CGFloat angle;
@property CGFloat scale;
@property int number;
@property (assign) GameObjectDelegate* deleg;

- (id)initWithFrame:(CGRect)f Angle:(CGFloat)a Number:(int)n;
- (void)addGestures;
- (void)setViewProps;
- (void)updateView;
- (void)restoreToPalette;

- (void)rotate:(UIGestureRecognizer *)gesture;
- (void)zoom:(UIGestureRecognizer *)gesture;
- (void)doubleTap:(UIGestureRecognizer *)gesture;
- (void)translate:(UIGestureRecognizer *)gesture;

+ (NSMutableArray*)splitImage:(CGImageRef)img xSplits:(int)x ySplits:(int)y;

- (void)encodeWithCoder:(NSCoder *)encoder;
- (id)initWithCoder:(NSCoder *)decoder;
@end
