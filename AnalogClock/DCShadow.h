//
//  DCShadow.h
//  desktopclocklit
//
//  Created by cod7ce on 12/12/11.
//  Copyright (c) 2011 纸房子. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DCShadow : NSObject
{
    float modulus;
}

@property (nonatomic) NSSize offset;

-(NSSize)changeOffsetWithAngle:(float)angle AndDepth:(int)depth;

@end
