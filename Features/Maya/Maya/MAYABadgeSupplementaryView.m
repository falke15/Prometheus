//
//  MAYABadgeSupplementaryView.m
//  Maya
//
//  Created by pyretttt pyretttt on 27.01.2022.
//

#import "MAYABadgeSupplementaryView.h"

NSString * const MAYABadgeSupplementaryViewID = @"MAYABadgeSupplementaryViewID";

@interface MAYABadgeSupplementaryView()
@property(nonatomic, strong)UIView *bageView;

@end

@implementation MAYABadgeSupplementaryView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        [self createUI];
    }
    
    return self;
}

- (void)createUI
{
    _bageView = [UIView new];
    _bageView.translatesAutoresizingMaskIntoConstraints = false;
    _bageView.backgroundColor = UIColor.redColor;
    
    [self addSubview:_bageView];
    [NSLayoutConstraint activateConstraints:@[
        [_bageView.topAnchor constraintEqualToAnchor:self.topAnchor],
        [_bageView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [_bageView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        [_bageView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor]
    ]];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _bageView.layer.cornerRadius = self.frame.size.width / 2;
}

@end
