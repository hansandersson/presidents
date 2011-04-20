//
//  President.m
//  Corpora Compare
//
//  Created by Hans Andersson on 11/04/18.
//  Copyright 2011 Ultramentem. All rights reserved.
//

#import "President.h"
#import "Speech.h"

@implementation President

@synthesize name;
@synthesize portrait;
@synthesize wordContexts;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        speeches = [NSArray array];
		wordContexts = [NSDictionary dictionary];
    }
    
    return self;
}

- (NSPoint)viewCenter
{
	return NSMakePoint([[self view] frame].origin.x + [[self view] frame].size.width/2,
					   [[self view] frame].origin.y + [[self view] frame].size.height/2);
}

- (void)loadSpeeches:(NSArray *)speechPaths
{
	/*NSString *directory = [NSString stringWithFormat:@"Presidents/%@", newName];
	
	[self willChangeValueForKey:@"name"];
	name = [newName copy];
	[self didChangeValueForKey:@"name"];
	
	[self setPortrait:[[NSImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"portrait" ofType:@"png" inDirectory:directory]]];*/
	
	NSMutableDictionary *wordContextsWorking = [NSMutableDictionary dictionaryWithDictionary:wordContexts];
	NSMutableArray *speechesWorking = [NSMutableArray arrayWithArray:speeches];
	for (NSString *speechPath in speechPaths)
	{
		NSLog(@"\t%@", speechPath);
		Speech *newSpeech = [[Speech alloc] initWithFileName:speechPath];
		[speechesWorking addObject:newSpeech];
		
		for (NSString *word in [[newSpeech wordContexts] allKeys])
		{
			if (![wordContextsWorking valueForKey:word]) [wordContextsWorking setValue:[NSMutableArray array] forKey:word];
			[(NSMutableArray *)[wordContextsWorking valueForKey:word] addObjectsFromArray:[[newSpeech wordContexts] valueForKey:word]];
		}
	}
	wordContexts = [NSDictionary dictionaryWithDictionary:wordContextsWorking];
	speeches = [NSArray arrayWithArray:speechesWorking];
}

- (void)loadName:(NSString *)newName
{
	[self willChangeValueForKey:@"name"];
	name = [newName copy];
	[self didChangeValueForKey:@"name"];
	
	[self setPortrait:[[NSImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForImageResource:newName]]];
}

- (NSDecimalNumber *)computedSimilarityTo:(President *)otherPresident
{
	NSDictionary *myWordContexts = wordContexts;
	NSDictionary *otherWordContexts = [otherPresident wordContexts];
	
	NSDecimalNumber *sharedWords = [NSDecimalNumber zero];
	
	NSDecimalNumber *myWordsCount = [NSDecimalNumber zero];
	for (NSString *word in [myWordContexts allKeys])
	{
		NSInteger myCount = [(NSArray *)[myWordContexts valueForKey:word] count];
		if ([otherWordContexts valueForKey:word])
		{
			NSInteger otherCount = [(NSArray *)[otherWordContexts valueForKey:word] count];
			sharedWords = [sharedWords decimalNumberByAdding:[NSDecimalNumber decimalNumberWithMantissa:myCount<otherCount?myCount:otherCount exponent:0 isNegative:NO]];
		}
		myWordsCount = [myWordsCount decimalNumberByAdding:[NSDecimalNumber decimalNumberWithMantissa:myCount exponent:0 isNegative:NO]];
	}
	
	NSDecimalNumber *otherWordsCount = [NSDecimalNumber zero];
	for (NSString *word in [otherWordContexts allKeys])
	{
		NSInteger otherCount = [(NSArray *)[otherWordContexts valueForKey:word] count];
		if ([myWordContexts valueForKey:word])
		{
			NSInteger myCount = [(NSArray *)[myWordContexts valueForKey:word] count];
			sharedWords = [sharedWords decimalNumberByAdding:[NSDecimalNumber decimalNumberWithMantissa:myCount<otherCount?myCount:otherCount exponent:0 isNegative:NO]];
		}
		otherWordsCount = [otherWordsCount decimalNumberByAdding:[NSDecimalNumber decimalNumberWithMantissa:otherCount exponent:0 isNegative:NO]];
	}
	
	return [sharedWords decimalNumberByDividingBy:[myWordsCount decimalNumberByAdding:otherWordsCount]];
}

- (void)setTarget:(id)target
{
	[portraitButton setTarget:target];
}

- (void)setAction:(SEL)action
{
	[portraitButton setAction:action];
}

- (void)dealloc
{
    [super dealloc];
}

@end
