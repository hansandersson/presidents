//
//  Speech.h
//  Corpora Compare
//
//  Created by Hans Andersson on 11/04/18.
//  Copyright 2011 Ultramentem. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Speech : NSObject {
@private
    NSDate *date;
	NSDictionary *wordContexts;
}

@property (readonly, copy) NSDictionary *wordContexts;

- (id)initWithFileName:(NSString *)fileName;

@end
