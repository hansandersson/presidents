//
//  CorpusView.m
//  Corpora Compare
//
//  Created by Hans Andersson on 11/04/18.
//  Copyright 2011 Ultramentem. All rights reserved.
//

#import "CorpusView.h"

@class President;

@implementation CorpusView

- (NSSize)area
{
	return NSMakeSize([self bounds].size.width-48.0, [self bounds].size.height-48.0);
}

- (NSPoint)center
{
	NSSize area = [self area];
	return NSMakePoint([self bounds].origin.x + 0.5*area.width,
					   [self bounds].origin.y + 0.5*area.height);
}

- (void)addPresident:(President *)president
{
	if (!presidents) presidents = [NSMutableArray array];
	NSPoint center = [self center];
	NSPoint _center = NSMakePoint(center.x - 24.0, center.y - 24.0);
	[[president view] removeFromSuperview];
	[[president view] setFrameOrigin:_center];
	[self addSubview:[president view]];
	[presidents addObject:president];
	[self positionPresidents];
}

- (void)positionPresidents
{
	NSSize area = [self area];
	NSPoint center = [self center];
	for (NSUInteger p = 0; p < [presidents count]; p++)
	{
		double angle = (double)(p)*(2.0*M_PI)/(double)([presidents count]);
		NSPoint origin = NSMakePoint(center.x + (0.5 * area.width * sin(angle)),
									 center.y + (0.5 * area.height * cos(angle)));
		
		[[[(President *)[presidents objectAtIndex:p] view] animator] setFrameOrigin:origin];
	}
}

- (void)resizeSubviewsWithOldSize:(NSSize)oldSize
{
	[super resizeSubviewsWithOldSize:oldSize];
	[self positionPresidents];
}

/*
- (void)drawRect:(NSRect)dirtyRect
{
    // Drawing code here.
}
*/

@end
