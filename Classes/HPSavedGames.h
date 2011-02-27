//
//  HPSavedGames.h
//  HnP
//
//  Created by Divyanshu Arora on 2/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface HPSavedGames : UITableViewController {
    NSArray *games;
	NSString* name;
}

@property (retain) NSString* name;
@property (nonatomic, retain) NSArray *games;
@end
