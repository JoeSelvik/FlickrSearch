//
//  XYZFlickrPhotoCell.h
//  FlickrSearch
//
//  Created by Joe Selvik on 11/14/13.
//  Copyright (c) 2013 Joe Selvik. All rights reserved.
//

//#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@class FlickrPhoto;

@interface XYZFlickrPhotoCell : UICollectionViewCell

@property (nonatomic, strong) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) FlickrPhoto *photo;

@end
