//
//  ChartView.m
//  Corpora Compare
//
//  Created by Hans Andersson on 11/04/20.
//  Copyright 2011 Ultramentem. All rights reserved.
//

#import "ChartView.h"
#import "CorpusView.h"

@implementation ChartView

@synthesize barSpacing;
@synthesize representedObject;
@synthesize comparedObject;
@synthesize barsCount;
@synthesize barsOffset;
@synthesize searchWord;

- (void)setBarsOffset:(NSUInteger)newBarsOffset
{
	barsOffset = newBarsOffset;
	[self setNeedsDisplay:YES]; 
}

- (IBAction)incrementBarsCount:(id)sender
{
	(void)sender;
	barsCount += 1;
	[self setNeedsDisplay:YES];
}

- (IBAction)decrementBarsCount:(id)sender
{
	(void)sender;
	if (barsCount == 1) return;
	barsCount -= 1;
	[self setNeedsDisplay:YES];
}

- (IBAction)incrementBarsOffset:(id)sender
{
	//[self setSearchWord:nil];
	(void)sender;
	barsOffset += 1;
	[self setNeedsDisplay:YES];
}

- (IBAction)decrementBarsOffset:(id)sender
{
	//[self setSearchWord:nil];
	(void)sender;
	if (!barsOffset) return;
	barsOffset -= 1;
	[self setNeedsDisplay:YES];
}

- (IBAction)update:(id)sender
{
	(void)sender;
	[self setNeedsDisplay:YES];
}

- (IBAction)takeStringValueFromSender:(id)sender
{
	[self setSearchWord:[sender stringValue]];
}

- (void)setSearchWord:(NSString *)newSearchWord
{
	NSInteger searchWordIndex = NSNotFound;
	if (newSearchWord)
	{
		for (NSString *word in [self filteredWordsByFrequency])
		{
			if ([word isEqualToString:newSearchWord])
			{
				searchWordIndex = [[self filteredWordsByFrequency] indexOfObject:word];
				break;
			}
		}
	}
	searchWord = newSearchWord;
	if (searchWordIndex != NSNotFound) [self setBarsOffset:searchWordIndex];
	else if (!searchWord || [searchWord isEqualToString:@""])
	{
		searchWord = nil;
		[searchField setStringValue:@""];
		[self setBarsOffset:0];
	}
	[[self window] makeFirstResponder:[self superview]];
}

- (void)setRepresentedObject:(id<PresidentialSpeechStatisticsProtocol>)newRepresentedObject
{
	representedObject = newRepresentedObject;
	[self setSearchWord:searchWord];
	[self setNeedsDisplay:YES];
}

- (void)setComparedObject:(id<PresidentialSpeechStatisticsProtocol>)newComparedObject
{
	comparedObject = newComparedObject;
	[self setNeedsDisplay:YES];
}

- (NSSize)segmentSize
{
	return NSMakeSize((double)([self bounds].size.width) / (double)barsCount, [self bounds].size.height);
}

- (void)drawRect:(NSRect)dirtyRect
{
    (void)dirtyRect;
	
	[super drawRect:dirtyRect];
	
	if (!representedObject) return;
	
	NSSize segmentSize = [self segmentSize];
	
	[[representedObject color] setFill];
	
	NSMutableDictionary *nameDrawAttributes = [NSMutableDictionary dictionary];
	[nameDrawAttributes setValue:[representedObject color] forKey:NSForegroundColorAttributeName];
	NSShadow *stringShadow = [[NSShadow alloc] init];
	[stringShadow setShadowColor:[NSColor blackColor]];
	[stringShadow setShadowOffset:NSMakeSize(0, 0)];
	[stringShadow setShadowBlurRadius:4];
	[nameDrawAttributes setValue:stringShadow forKey:NSShadowAttributeName];
	
	[nameDrawAttributes setValue:[NSFont fontWithName:@"Goudy Old Style" size:48.0] forKey:NSFontAttributeName];
	for (double size_2 = 96.0; [[NSString stringWithString:@" "] sizeWithAttributes:nameDrawAttributes].height > segmentSize.width - barSpacing; [nameDrawAttributes setValue:[NSFont fontWithName:@"Goudy Old Style" size:(--size_2)/2.0] forKey:NSFontAttributeName]);
	
	NSMutableDictionary *qDrawAttributes = [NSMutableDictionary dictionary];
	[qDrawAttributes setValue:[NSColor blackColor] forKey:NSForegroundColorAttributeName];
	NSShadow *qShadow = [[NSShadow alloc] init];
	[qShadow setShadowColor:[representedObject color]];
	[qShadow setShadowOffset:NSMakeSize(0.0, 0.0)];
	[qShadow setShadowBlurRadius:2];
	[qDrawAttributes setValue:qShadow forKey:NSShadowAttributeName];
	
	[qDrawAttributes setValue:[NSFont fontWithName:@"Goudy Old Style" size:48.0] forKey:NSFontAttributeName];
	for (double size_2 = 96.0; [[NSString stringWithString:@"100"] sizeWithAttributes:qDrawAttributes].width > segmentSize.width - 3*barSpacing; [qDrawAttributes setValue:[NSFont fontWithName:@"Goudy Old Style" size:(--size_2)/2.0] forKey:NSFontAttributeName]);
	
	NSArray *filteredWordsByFrequency = [self filteredWordsByFrequency];
	
	NSMutableArray *comparisonWordsFilteredByFrequency;
	if (comparedObject)
	{
		comparisonWordsFilteredByFrequency = [NSMutableArray arrayWithArray:[comparedObject wordsByFrequency]];
		[comparisonWordsFilteredByFrequency removeObjectsInArray:exclusions];
	}
	
	for (NSUInteger b = 0; b < barsCount && b < [filteredWordsByFrequency count]; b++)
	{
		NSString *word = [filteredWordsByFrequency objectAtIndex:(b + barsOffset)];
		double relativeFrequency = (double)[(NSArray *)[[representedObject wordContexts] valueForKey:word] count] / (double)[(NSArray *)[[representedObject wordContexts] valueForKey:[filteredWordsByFrequency objectAtIndex:0]] count];
		[[NSBezierPath bezierPathWithRect:NSMakeRect(b * segmentSize.width, 0, segmentSize.width - barSpacing,  relativeFrequency * segmentSize.height)] fill];
		
		if (comparedObject && [[comparedObject wordContexts] valueForKey:word])
		{
			double comparativeFrequency = (double)[(NSArray *)[[comparedObject wordContexts] valueForKey:word] count] / (double)[(NSArray *)[[comparedObject wordContexts] valueForKey:[comparisonWordsFilteredByFrequency objectAtIndex:0]] count];
			
			if (comparativeFrequency < relativeFrequency && [[representedObject color] isEqualTo:[comparedObject color]]) [[NSColor blackColor] setStroke];
			else [[comparedObject color] setStroke];
			
			NSBezierPath *comparisonLine = [[NSBezierPath alloc] init];
			[comparisonLine moveToPoint:NSMakePoint(b * segmentSize.width, comparativeFrequency * segmentSize.height)];
			[comparisonLine lineToPoint:NSMakePoint((b+1) * segmentSize.width - barSpacing, comparativeFrequency * segmentSize.height)];
			[comparisonLine stroke];
		}
		
		NSString *q = [NSString stringWithFormat:@"%i", (int)(relativeFrequency*100)];
		[q drawAtPoint:NSMakePoint((b+1)*segmentSize.width - (2.0*barSpacing) - [q sizeWithAttributes:qDrawAttributes].width, 0.0) withAttributes:qDrawAttributes];
		
		NSAffineTransform *transform = [NSAffineTransform transform];
		[transform translateXBy:((b + 1) * segmentSize.width) - barSpacing yBy:segmentSize.height - [word sizeWithAttributes:nameDrawAttributes].width];
		[transform rotateByDegrees:90];
		[transform concat];
		[word drawAtPoint:NSMakePoint(0, 0) withAttributes:nameDrawAttributes];
		[transform invert];
		[transform concat];
	}
}

- (BOOL)resignFirstResponder
{
	BOOL willResign = [super resignFirstResponder];
	if (willResign) [corpusView setFocusWord:nil];
	return willResign;
}

- (NSArray *)filteredWordsByFrequency
{
	NSMutableArray *filteredWordsByFrequency = [NSMutableArray arrayWithArray:[representedObject wordsByFrequency]];
	[filteredWordsByFrequency removeObjectsInArray:exclusions];
	return filteredWordsByFrequency;
}

/*- (void)mouseMoved:(NSEvent *)theEvent
{
	[super mouseMoved:theEvent];
	NSPoint locationInSelf = [self convertPoint:[theEvent locationInWindow] fromView:[[theEvent window] contentView]];
	NSInteger column = (NSInteger) (locationInSelf.x / [self segmentSize].width);
	if (column < 0) return;
	[corpusView setFocusWord:[[self filteredWordsByFrequency] objectAtIndex:column]];
}*/

- (void)mouseDown:(NSEvent *)theEvent
{
	[super mouseDown:theEvent];
	clickedB = (NSInteger) ([self convertPointFromBase:[theEvent locationInWindow]].x / [self segmentSize].width);
}

- (void)mouseUp:(NSEvent *)theEvent
{
	[super mouseUp:theEvent];
	NSInteger unclickedB = (NSInteger) ([self convertPointFromBase:[theEvent locationInWindow]].x / [self segmentSize].width);
	if (clickedB == unclickedB && !(clickedB < 0) && !(unclickedB < 0) && barsOffset+clickedB < [[self filteredWordsByFrequency] count])
	{
		if (!exclusions) exclusions = [NSMutableArray array];
		[exclusions addObject:[[self filteredWordsByFrequency] objectAtIndex:barsOffset+clickedB]];
		[exclusionsTableView reloadData];
		[self setNeedsDisplay:YES];
	}
	clickedB = -1;
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
	if (!exclusions) exclusions = [NSMutableArray array];
	(void)tableView;
	return [exclusions count];
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
	if (!exclusions) exclusions = [NSMutableArray array];
	(void)tableView;
	(void)tableColumn;
	return [exclusions objectAtIndex:row];
}

- (IBAction)removeAllExclusions:(id)sender
{
	if (!exclusions) exclusions = [NSMutableArray array];
	(void)sender;
	[exclusions removeAllObjects];
	[exclusionsTableView reloadData];
	[self setNeedsDisplay:YES];
}

- (IBAction)removeSelectedExclusion:(id)sender
{
	if (!exclusions) exclusions = [NSMutableArray array];
	(void)sender;
	[exclusions removeObjectAtIndex:[exclusionsTableView selectedRow]];
	[exclusionsTableView reloadData];
	[self setNeedsDisplay:YES];
}

@end
