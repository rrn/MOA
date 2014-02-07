//
//  Utils.m
//  This class contains helper functions
//  MOA
//
//  Created by Diana Sutandie on 2/6/2014.
//  Copyright (c) 2014 Museum of Anthropology UBC. All rights reserved.
//

#import "Utils.h"

@implementation Utils

+ (int)textViewDidChange:(UITextView *)textView
{
    CGFloat fixedWidth = textView.frame.size.width;
    CGSize newSize = [textView sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
    CGRect newFrame = textView.frame;
    newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
    textView.frame = newFrame;
    return newSize.height;
}

@end


