//
//  HnPViewController.m
//  HnP
//
//  Created by Divyanshu Arora on 2/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HPViewController.h"

#define PALETTE_HEIGHT 60.0
#define SCROLL_WIDTH 1600.0
#define GROUND_HEIGHT 100.0

@implementation HPViewController

@synthesize gameArea;
@synthesize palette;
@synthesize objCounter;
@synthesize objects;
@synthesize pObjects;
@synthesize wObjects;
@synthesize phy;
@synthesize save;
@synthesize load;
@synthesize start;
@synthesize nameField;

/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	[[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
	
	objCounter = 0;
	self.objects = [NSMutableArray arrayWithCapacity:5];
	self.pObjects = [NSMutableArray arrayWithCapacity:3];
	self.wObjects = [NSMutableArray arrayWithCapacity:4];
	
	[self initializeViews];
	[self initializePalette];
	[self initializeListeners];
}



// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight;
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
	[self removeEverything];
	for (UIView* v in gameArea.subviews) {
		[v removeFromSuperview];
	}
	for (UIView* v in palette.subviews) {
		[v removeFromSuperview];
	}
	[gameArea removeFromSuperview];
	[palette removeFromSuperview];	
}


- (void)dealloc {
    [super dealloc];
}




/*
 Custom Methods start here
 */

- (void)addToGameArea:(GameObject*)o {
	BOOL present = NO;
	int x = [o number];
	for (int i=0; i<[self.objects count]; i++)
		if (x == [[self.objects objectAtIndex:i] number])
			present = YES;
	if (!present)
	{
		[self.objects addObject:o];
	}
	[gameArea addSubview:o.view];
}

- (void)removeFromGameArea:(GameObject*)o {
	for (int i=0; i<[self.objects count]; i++) {
		GameObject* tmp = [self.objects objectAtIndex:i];
		if (o.number == [tmp number]) {
			[tmp.view removeFromSuperview];
			[self.objects removeObjectAtIndex:i];
			[tmp release];
			tmp = nil;
			return;
		}
	}
}

- (void)initializeViews {
	CGRect tmp = CGRectMake(0, 0, 1024, PALETTE_HEIGHT);
	
	//This provides a translucent background for the palette
	UIView* tmp_view = [[UIView alloc] initWithFrame:tmp];
	tmp_view.backgroundColor = [UIColor grayColor];
	tmp_view.alpha = 0.6;
	[self.view addSubview:tmp_view];
	[tmp_view release];
	
	
	gameArea = [[UIScrollView alloc] initWithFrame:CGRectMake(0, PALETTE_HEIGHT, 1024, 768 - PALETTE_HEIGHT)];
	
	UIImage* bg = [UIImage imageNamed:@"background.png"];
	UIImage* grnd = [UIImage imageNamed:@"ground.png"];
	
	UIImageView* bgView = [[UIImageView alloc] initWithImage:bg];
	bgView.frame = CGRectMake(0, 0, SCROLL_WIDTH, 768 - PALETTE_HEIGHT - GROUND_HEIGHT);
	
	UIImageView* grndView = [[UIImageView alloc] initWithImage:grnd];
	grndView.frame = CGRectMake(0, 768 - PALETTE_HEIGHT - GROUND_HEIGHT, SCROLL_WIDTH, GROUND_HEIGHT);
	
	[gameArea addSubview:bgView];
	[gameArea addSubview:grndView];
	[gameArea setContentSize:CGSizeMake(SCROLL_WIDTH, 768-PALETTE_HEIGHT)];
	[self.view addSubview:gameArea];
	[gameArea release];
	
	palette = [[UIView alloc] initWithFrame:tmp];
	palette.backgroundColor = [UIColor clearColor];
	[self.view addSubview:palette];
	[palette release];
	
	
	[bgView release];
	[grndView release];
	
	
	//Buttons
	UIToolbar* tb = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 728, 1024, 40)];
	[self.view addSubview:tb];
	[tb release];
	self.save = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	save.frame = CGRectMake(50, 5, 80, 30);
	[save setTitle:@"Save" forState:UIControlStateNormal];
	[save addTarget:self action:@selector(saveButtonPressed) forControlEvents:UIControlEventTouchUpInside];
	[tb addSubview:save];
	//[save release];
	
	self.load = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	load.frame = CGRectMake(150, 5, 80, 30);
	[load setTitle:@"Load" forState:UIControlStateNormal];
	[load addTarget:self action:@selector(loadButtonPressed) forControlEvents:UIControlEventTouchUpInside];
	[tb addSubview:load];
	//[load release];
	
	UIButton* reset = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	reset.frame = CGRectMake(894, 5, 80, 30);
	[reset setTitle:@"Reset" forState:UIControlStateNormal];
	[reset addTarget:self action:@selector(resetButtonPressed) forControlEvents:UIControlEventTouchUpInside];
	[tb addSubview:reset];
	//[reset release];
	
	self.start = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	start.frame = CGRectMake(470, 5, 80, 30);
	[start setTitle:@"Start" forState:UIControlStateNormal];
	[start addTarget:self action:@selector(startButtonPressed) forControlEvents:UIControlEventTouchUpInside];
	[tb addSubview:start];
	//[start release];
	
}

- (void)initializePalette {
	GamePig* pig = [[GamePig alloc] initWithFrame:pigDefault Angle:d2r(0) Number:objCounter++];
	GameBlock* block = [[GameBlock alloc] initWithFrame:blockDefault Angle:d2r(0) Number:objCounter++];
	GameWolf* wolf = [[GameWolf alloc] initWithFrame:wolfDefault Angle:d2r(0) Number:objCounter++];
	[pObjects addObject:pig];
	[pObjects addObject:block];
	[pObjects addObject:wolf];
	[palette addSubview:pig.view];
	[palette addSubview:wolf.view];
	[palette addSubview:block.view];
}

- (void)initializeListeners {
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleTranslation:) name:@"objectDidTranslate" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleSingleTap:) name:@"wolfWasTapped" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleDoubleTap:) name:@"objectDidGetDoubleTapped" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handlePaletteReturn:) name:@"restoreToPalette" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadFileSelected:) name:@"fileNameChosen" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handlePigCollision:) name:@"pigCollided" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleBreathExpired:) name:@"removeBreath" object:nil];
	//TODO: Listener for wolfDidExpire
}

- (void)handleTranslation:(NSNotification*)n {
	GameObject* o = [n object];
	if ([o.view isDescendantOfView:self.palette]) {
		int i = [self.pObjects indexOfObject:o];
		o.center = CGPointMake(o.center.x + gameArea.contentOffset.x, o.center.y - PALETTE_HEIGHT);
		o.scale = 2.0;
		[o updateView];
		[self.pObjects removeObjectAtIndex:i];
		[self addToGameArea:o];
		if ([o class] == [GameBlock class]) {
			GameBlock* blk = [[GameBlock alloc] initWithFrame:blockDefault Angle:d2r(0) Number:objCounter++];
			[palette addSubview:blk.view];
			[pObjects addObject:blk];
		}
	}	
}

- (void)handleDoubleTap:(NSNotification*)n {
	GameObject* o = [n object];
	if ([o.view isDescendantOfView:palette])
		return;	//Maybe a UIAlert??
	if ([o class] == [GameBlock class]) {
		//Just remove from UI models
		[self removeFromGameArea:o];
	}
	else {
		//Its a pig or wolf. Return to palette
		[o restoreToPalette];
	}

	
}

- (void)handleSingleTap:(NSNotification*)n {
	GameBlock* o = [n object];
	//Breath for wolf
	if ([o class] == [GameWolf class]) {
		GameWolf* wolf = (GameWolf*)o;
		
		if ([wObjects count] > 0) {
			while ([wObjects count] > 0) {
				if ([[wObjects objectAtIndex:0] isKindOfClass:[UIView class]])
					[[wObjects objectAtIndex:0] removeFromSuperview];
				else {
					GameObject* tmp = [wObjects objectAtIndex:0];
					if ([tmp isKindOfClass:[GameArrow class]])
					{
						[[(GameArrow*)tmp arr] removeFromSuperview];
						[[(GameArrow*)tmp dir] removeFromSuperview];
					}
					else [tmp.view removeFromSuperview];
				}
				[wObjects removeObjectAtIndex:0];
			}
			return;
		}
		//TODO:add breath
		GameArrow* arrow = [[GameArrow alloc] initWithFrame:CGRectMake(0, 0, 100, 100) Angle:0 Number:objCounter++ Wolf:wolf];
		[gameArea addSubview:arrow.arr];
		[gameArea addSubview:arrow.dir];
		[wObjects addObject:arrow];		
	}	
}


- (void)handlePaletteReturn:(NSNotification*)n {
	GameObject* o = [n object];
	
	if ([o.view isDescendantOfView:gameArea]) {
		[o retain];
		[self removeFromGameArea:o];
		[self.pObjects addObject:o];
		[palette addSubview:o.view];
	}
	
	CGPoint tmp;
	if ([o class] == [GamePig class])
		tmp = CGPointMake(pigDefault.origin.x + pigDefault.size.width/2, pigDefault.origin.y + pigDefault.size.height/2);
	else if ([o class] == [GameWolf class])
		tmp = CGPointMake(wolfDefault.origin.x + wolfDefault.size.width/2, wolfDefault.origin.y + wolfDefault.size.height/2);
	o.center = tmp;
	o.angle = d2r(0);
	o.scale = 1;
	[o updateView];
}

- (void)handleBreathExpired:(NSNotification*)n {
	GameBreath* tmp = (GameBreath*)[n object];
	[self.phy removeBody:tmp];
	[self removeFromGameArea:tmp];
	
	//STOP GAME
	if (self.phy) {
		[self.phy.tickTimer invalidate];
		[self.phy release];
		self.phy = nil;
		[start setTitle:@"Start" forState:UIControlStateNormal];
	}
	for (int i=0; i<[objects count]; i++) {
		GameObject* tmp = [objects objectAtIndex:i];
		if ([tmp class] == [GameWolf class]) {
			tmp.view.userInteractionEnabled = YES;
			tmp.view.multipleTouchEnabled = YES;
		}
		else if ([tmp class] == [GameBreath class]) {
			[[(GameBreath*)tmp time] invalidate];
			[self removeFromGameArea:tmp];
		}
	}
	
}

- (void)resetScreen {
	[self removeEverything];
	[start setTitle:@"Start" forState:UIControlStateNormal];
	[self initializePalette];
}

- (void)removeEverything {
	if (self.phy) {
		[self.phy.tickTimer invalidate];
		[self.phy release];
		self.phy = nil;
	}	
	while ([self.objects count] > 0) {
		GameObject* tmp = [self.objects objectAtIndex:0];
		if ([tmp isKindOfClass:[UIView class]]) {
			UIView* v = (UIView*)tmp;
			[v removeFromSuperview];
		}
		else [[tmp view] removeFromSuperview];
		[self.objects removeObjectAtIndex:0];
		[tmp release];
	}
	while ([self.pObjects count] > 0) {
		GameObject* tmp = [self.pObjects objectAtIndex:0];
		if ([tmp isKindOfClass:[UIView class]]) {
			UIView* v = (UIView*)tmp;
			[v removeFromSuperview];
		}
		else [[tmp view] removeFromSuperview];
		[self.pObjects removeObjectAtIndex:0];
		[tmp release];
	}
	while ([self.wObjects count] > 0) {
		GameObject* tmp = [self.wObjects objectAtIndex:0];
		if ([tmp isKindOfClass:[UIView class]]) {
			UIView* v = (UIView*)tmp;
			[v removeFromSuperview];
		}
		else [[tmp view] removeFromSuperview];
		[self.wObjects removeObjectAtIndex:0];
		[tmp release];
	}
}

- (void)saveButtonPressed {
	UIAlertView* dialog = [[UIAlertView alloc] init];
	[dialog setDelegate:self];
	[dialog setTitle:@"Enter File Name"];
	[dialog setMessage:@" "];
	[dialog addButtonWithTitle:@"Cancel"];
	[dialog addButtonWithTitle:@"OK"];
	
	nameField = [[UITextField alloc] initWithFrame:CGRectMake(20.0, 30.0, 245.0, 25.0)];
	[nameField setBackgroundColor:[UIColor whiteColor]];
	[dialog addSubview:nameField];
	//[dialog setTransform: moveUp];
	[dialog show];
	[dialog release];
	[nameField release];
}

- (void) alertView:(UIAlertView *)alert clickedButtonAtIndex:(NSInteger)buttonIndex {
	NSString* inputText = [nameField text];
	if (buttonIndex == 1) {
		NSMutableData *data = [[NSMutableData alloc] init];
		NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
		[archiver encodeRootObject:self.objects];
		[archiver finishEncoding];
		NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
		NSString *plistPath = [rootPath stringByAppendingPathComponent:inputText];
		[data writeToFile:plistPath atomically:YES];
		[archiver release];
		[data release];
	}
	else
		return;//Cancel
}

- (void)loadButtonPressed {
	table = [[HPSavedGames alloc] 
							 initWithStyle:UITableViewStylePlain];
	pop = [[UIPopoverController alloc] 
									initWithContentViewController:table];
	[pop presentPopoverFromRect:load.frame inView:load.superview permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (void)loadFileSelected:(NSNotification*)n {
	NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:[n object]];
	NSData *data = [NSData dataWithContentsOfFile:plistPath];
	NSKeyedUnarchiver *ua = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
	if (data != NULL) {
		[self removeEverything];
		BOOL bwolf = YES, bpig = YES;
		self.objects = [ua decodeObject];
		for (int i=0; i < [self.objects count]; i++) {
			GameObject* tmp = [self.objects objectAtIndex:i];
			[self addToGameArea:tmp];
			[tmp updateView];
			if ([tmp class] == [GameWolf class])
				bwolf = NO;
			else if ([tmp class] == [GamePig class])
				bpig = NO;
		}
		GameBlock* block = [[GameBlock alloc] initWithFrame:blockDefault Angle:d2r(0) Number:objCounter++];
		[palette addSubview:block.view];
		[pObjects addObject:block];
		
		if (bpig) {
			GamePig* pig = [[GamePig alloc] initWithFrame:pigDefault Angle:d2r(0) Number:objCounter++];
			[pObjects addObject:pig];
			[palette addSubview:pig.view];
		}
		if (bwolf) {
			GameWolf* wolf = [[GameWolf alloc] initWithFrame:wolfDefault Angle:d2r(0) Number:objCounter++];
			[pObjects addObject:wolf];
			[palette addSubview:wolf.view];
		}
	}
	[data release];
    [pop dismissPopoverAnimated:YES];
	[table release];
	[pop release];
}

- (void)resetButtonPressed {
	[self resetScreen];
}

- (void)startButtonPressed {
	//If game is already running, stop physics
	if (self.phy) {
		[self.phy.tickTimer invalidate];
		[self.phy release];
		self.phy = nil;
		for (int i=0; i<[objects count]; i++) {
			GameObject* tmp = [objects objectAtIndex:i];
			if ([tmp class] == [GameWolf class]) {
				tmp.view.userInteractionEnabled = YES;
				tmp.view.multipleTouchEnabled = YES;
			}
			else if ([tmp class] == [GameBreath class]) {
				[[(GameBreath*)tmp time] invalidate];
				[self removeFromGameArea:tmp];
			}
		}
		[self.start setTitle:@"Start" forState:UIControlStateNormal];
		return;
	}
	
	//else start physics, add breath
	
	GameWolf* wolf;
	for (int i=0; i < [objects count]; i++) {
		GameObject* o = [objects objectAtIndex:i];
		[[o view] setUserInteractionEnabled:NO];
		if ([o class] == [GameWolf class])
			wolf = (GameWolf*)o;
	}
	for (int i=0; i < [pObjects count]; i++) {
		[[[pObjects objectAtIndex:i] view] setUserInteractionEnabled:NO];
	}
	//Remove arrows
	double scale = 10.0, angle = 0.0;
	for (int i=0; i < [wObjects count]; i++) {
		if ([[wObjects objectAtIndex:i] isKindOfClass:[GameArrow class]]) {
			GameArrow* tmp = [wObjects objectAtIndex:i];
			scale = 1/[tmp sca];
			angle = [tmp ang];
			NSLog(@"%lf", scale);
			[[[wObjects objectAtIndex:i] arr] removeFromSuperview];
			[[[wObjects objectAtIndex:i] dir] removeFromSuperview];
			break;
		}
	}
	
	GameBreath* b = [[GameBreath alloc] initWithFrame:CGRectMake((wolf.center.x+wolf.view.frame.size.width/2), (wolf.center.y-wolf.view.frame.size.height/2), 112, 104) 
												Angle:0 Number:objCounter++ Velocity:scale*20000 trajectoryAngle:-angle*50];
	[self addToGameArea:b];
	wolf.lives--;
	[wolf animate];
	phy = [[PhysicsWorldController alloc] initWithObjectsArray:self.objects];
	[self.start setTitle:@"Stop" forState:UIControlStateNormal];
}

- (void)handlePigCollision:(NSNotification*)n {
	if (self.phy) {
		[self.phy.tickTimer invalidate];
		[self.phy release];
		self.phy = nil;
	}
	GamePig* pig = [n object];
	[self removeFromGameArea:pig];
	UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(100, 200, 800, 500)];
	label.text = @"The little piggy is dead! :D\n Wolf wins";
	label.textColor = [UIColor redColor];
	label.shadowColor = [UIColor yellowColor];
	label.backgroundColor = [UIColor clearColor];
	label.shadowOffset = CGSizeMake(1,1);
	label.font = [UIFont fontWithName:@"AmericanTypewriter-Bold" size: 36.0];
	label.textAlignment = UITextAlignmentCenter;
	[gameArea addSubview:label];
	[wObjects addObject:label];
	//TODO: Reset & load next level
}




@end
