//
//  CorpusView.m
//  Corpora Compare
//
//  Created by Hans Andersson on 11/04/18.
//  Copyright 2011 Ultramentem. All rights reserved.
//

#import "CorpusView.h"
#import "President.h"
#import "Corpora_CompareAppDelegate.h"

@implementation CorpusView

- (IBAction)select:(id)sender
{
	if (selection == sender) selection = nil;
	else
	{
		selection = sender;
		highlight = nil;
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
				[self setNeedsDisplay:YES];
			}
			return;
		}
	}
	if (highlight) [self setNeedsDisplay:YES];
	highlight = nil;
}

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
	if (!similarities) similarities = [NSDictionary dictionary];
	NSPoint center = [self center];
	NSPoint _center = NSMakePoint(center.x - 24.0, center.y - 24.0);
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
		NSPoint destination;
		if (president == selection) destination = NSMakePoint([self center].x - 24.0, [self center].y - 24.0);
		else
		{
			double angle = M_PI_2 + (double)(p)*M_PI/(double)([presidents count]);
			destination = NSMakePoint(center.x + (0.5 * area.width * sin(angle)),
									 center.y + (0.5 * area.height * cos(angle)));
		}
		[[[president view] animator] setFrameOrigin:destination];
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
	
	[[NSColor blackColor] setFill];
	[[NSBezierPath bezierPathWithRect:[self bounds]] fill];
	
	President *reference = highlight ? highlight : selection;
	
	NSString *referencePartyName = [[(Corpora_CompareAppDelegate *)[[NSApplication sharedApplication] delegate] presidentParties] valueForKey:[reference name]];
	
	if (reference) for (President *president in presidents)
	{
		NSColor *presidentPartyColor = [[(Corpora_CompareAppDelegate *)[[NSApplication sharedApplication] delegate] partyColors] valueForKey:[[(Corpora_CompareAppDelegate *)[[NSApplication sharedApplication] delegate] presidentParties] valueForKey:[president name]]];
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
			
			[[presidentPartyColor colorWithAlphaComponent:[pairSimilarity doubleValue]] setStroke];
			[arc setLineWidth:2.0 * [pairSimilarity doubleValue]];
			[arc stroke];
		}
		
		if ([presidentPartyColor isEqualTo:[[(Corpora_CompareAppDelegate *)[[NSApplication sharedApplication] delegate] partyColors] valueForKey:referencePartyName]])
		{
			NSShadow *shadow = [[NSShadow alloc] init];
			[shadow setShadowBlurRadius:12.0];
			[shadow setShadowOffset:CGSizeMake(0.0, 0.0)];
			[shadow setShadowColor:presidentPartyColor];
			[shadow set];
			[presidentPartyColor setFill];
			[presidentPartyColor setStroke];
			NSBezierPath *halo = [NSBezierPath bezierPathWithRect:[[president view] frame]];
			[halo fill];
			[halo stroke];
			[[[NSShadow alloc] init] set];
			[[NSColor clearColor] setFill];
		}
	}
}


@end
