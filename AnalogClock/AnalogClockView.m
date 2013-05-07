//
//  AnalogClockView.m
//  AnalogClock
//
//  Created by cod7ce on 3/21/13.
//  Copyright (c) 2013 纸房子. All rights reserved.
//

#import "AnalogClockView.h"
//#import "AnalogClockBackground.h"

@implementation AnalogClockView

float CONTAINER_WIDTH = 877.0;
float CONTAINER_HEIGHT = 877.0;

float HOUR_WIDTH = 22.0;
float HOUR_HEIGHT = 330.0;
float HOUR_DRIFT = 17.0;
float HOUR_WEI = 90.0;

float MIN_WIDTH = 21.0;
float MIN_HEIGHT = 403.0;
float MIN_DRIFT = 16.0;
float MIN_WEI  = 90.0;

float SEC_WIDTH  = 33.0;
float SEC_HEIGHT  = 355.0;
float SEC_DRIFT  = 22.0;
float SEC_WEI  = 81.0;

NSBundle *bundle;

NSString *ModuleName  = @"com.zhifangzi.analogclock";
NSString *EditorPanel = @"EditorPanel";
NSString *GalleryPath = @"GalleryPath";
NSString *RecursionPath = @"RecursionPath";

NSString *DefaultPath = @"~/Pictures";

NSString *Account = @"cod7ce@gmail.com";

- (id)initWithFrame:(NSRect)frame isPreview:(BOOL)isPreview
{
    self = [super initWithFrame:frame isPreview:isPreview];
    if (self) {
        bundle = [NSBundle bundleForClass:[self class]];
        ScreenSaverDefaults *defaults = [ScreenSaverDefaults defaultsForModuleWithName:ModuleName];
        [defaults registerDefaults:[NSDictionary dictionaryWithObjectsAndKeys:@"YES", EditorPanel, @"NO", RecursionPath, @"~/Pictures/", GalleryPath, nil]];
        shadowTool = [[DCShadow alloc] init];
        [self setAnimationTimeInterval:1.0];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    return [self initWithFrame:NSZeroRect isPreview:NO];
}

- (void)startAnimation
{
    [super startAnimation];
    [self initLayerWithFrame: self.frame];
}
- (void)drawRect:(NSRect)rect
{
    [super drawRect:rect];
}

- (void)animateOneFrame
{
    [self updateClock];
}

- (BOOL)hasConfigureSheet
{
    return YES;
}

- (NSWindow*)configureSheet
{
    if (!configureSheet) {
        [NSBundle loadNibNamed:@"ConfigureSheet" owner:self];
    }
    
    ScreenSaverDefaults *defaults = [ScreenSaverDefaults defaultsForModuleWithName:ModuleName];
    if (![DefaultPath isEqualToString:[defaults stringForKey:GalleryPath]]) {
        [selfPathRadios selectCellAtRow:1 column:0];
        [urlField setStringValue:[defaults stringForKey:GalleryPath]];
    }else{
        [selfPathRadios selectCellAtRow:0 column:0];
        [urlField setStringValue:@""];
    }
	[editorPanelChecker setState:[defaults boolForKey:EditorPanel]];
    [recursionChecker setState:[defaults boolForKey:RecursionPath]];
    return configureSheet;
}


- (void)initLayerWithFrame:(NSRect)frame
{
    [self recaculateOriginSizeByFrame:frame];
    NSString *clock  = [bundle pathForResource:@"panel" ofType:@"png"];
    NSString *hour   = [bundle pathForResource:@"hour" ofType:@"png"];
    NSString *min    = [bundle pathForResource:@"min" ofType:@"png"];
    NSString *sec    = [bundle pathForResource:@"second" ofType:@"png"];
    
    //*
    CGColorRef myShadowColor=CGColorCreateGenericRGB(0.0f,0.0f,0.0f,1.0f);
    
    containerLayer = [CALayer layer];
    containerLayer.backgroundColor = CGColorCreateGenericRGB(1.0f, 1.0f, 1.0f, 1.0f);
    containerLayer.bounds = NSRectToCGRect(frame);
    
    // ----------------------------------------------------------------------------------
    ScreenSaverDefaults *defaults = [ScreenSaverDefaults defaultsForModuleWithName:ModuleName];

    backgroundLayer = [[AnalogClockBackground alloc] initWithPath: [defaults stringForKey:GalleryPath]
                                                 WeatherRecursion: [defaults boolForKey:RecursionPath]];
    [backgroundLayer start];
    // ----------------------------------------------------------------------------------
    
    clockLayer = [CALayer layer];
    NSRect containerFrame = NSMakeRect((frame.size.width-CONTAINER_WIDTH)/2, (frame.size.height-CONTAINER_HEIGHT)/2, CONTAINER_WIDTH, CONTAINER_HEIGHT);
    clockLayer.frame = NSRectToCGRect(containerFrame);
    //clockLayer.position = NSMakePoint(CONTAINER_WIDTH/2+15.0, CONTAINER_HEIGHT/2);
    clockLayer.anchorPoint = CGPointMake(0.501, 0.5);
    
    hourHand = [CALayer layer];
    hourHand.position = CGPointMake((CONTAINER_WIDTH-HOUR_WIDTH)/2+HOUR_DRIFT, CONTAINER_HEIGHT/2);
    hourHand.anchorPoint = CGPointMake(0.5, 0.25);
    hourHand.bounds = CGRectMake(0,0, HOUR_WIDTH, HOUR_HEIGHT);
    hourHand.shadowColor = myShadowColor;
    hourHand.shadowOffset = CGSizeMake(-3.0, 3.0);
    hourHand.shadowRadius = 1.5;
    hourHand.shadowOpacity = 0.4;
    
    minHand = [CALayer layer];
    minHand.position = CGPointMake((CONTAINER_WIDTH - MIN_WIDTH)/2+MIN_DRIFT, CONTAINER_HEIGHT/2);
    minHand.anchorPoint = CGPointMake(0.5, 0.22);
    minHand.bounds = CGRectMake(0, 0, MIN_WIDTH, MIN_HEIGHT);
    minHand.shadowColor = myShadowColor;
    minHand.shadowOffset = CGSizeMake(-4.0, 4.0);
    minHand.shadowRadius = 1.5;
    minHand.shadowOpacity = 0.4;
    
    secHand = [CALayer layer];
    secHand.position = CGPointMake((CONTAINER_WIDTH-SEC_WIDTH)/2+SEC_DRIFT, CONTAINER_HEIGHT/2);
    secHand.anchorPoint = CGPointMake(0.5, 0.23);
    secHand.bounds = CGRectMake(0, 0, SEC_WIDTH, SEC_HEIGHT);
    secHand.shadowColor = myShadowColor;
    secHand.shadowOffset = CGSizeMake(-5.0, 5.0);
    secHand.shadowRadius = 1.5;
    secHand.shadowOpacity = 0.4;
    
    CGColorRelease(myShadowColor);
    
    //default appearance
    clockLayer.contents = [[NSImage alloc] initWithContentsOfFile:clock];
    hourHand.contents = [[NSImage alloc] initWithContentsOfFile:hour];
    minHand.contents = [[NSImage alloc] initWithContentsOfFile:min];
    secHand.contents = [[NSImage alloc] initWithContentsOfFile:sec];
    
    //add all created sublayers
    [clockLayer addSublayer:hourHand];
    [clockLayer addSublayer:minHand];
    [clockLayer addSublayer:secHand];
    
    [containerLayer addSublayer:backgroundLayer];
    [containerLayer addSublayer:clockLayer];
    
    if ([defaults boolForKey:EditorPanel]) {
        [self showEditorLayer];
    }
    
    [self setLayer:containerLayer];
    [self setWantsLayer:YES];
    //*/
    [self resetOriginSize];
}

- (float)degrees2Radians:(float) degrees;
{
    return degrees * M_PI / 180;
}

- (void) updateClock
{
	NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:(NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit)
                                                                       fromDate:[NSDate date]];
	NSInteger seconds = [dateComponents second];
	NSInteger minutes = [dateComponents minute];
	NSInteger hours = [dateComponents hour];
	//NSLog(@"raw: hours:%d min:%d secs:%d", hours, minutes, seconds);
	if (hours > 12) hours -=12; //PM
    
	//set angles for each of the hands
	CGFloat secAngle = [self degrees2Radians:(seconds/60.0*360+180)];
	CGFloat minAngle = [self degrees2Radians:(minutes/60.0*360+180)];
	CGFloat hourAngle = [self degrees2Radians:(hours/12.0*360+180)]+ [self degrees2Radians:(minutes/60.0*360)]/12.0;
    
    //set shadowOffset for
    secHand.shadowOffset = NSSizeToCGSize([shadowTool changeOffsetWithAngle:seconds/60.0*360 AndDepth:20]);
    minHand.shadowOffset = NSSizeToCGSize([shadowTool changeOffsetWithAngle:minutes/60.0*360 AndDepth:18]);
    hourHand.shadowOffset= NSSizeToCGSize([shadowTool changeOffsetWithAngle:(hours/12.0*360+(minutes/60.0*360)/12) AndDepth:16]);
    
	//reflect the rotations + 180 degres since CALayers coordinate system is inverted
	secHand.transform   = CATransform3DMakeRotation (M_PI-secAngle, 0, 0, 1);
	minHand.transform   = CATransform3DMakeRotation (M_PI-minAngle, 0, 0, 1);
	hourHand.transform  = CATransform3DMakeRotation (M_PI-hourAngle, 0, 0, 1);
}

- (void)recaculateOriginSizeByFrame:(NSRect)frame
{
    if (frame.size.width < CONTAINER_WIDTH || frame.size.height < CONTAINER_HEIGHT) {
        float widthRatio  = frame.size.width/CONTAINER_WIDTH;
        float heightRatio = frame.size.height/CONTAINER_HEIGHT;
        float ratio = widthRatio > heightRatio ? heightRatio : widthRatio;
        
        CONTAINER_WIDTH *= ratio;
        CONTAINER_HEIGHT *= ratio;

        HOUR_WIDTH *= ratio;
        HOUR_HEIGHT *= ratio;
        HOUR_DRIFT  *= ratio;
        
        MIN_WIDTH *= ratio;
        MIN_HEIGHT *= ratio;
        MIN_DRIFT *= ratio;
        
        SEC_WIDTH  *= ratio;
        SEC_HEIGHT  *= ratio;
        SEC_DRIFT *= ratio;

    }
}

- (void)resetOriginSize
{
    CONTAINER_WIDTH = 877.0;
    CONTAINER_HEIGHT = 877.0;
    
    HOUR_WIDTH = 22.0;
    HOUR_HEIGHT = 330.0;
    HOUR_DRIFT = 17.0;
    HOUR_WEI = 90.0;
    
    MIN_WIDTH = 21.0;
    MIN_HEIGHT = 403.0;
    MIN_DRIFT = 16.0;
    MIN_WEI  = 90.0;
    
    SEC_WIDTH  = 33.0;
    SEC_HEIGHT  = 355.0;
    SEC_DRIFT  = 22.0;
    SEC_WEI  = 81.0;

}

- (void) showEditorLayer
{
    editorLayer = [CALayer layer];
    NSSize screenSize = [NSScreen mainScreen].frame.size;
    editorLayer.frame = CGRectMake(screenSize.width - 210, screenSize.height - 59, 200, 49);
    editorLayer.backgroundColor = CGColorCreateGenericRGB(1.0f, 1.0f, 1.0f, 1.0f);
    editorLayer.opacity = 0.9f;
    editorLayer.shadowColor = CGColorCreateGenericRGB(0.0f, 0.0f, 0.0f, 1.0f);
    editorLayer.shadowOffset = CGSizeMake(3.0, -3.0);
    editorLayer.shadowRadius = 1.5;
    editorLayer.shadowOpacity = 0.4;
    editorLayer.cornerRadius = 2.0f;
    
    CABasicAnimation *fadeout = [BasicAnimationFatory fadeOutAnimationDuration:2.0f BeginTime:10.0f];
    [editorLayer addAnimation:fadeout forKey:@"hideeditorpanel"];
    
    CALayer *avatarLayer = [CALayer layer];
    avatarLayer.frame = CGRectMake(2, 2, 45, 45);
    NSString *avatar  = [bundle pathForResource:@"avatar_64" ofType:@"jpg"];
    avatarLayer.contents = [[NSImage alloc] initWithContentsOfFile:avatar];
    avatarLayer.cornerRadius = 1.5f;
    
    CALayer *socialLayer = [CALayer layer];
    socialLayer.frame = CGRectMake(52, 0, 85, 25);
    NSString *social  = [bundle pathForResource:@"social" ofType:@"png"];
    socialLayer.contents = [[NSImage alloc] initWithContentsOfFile:social];

    
    CATextLayer *accountLayer = [CATextLayer layer];
    [accountLayer setString:Account];
    [accountLayer setFontSize:14.0f];
    accountLayer.foregroundColor = CGColorCreateGenericRGB(0.0f, 0.0f, 0.0f, 1.0f);
    accountLayer.shadowColor = CGColorCreateGenericRGB(0.0f, 0.0f, 0.0f, 1.0f);
    accountLayer.shadowOffset = CGSizeMake(0.5, -0.5);
    accountLayer.shadowRadius = 0.5;
    accountLayer.shadowOpacity = 0.4;
    accountLayer.frame = CGRectMake(59, 24, 170, 18);
    
    [editorLayer addSublayer:avatarLayer];
    [editorLayer addSublayer:socialLayer];
    [editorLayer addSublayer:accountLayer];
    [containerLayer addSublayer:editorLayer];
}

// 路径选择，并根据判断设置存储路径
-(IBAction)selectedPath:(id)sender
{
    NSOpenPanel *pathSelector = [NSOpenPanel openPanel];
    [pathSelector setCanChooseFiles:FALSE];
    [pathSelector setCanChooseDirectories:TRUE];
    [pathSelector setCanCreateDirectories:TRUE];
    [pathSelector setAllowsMultipleSelection:FALSE];
    [pathSelector setDirectoryURL:[NSURL fileURLWithPath:NSHomeDirectory()]];
    
    [pathSelector setTitle:NSLocalizedString(@"func_dir", nil)];
    NSInteger i = [pathSelector runModal];
    
    if(i == NSOKButton)
    {
        NSURL *theFilePath = [[pathSelector URLs] objectAtIndex:0];
        [urlField setStringValue:[theFilePath path]];
    }
}

- (IBAction)cancelClick:(id)sender
{
	[[NSApplication sharedApplication] endSheet:configureSheet];
}

- (IBAction)okClick:(id)sender
{
	ScreenSaverDefaults *defaults = [ScreenSaverDefaults defaultsForModuleWithName:ModuleName];
    
    NSInteger r = [selfPathRadios selectedRow];
    if(r == 1 && ![[urlField stringValue] isEqualToString:@""])
    {
        [defaults setValue:[urlField stringValue] forKey:GalleryPath];
    }
    else
    {
        [defaults setValue:DefaultPath forKey:GalleryPath];
    }
    [defaults setBool:[recursionChecker state] forKey:RecursionPath];
	[defaults setBool:[editorPanelChecker state] forKey:EditorPanel];
	[defaults synchronize];
    
    [self cancelClick:nil];
}

@end
