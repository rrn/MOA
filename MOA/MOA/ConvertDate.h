//
//  ConvertDate.h
//  MOA
//
//  Created by Marilyn Edgar on 2/6/2014.
//  Copyright (c) 2014 Museum of Anthropology UBC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConvertDate : NSObject

+ (ConvertDate *)sharedInstance;

+(NSString*)convertDate;
+(NSString*)convertMonthToString;

@end
