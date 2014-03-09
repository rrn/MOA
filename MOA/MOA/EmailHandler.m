//
//  EmailHandler.m
//  MOA
//
//  Created by Diana Sutandie on 2014-03-08.
//  Copyright (c) 2014 Museum of Anthropology UBC. All rights reserved.
//

#import "Utils.h"
#import "CrudOp.h"
#import "Global.h"
#import "EmailHandler.h"

@implementation EmailHandler

@synthesize emailBody, emailRecipient, emailSubject;

-(MFMailComposeViewController*) composeEmail:(int) code
{
    MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
    
    if (code == 0) {
        // 0 is for tell a friend
        [self PullFromRemote_TellAFriend];
        
    } else if (code == 1) {
        // 1 is for send feedback
    }
    
    [controller setSubject:emailSubject];
    [controller setMessageBody:emailBody isHTML:NO];
    return controller;
    
}



- (void) PullFromRemote_TellAFriend
{
    NSDictionary* jsonDict = [Utils PullRemoteData:@"http://pluto.moa.ubc.ca/_mobile_app_remoteData.php"];
    NSMutableArray* emailArray = [jsonDict objectForKey:@"tell_a_friend"];
    emailSubject = [[emailArray objectAtIndex:0] objectForKey:@"Subject"];
    emailBody = [[emailArray objectAtIndex:0] objectForKey:@"Message"];

}



@end
