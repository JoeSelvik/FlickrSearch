//
//  XYZFlickrPhotoHeaderView.m
//  FlickrSearch
//
//  Created by Joe Selvik on 11/15/13.
//  Copyright (c) 2013 Joe Selvik. All rights reserved.
//

#import "XYZFlickrPhotoHeaderView.h"

@interface XYZFlickrPhotoHeaderView ()
@property(weak) IBOutlet UIImageView *backgroundImageView;
@property(weak) IBOutlet UILabel *searchLabel;
@end

@implementation XYZFlickrPhotoHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

// builds a new UIImage to span the background image, sets the label text, and then centers the text on the label
-(void)setSearchText:(NSString *)text {
    self.searchLabel.text = text;
    UIImage *shareButtonImage = [[UIImage imageNamed:@"header_bg.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(68, 68, 68, 68)];
    self.backgroundImageView.image = shareButtonImage;
    self.backgroundImageView.center = self.center;
}

@end
