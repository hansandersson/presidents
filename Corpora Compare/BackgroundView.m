//
//  BackgroundView.m
//  Corpora Compare
//
//  Created by Hans Andersson on 11/04/20.
//  Copyright 2011 Ultramentem. All rights reserved.
//

#import "BackgroundView.h"


@implementation BackgroundView

- (void)drawRect:(NSRect)dirtyRect
{
    [[NSColor blackColor] setFill];
	[[NSBezierPath bezierPathWithRect:dirtyRect] fill];
}

@end
