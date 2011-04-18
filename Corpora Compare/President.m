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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)loadSpeeches:(NSArray *)speechPaths
{
	/*NSString *directory = [NSString stringWithFormat:@"Presidents/%@", newName];
	
	[self willChangeValueForKey:@"name"];
	name = [newName copy];
	[self didChangeValueForKey:@"name"];
	
	[self setPortrait:[[NSImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"portrait" ofType:@"png" inDirectory:directory]]];*/
	
	NSMutableArray *speechesWorking = [NSMutableArray arrayWithCapacity:[speechPaths count]];
	for (NSString *speechPath in speechPaths)
	{
		NSLog(@"\t%@", speechPath);
		[speechesWorking addObject:[[Speech alloc] initWithFileName:speechPath]];
	}
	speeches = [NSArray arrayWithArray:speechesWorking];
}

- (void)loadName:(NSString *)newName
{
	[self willChangeValueForKey:@"name"];
	name = [newName copy];
	[self didChangeValueForKey:@"name"];
	
	[self setPortrait:[[NSImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForImageResource:newName]]];
}

- (void)dealloc
{
    [super dealloc];
}

@end
