//
//  PresidentialSpeechStatisticsProtocol.h
//  Corpora Compare
//
//  Created by Hans Andersson on 11/04/20.
//  Copyright 2011 Ultramentem. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol PresidentialSpeechStatisticsProtocol <NSObject>

@property (readonly) NSDictionary *wordContexts;
@property (readonly) NSArray *wordsByFrequency;
@property (readonly) NSDecimalNumber *wordsCount;
@property (readwrite, copy) NSColor *color;

@end
