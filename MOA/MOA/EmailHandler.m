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
#import "Reachability.h"
#import <MessageUI/MFMailComposeViewController.h>
#import "EmailHandler.h"

@implementation EmailHandler

@synthesize emailBody, emailRecipient, emailSubject;

-(MFMailComposeViewController*) composeEmail:(int) code
{
    MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
    
    Reachability *reachability = [Reachability reachabilityWithHostname:@"www.google.ca"];
    NetworkStatus internetStatus = [reachability currentReachabilityStatus];
    if(internetStatus == NotReachable) {
        [self LoadFromDB:code];
    } else {
        if (code == 0) { // 0 is for tell_a_friend
            [self PullAndUpdateDB_TellAFriend];
        } else if (code == 1) { // 1 is for send_feedback
            [self PullAndUpdateDB_SendFeedback];
        }
    }
    NSArray *toRecipients = [NSArray arrayWithObjects:[emailRecipient copy],nil];
    [controller setToRecipients:toRecipients];
    [controller setSubject:emailSubject];
    [controller setMessageBody:emailBody isHTML:NO];
    return controller;
    
}

- (void) LoadFromDB:(int)code
{
    CrudOp *dbCrud = [[CrudOp alloc]init];
    NSMutableArray* emailArray;
    if (code == 0){
        emailArray = [dbCrud PullFromLocalDB:@"tell_a_friend"];
    } else if (code == 1) {
        emailArray = [dbCrud PullFromLocalDB:@"send_feedback"];
    }
    emailSubject = [[emailArray objectAtIndex:0] objectForKey:@"Subject"];
    emailBody = [[emailArray objectAtIndex:0] objectForKey:@"Message"];
    emailRecipient = [[emailArray objectAtIndex:0] objectForKey:@"To"];
}

-(void) UpdateLocalDB:(NSString*)tableName :(NSMutableArray*)tableArray
{
    CrudOp *dbCrud = [[CrudOp alloc] init];
    [dbCrud UpdateLocalDB:tableName :tableArray];
}

- (void) PullAndUpdateDB_TellAFriend
{
    
    NSDictionary* jsonDict = [Utils PullRemoteData:@"http://pluto.moa.ubc.ca/_mobile_app_remoteData.php"];
    NSMutableArray* emailArray = [jsonDict objectForKey:@"tell_a_friend"];
    emailSubject = [[emailArray objectAtIndex:0] objectForKey:@"Subject"];
    emailBody = [[emailArray objectAtIndex:0] objectForKey:@"Message"];
    [emailRecipient setString:@""];
    [self UpdateLocalDB:@"tell_a_friend" :emailArray];
}




- (void) PullAndUpdateDB_SendFeedback
{
    NSDictionary* jsonDict = [Utils PullRemoteData:@"http://pluto.moa.ubc.ca/_mobile_app_remoteData.php"];
    NSMutableArray* emailArray = [jsonDict objectForKey:@"send_feedback"];
    emailSubject = [[emailArray objectAtIndex:0] objectForKey:@"Subject"];
    emailBody = [[emailArray objectAtIndex:0] objectForKey:@"Message"];
    emailRecipient = [[emailArray objectAtIndex:0] objectForKey:@"To"];
    [self UpdateLocalDB:@"send_feedback" :emailArray];
}



@end
