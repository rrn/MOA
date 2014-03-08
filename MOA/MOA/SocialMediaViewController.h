//
//  SocialMediaViewController.h
//  MOA
//
//  Created by Donald Cheng on 2/19/2014.
//  Copyright (c) 2014 Museum of Anthropology UBC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SocialMediaViewController : UIViewController <UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sideBarButton;
@property (strong, nonatomic) IBOutlet UIWebView *webView;



@end
