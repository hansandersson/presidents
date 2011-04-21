//
//  CorpusView.m
//  Corpora Compare
//
//  Created by Hans Andersson on 11/04/18.
//  Copyright 2011 Ultramentem. All rights reserved.
//

#import "CorpusView.h"
#import "President.h"
#import "ChartView.h"

@implementation CorpusView

- (IBAction)select:(id)sender
{
	if (selection == sender)
	{
		selection = nil;
		[chartView setRepresentedObject:(id <PresidentialSpeechStatisticsProtocol>)[[NSApplication sharedApplication] delegate]];
	}
	else
	{
		selection = sender;
		highlight = nil;
		[chartView setRepresentedObject:(id <PresidentialSpeechStatisticsProtocol>)sender];
	}
	[self positionPresidents];
}

- (void)mouseMoved:(NSEvent *)theEvent
{
	[super mouseMoved:theEvent];
	if (selection) return;
	for (President *president in presidents)
	{
		if (CGRectContainsPoint(CGRectMake([[president view] frame].origin.x, [[president view] frame].origin.y, [[president view] frame].size.width, [[president view] frame].size.height), CGPointMake([theEvent locationInWindow].x, [theEvent locationInWindow].y)))
		{
			if (highlight != president)
			{
				highlight = president;
				[chartView setComparedObject:highlight];
				[self setNeedsDisplay:YES];
			}
			return;
		}
	}
	highlight = nil;
	[chartView setComparedObject:(id<PresidentialSpeechStatisticsProtocol>)[[NSApplication sharedApplication] delegate]];
	[self setNeedsDisplay:YES];
}

- (NSSize)area
{
	return NSMakeSize([self bounds].size.width - 32.0, [self bounds].size.height - 32.0);
}

- (NSPoint)center
{
	NSSize area = [self area];
	return NSMakePoint([self bounds].origin.x + 0.5 * area.width,
					   [self bounds].origin.y + area.height - 12);
}

- (void)addPresident:(President *)president
{
	if (!presidents) presidents = [NSMutableArray array];
	if (!similarities) similarities = [NSDictionary dictionary];
	NSPoint center = [self center];
	NSPoint _center = NSMakePoint(center.x - [[president view] frame].size.width/2, center.y - [[president view] frame].size.height/2);
	[[president view] removeFromSuperview];
	[[president view] setFrameOrigin:_center];
	[self addSubview:[president view]];
	
	[[president view] setPostsFrameChangedNotifications:YES];
	[(NSNotificationCenter *)[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(subviewFrameDidChange) name:NSViewFrameDidChangeNotification object:[president view]];
	
	[presidents addObject:president];
	
	[president setTarget:self];
	[president setAction:@selector(select:)];
	
	NSMutableDictionary *similaritiesWorking = [NSMutableDictionary dictionaryWithDictionary:similarities];
	for (President *otherPresident in presidents)
	{
		NSDecimalNumber *pairSimilarity = [president computedSimilarityTo:otherPresident];
		[similaritiesWorking setValue:pairSimilarity forKey:[[otherPresident name] stringByAppendingFormat:@"–%@", [president name]]];
		[similaritiesWorking setValue:pairSimilarity forKey:[[president name] stringByAppendingFormat:@"–%@", [otherPresident name]]];
		if (!maximumSimilarity || [pairSimilarity compare:maximumSimilarity]==NSOrderedDescending) maximumSimilarity = pairSimilarity;
		if (!minimumSimilarity || [pairSimilarity compare:minimumSimilarity]==NSOrderedAscending) minimumSimilarity = pairSimilarity;
	}
	similarities = [NSDictionary dictionaryWithDictionary:similaritiesWorking];
	[self positionPresidents];
}

- (void)positionPresidents
{
	NSSize area = [self area];
	NSPoint center = [self center];
	for (NSUInteger p = 0; p < [presidents count]; p++)
	{
		President *president = (President *)[presidents objectAtIndex:p];
		NSRect destination;
		if (president == selection)
		{
			destination = NSMakeRect([self center].x - 32, [self center].y - 32, 64, 64);
		}
		else
		{
			double angle = M_PI_2 + (double)(p)*M_PI/(double)([presidents count]);
			destination = NSMakeRect(center.x + (0.5 * area.width * sin(angle)),
									 center.y + ((area.height - 24) * cos(angle)), 32, 32);
		}
		[[[president view] animator] setFrame:destination];
	}
}

- (void)resizeSubviewsWithOldSize:(NSSize)oldSize
{
	[super resizeSubviewsWithOldSize:oldSize];
	[self positionPresidents];
}

- (void)subviewFrameDidChange
{
	[self setNeedsDisplay:YES];
}

- (void)drawRect:(NSRect)dirtyRect
{
	[super drawRect:dirtyRect];
	
	President *reference = highlight ? highlight : selection;
	
	if (!reference)
	{
		[labelField setStringValue:@""];
		return;
	}
	
	[labelField setTextColor:[reference color]];
	CGColorRef referencePartyColorRef = CGColorCreateGenericRGB([[reference color] redComponent], [[reference color] greenComponent], [[reference color] blueComponent], [[reference color] alphaComponent]);
	[[labelField layer] setShadowColor:referencePartyColorRef];
	CGColorRelease(referencePartyColorRef);
	[labelField setStringValue:[reference name]];
	
	for (President *president in presidents)
	{
		if (president != reference)
		{
			NSPoint start = [reference viewCenter];
			NSPoint end = [president viewCenter];
			
			NSBezierPath *arc = [[NSBezierPath alloc] init];
			[arc moveToPoint:start];
			[arc curveToPoint:end controlPoint1:[self center] controlPoint2:[self center]];
			
			NSDecimalNumber *pairSimilarity = [similarities valueForKey:[[reference name] stringByAppendingFormat:@"–%@", [president name]]];
			
			pairSimilarity = [[pairSimilarity decimalNumberBySubtracting:minimumSimilarity]
							  decimalNumberByDividingBy:
							  [maximumSimilarity decimalNumberBySubtracting:minimumSimilarity]];
			
			[[[president color] colorWithAlphaComponent:[pairSimilarity doubleValue]] setStroke];
			[arc setLineWidth:2.0 * [pairSimilarity doubleValue]];
			[arc stroke];
			
			if ([[president color] isEqualTo:[reference color]]) [self shadow:president];
		}
	}
	
	[self shadow:reference];
}

- (void)shadow:(President *)president
{
	NSShadow *shadow = [[NSShadow alloc] init];
	[shadow setShadowBlurRadius:12.0];
	[shadow setShadowOffset:CGSizeMake(0.0, 0.0)];
	[shadow setShadowColor:[president color]];
	[shadow set];
	[[president color] setFill];
	[[president color] setStroke];
	NSBezierPath *halo = [NSBezierPath bezierPathWithRect:[[president view] frame]];
	[halo fill];
	[halo stroke];
	[[[NSShadow alloc] init] set];
	[[NSColor clearColor] setFill];
}


@end
