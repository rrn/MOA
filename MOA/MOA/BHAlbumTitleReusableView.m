//
//  BHAlbumTitleReusableView.m
//  MOA
//
//  Created by Sukhi Mann on 11/19/2013.
//  Copyright (c) 2013 Museum of Anthropology UBC. All rights reserved.
//

#import "BHAlbumTitleReusableView.h"

@interface BHAlbumTitleReusableView ()

@property (nonatomic, strong, readwrite) UILabel *titleLabel;
@property (nonatomic, strong, readwrite) UILabel *countryLabel;
@property (nonatomic, strong, readwrite) UILabel *dateLabel;

@end

@implementation BHAlbumTitleReusableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height/3)];
        self.titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth |
        UIViewAutoresizingFlexibleHeight;
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont boldSystemFontOfSize:13.0f];
        //self.titleLabel.shadowColor = [UIColor colorWithWhite:0.0f alpha:0.3f];
        self.titleLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
        self.titleLabel.numberOfLines = 0;
        self.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        
        self.countryLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.bounds.size.height/3, self.bounds.size.width, self.bounds.size.height/3)];
        self.countryLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth |
        UIViewAutoresizingFlexibleHeight;
        self.countryLabel.backgroundColor = [UIColor clearColor];
        self.countryLabel.textAlignment = NSTextAlignmentCenter;
        self.countryLabel.font = [UIFont boldSystemFontOfSize:13.0f];
        //self.countryLabel.shadowColor = [UIColor colorWithWhite:0.0f alpha:0.3f];
        self.countryLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
        self.countryLabel.numberOfLines = 0;
        self.countryLabel.lineBreakMode = NSLineBreakByWordWrapping;
        
        self.dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 2*self.bounds.size.height/3, self.bounds.size.width, self.bounds.size.height/3)];
        self.dateLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth |
        UIViewAutoresizingFlexibleHeight;
        self.dateLabel.backgroundColor = [UIColor clearColor];
        self.dateLabel.textAlignment = NSTextAlignmentCenter;
        self.dateLabel.font = [UIFont boldSystemFontOfSize:13.0f];
        //self.dateLabel.shadowColor = [UIColor colorWithWhite:0.0f alpha:0.3f];
        self.dateLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
        self.dateLabel.numberOfLines = 0;
        self.dateLabel.lineBreakMode = NSLineBreakByWordWrapping;
        
        [self addSubview:self.titleLabel];
        [self addSubview:self.countryLabel];
        [self addSubview:self.dateLabel];
        
        
    }
    return self;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    self.titleLabel.text = nil;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
