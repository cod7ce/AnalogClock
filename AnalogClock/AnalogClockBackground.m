//
//  AnalogClockBackground.m
//  desktopclocklit
//
//  Created by cod7ce on 12/13/11.
//  Copyright (c) 2011 纸房子. All rights reserved.
//

#import "AnalogClockBackground.h"

@implementation AnalogClockBackground

- (id)initWithFrame:(NSRect)frame 
{
    if (self = [super initWithFrame:frame]) 
    {
        customBackgroundColour = [NSColor colorWithPatternImage:[NSImage imageNamed:@"timebg2.jpg"]];
        NSLog(@"nihao drawRect: %@",customBackgroundColour);
    }
    return self;
}

// DRAW
- (void)drawRect:(NSRect)dirtyRect 
{
    // Draw the background
    //NSGraphicsContext* theContext = [NSGraphicsContext currentContext];
    //[theContext saveGraphicsState];
    //[[NSGraphicsContext currentContext] setPatternPhase:NSMakePoint(0,[self frame].size.height)];
    [customBackgroundColour set];
    NSRectFill([self bounds]);
    //[theContext restoreGraphicsState];
    NSLog(@"nihao drawRect: %@",customBackgroundColour);
}

@end
