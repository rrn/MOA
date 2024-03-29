//
//  EmailHandler.h
//  MOA
//
//  Created by Diana Sutandie on 2014-03-08.
//  Copyright (c) 2014 Museum of Anthropology UBC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EmailHandler : NSObject

@property NSMutableString* emailSubject;
@property NSMutableString* emailBody;
@property NSMutableString* emailRecipient;
@property NSMutableArray* emailArray;

-(MFMailComposeViewController*) composeEmail:(int)code;

@end
