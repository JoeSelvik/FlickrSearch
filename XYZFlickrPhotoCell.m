//
//  XYZFlickrPhotoCell.m
//  FlickrSearch
//
//  Created by Joe Selvik on 11/14/13.
//  Copyright (c) 2013 Joe Selvik. All rights reserved.
//

#import "XYZFlickrPhotoCell.h"
#import "FlickrPhoto.h"

@implementation XYZFlickrPhotoCell

//- (id)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        // Initialization code
//    }
//    return self;
//}

-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        UIView *bgView = [[UIView alloc] initWithFrame:self.backgroundView.frame];
        bgView.backgroundColor = [UIColor blueColor];
        bgView.layer.borderColor = [[UIColor whiteColor] CGColor];
        bgView.layer.borderWidth = 4;
        self.selectedBackgroundView = bgView;
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

// Update the Photo in a UICVCell
-(void) setPhoto:(FlickrPhoto *)photo {
    
    if(_photo != photo) {
        _photo = photo;
    }
    self.imageView.image = _photo.thumbnail;
}

@end
