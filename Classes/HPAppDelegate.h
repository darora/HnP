//
//  HnPAppDelegate.h
//  HnP
//
//  Created by Divyanshu Arora on 2/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HPViewController;

@interface HPAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    HPViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet HPViewController *viewController;

@end

