//
//  AboutViewController.h
//  MOA
//
//  Created by Marilyn Edgar on 2014-03-07.
//  Copyright (c) 2014 Museum of Anthropology UBC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AboutViewController : UIViewController
- (IBAction)exit:(id)sender;
//@property NSString* description;

//- (UITextView*) prepareForDisplay:(int)yPosition;
@property (weak, nonatomic) IBOutlet UITextView *description;
@end

NSMutableArray *generalTextArray;
