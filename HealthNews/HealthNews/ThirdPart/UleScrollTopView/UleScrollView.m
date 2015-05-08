//
//  UleScrollView.m
//  HealthNews
//
//  Created by yushengyang on 15/5/8.
//  Copyright (c) 2015年 yushengyang. All rights reserved.
//

#import "UleScrollView.h"
#import "UIScrollView+TwitterCover.h"

CGFloat const offset_HeaderStop = 40.0;
CGFloat const offset_B_LabelHeader = 95.0;
CGFloat const distance_W_LabelHeader = 35.0;

@implementation UleScrollView
- (UleScrollView *)initScrollViewWithBackgound:(UIImage*)backgroundImage avatarImage:(UIImage *)avatarImage titleString:(NSString *)titleString subtitleString:(NSString *)subtitleString buttonTitle:(NSString *)buttonTitle contentHeight:(CGFloat)height {
    
    CGRect bounds = [[UIScreen mainScreen] bounds];
    self = [[UleScrollView alloc] initWithFrame:bounds];
    [self setupView:backgroundImage avatarImage:avatarImage titleString:titleString subtitleString:subtitleString buttonTitle:buttonTitle scrollHeight:height type:UleScrollNormal];
    
    return self;
}


- (UleScrollView *)initTableViewWithBackgound:(UIImage*)backgroundImage avatarImage:(UIImage *)avatarImage titleString:(NSString *)titleString subtitleString:(NSString *)subtitleString buttonTitle:(NSString *)buttonTitle {
    
    CGRect bounds = [[UIScreen mainScreen] bounds];
    self = [[UleScrollView alloc] initWithFrame:bounds];
    
    [self setupView:backgroundImage avatarImage:avatarImage titleString:titleString subtitleString:subtitleString buttonTitle:buttonTitle scrollHeight:0 type:UleScrollTable];
    [self.m_tableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    return self;
    
}



- (void) setupView:(UIImage*)backgroundImage avatarImage:(UIImage *)avatarImage titleString:(NSString *)titleString subtitleString:(NSString *)subtitleString buttonTitle:(NSString *)buttonTitle scrollHeight:(CGFloat)height type:(UleScrollType)type {
    
    
    // Header
    self.m_header = [[UIView alloc] initWithFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, 107)];
    [self addSubview:self.m_header];
    self.m_headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.origin.x, self.m_header.frame.size.height - 5, self.frame.size.width, 25)];
    self.m_headerLabel.textAlignment = NSTextAlignmentCenter;
    self.m_headerLabel.text = titleString;
    self.m_headerLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:18];
    self.m_headerLabel.textColor = [UIColor whiteColor];
    [self.m_header addSubview:self.m_headerLabel];
    
    if (type == UleScrollTable) {
        // TableView
        self.m_tableView = [[UITableView alloc] initWithFrame:self.frame];
        self.m_tableView.backgroundColor = [UIColor clearColor];
        self.m_tableView.showsVerticalScrollIndicator = NO;
        
        // TableView Header
        self.m_tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.m_header.frame.size.height + 100)];
        [self addSubview:self.m_tableView];
        
    } else {
        
        // Scroll
        self.m_scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height)];
        self.m_scrollView.showsVerticalScrollIndicator = NO;
        [self addSubview:self.m_scrollView];
        
        CGSize newSize = CGSizeMake(self.frame.size.width, height);
        self.m_scrollView.contentSize = newSize;
        self.m_scrollView.delegate = self;
    }
    
    
    self.m_avatarImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 79, 69, 69)];
    self.m_avatarImage.image = avatarImage;
    self.m_avatarImage.layer.cornerRadius = 10;
    self.m_avatarImage.layer.borderWidth = 3;
    self.m_avatarImage.layer.borderColor = [UIColor whiteColor].CGColor;
    self.m_avatarImage.clipsToBounds = YES;
    
    self.m_titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 156, 250, 25)];
    self.m_titleLabel.text = titleString;
    
    self.m_subtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 177, 250, 25)];
    self.m_subtitleLabel.text = subtitleString;
    self.m_subtitleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:12];
    self.m_subtitleLabel.textColor = [UIColor lightGrayColor];
    
    
    if (buttonTitle.length > 0) {
        self.m_headerButton = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width - 100, 120, 80, 35)];
        [self.m_headerButton setTitle:buttonTitle forState:UIControlStateNormal];
        [self.m_headerButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        self.m_headerButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:12];
        self.m_headerButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.m_headerButton.layer.borderWidth = 1;
        self.m_headerButton.layer.cornerRadius = 8;
        [self.m_headerButton addTarget:self action:@selector(recievedMBTwitterScrollButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    
    if (type == UleScrollTable) {
        [self.m_tableView addSubview:self.m_avatarImage];
        [self.m_tableView addSubview:self.m_titleLabel];
        [self.m_tableView addSubview:self.m_subtitleLabel];
        if (buttonTitle.length > 0) {
            [self.m_tableView addSubview:self.m_headerButton];
        }
    } else {
        [self.m_scrollView addSubview:self.m_avatarImage];
        [self.m_scrollView addSubview:self.m_titleLabel];
        [self.m_scrollView addSubview:self.m_subtitleLabel];
        if (buttonTitle.length > 0) {
            [self.m_scrollView addSubview:self.m_headerButton];
        }
    }
    
    
    self.m_headerImageView = [[UIImageView alloc] initWithFrame:self.m_header.frame];
    self.m_headerImageView.image = backgroundImage;
    self.m_headerImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.m_header insertSubview:self.m_headerImageView aboveSubview:self.m_headerLabel];
    self.m_header.clipsToBounds = YES;
    
    self.m_avatarImage.layer.cornerRadius = 10;
    self.m_avatarImage.layer.borderWidth = 3;
    self.m_avatarImage.layer.borderColor = [UIColor whiteColor].CGColor;
    
    self.m_blurImages = [[NSMutableArray alloc] init];
    
    if (backgroundImage != nil) {
        [self prepareForBlurImages];
    } else {
        self.m_headerImageView.backgroundColor = [UIColor blackColor];
    }
    
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offset = scrollView.contentOffset.y;
    [self animationForScroll:offset];
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    CGFloat offset = self.m_tableView.contentOffset.y;
    [self animationForScroll:offset];
}


- (void) animationForScroll:(CGFloat) offset {
    NSLog(@"offset:%@",@(offset));
    CATransform3D headerTransform = CATransform3DIdentity;
    CATransform3D avatarTransform = CATransform3DIdentity;
    
    // DOWN -----------------
    
    if (offset < 0) {
        
        CGFloat headerScaleFactor = -(offset) / self.m_header.bounds.size.height;
        CGFloat headerSizevariation = ((self.m_header.bounds.size.height * (1.0 + headerScaleFactor)) - self.m_header.bounds.size.height)/2.0;
        headerTransform = CATransform3DTranslate(headerTransform, 0, headerSizevariation, 0);
        headerTransform = CATransform3DScale(headerTransform, 1.0 + headerScaleFactor, 1.0 + headerScaleFactor, 0);
        
        self.m_header.layer.transform = headerTransform;
        
        if (offset < -self.frame.size.height/3.5) {
            [self recievedMBTwitterScrollEvent];
        }
        
    }
    
    // SCROLL UP/DOWN ------------
    
    else {
        
        // Header -----------
        headerTransform = CATransform3DTranslate(headerTransform, 0, MAX(-offset_HeaderStop, -offset), 0);
        
        //  ------------ Label
        CATransform3D labelTransform = CATransform3DMakeTranslation(0, MAX(-distance_W_LabelHeader, offset_B_LabelHeader - offset), 0);
        self.m_headerLabel.layer.transform = labelTransform;
        self.m_headerLabel.layer.zPosition = 2;
        
        // Avatar -----------
        CGFloat avatarScaleFactor = (MIN(offset_HeaderStop, offset)) / self.m_avatarImage.bounds.size.height / 1.4; // Slow down the animation
        CGFloat avatarSizeVariation = ((self.m_avatarImage.bounds.size.height * (1.0 + avatarScaleFactor)) - self.m_avatarImage.bounds.size.height) / 2.0;
        avatarTransform = CATransform3DTranslate(avatarTransform, 0, avatarSizeVariation, 0);
        avatarTransform = CATransform3DScale(avatarTransform, 1.0 - avatarScaleFactor, 1.0 - avatarScaleFactor, 0);
        
        if (offset <= offset_HeaderStop) {
            
            if (self.m_avatarImage.layer.zPosition <= self.m_headerImageView.layer.zPosition) {
                self.m_header.layer.zPosition = 0;
            }
            
        }else {
            if (self.m_avatarImage.layer.zPosition >= self.m_headerImageView.layer.zPosition) {
                self.m_header.layer.zPosition = 2;
            }
        }
        
    }
    if (self.m_headerImageView.image != nil) {
        [self blurWithOffset:offset];
    }
    self.m_header.layer.transform = headerTransform;
    self.m_avatarImage.layer.transform = avatarTransform;
    
    
}



- (void)prepareForBlurImages
{
    CGFloat factor = 0.1;
    [self.m_blurImages addObject:self.m_headerImageView.image];
    for (NSUInteger i = 0; i < self.m_headerImageView.frame.size.height/10; i++) {
        [self.m_blurImages addObject:[self.m_headerImageView.image boxblurImageWithBlur:factor]];
        factor+=0.04;
    }
}



- (void) blurWithOffset:(float)offset {
    NSInteger index = offset / 10;
    if (index < 0) {
        index = 0;
    }
    else if(index >= self.m_blurImages.count) {
        index = self.m_blurImages.count - 1;
    }
    UIImage *image = self.m_blurImages[index];
    if (self.m_headerImageView.image != image) {
        [self.m_headerImageView setImage:image];
    }
}



- (void) recievedMBTwitterScrollButtonClicked {
    [self.delegate recievedUleScrollButtonClicked];
}



- (void) recievedMBTwitterScrollEvent {
    [self.delegate recievedUleScrollEvent];
}


// Function to blur the header image (used if the header image is replaced with updateHeaderImage)
-(void)resetBlurImages {
    [self.m_blurImages removeAllObjects];
    [self prepareForBlurImages];
}


// Function to update the header image and blur it out appropriately
-(void)updateHeaderImage:(UIImage*)mImage {
    self.m_headerImageView.image = mImage;
    [self resetBlurImages];
}
@end
