//
//  MAYACalendarCollectionViewCell.m
//  Maya
//
//  Created by pyretttt pyretttt on 18.01.2022.
//

#import "MAYACalendarCollectionViewCell.h"

NSString * const MAYACalendarCollectionViewCellReuseIdentifier = @"MAYACalendarCollectionViewCellReuseID";

@interface MAYACalendarCollectionViewCell()
@property(nonatomic, strong)UILabel *textLabel;
@property(nonatomic, strong)UIView *contextView;

@end

@implementation MAYACalendarCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:CGRectZero];
    
    if (self)
    {
        [self createUI];
        [self setupUI];
    }
    
    return self;
}

- (void)createUI
{
    _textLabel = [UILabel new];
    _textLabel.textColor = [UIColor systemBlueColor];
    _textLabel.textAlignment = NSTextAlignmentCenter;
    _textLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _contextView = [UIView new];
    _contextView.backgroundColor = [UIColor.systemGrayColor colorWithAlphaComponent:0.5f];
    _contextView.layer.cornerRadius = 12.f;
    _contextView.translatesAutoresizingMaskIntoConstraints = NO;
}

- (void)setupUI
{
    [self.contentView addSubview:_contextView];
    [_contextView addSubview:_textLabel];
    
    NSLayoutConstraint *widthAnchor = [_contextView.widthAnchor constraintEqualToAnchor:self.contentView.widthAnchor];
    NSLayoutConstraint *heightAnchor = [_contextView.heightAnchor constraintEqualToAnchor:self.contentView.heightAnchor];
    widthAnchor.priority = UILayoutPriorityDefaultLow;
    heightAnchor.priority = UILayoutPriorityDefaultLow;
    [NSLayoutConstraint activateConstraints:@[
        [_contextView.centerXAnchor constraintEqualToAnchor:self.contentView.centerXAnchor],
        [_contextView.centerYAnchor constraintEqualToAnchor:self.contentView.centerYAnchor],
        [_contextView.heightAnchor constraintEqualToAnchor:_contextView.widthAnchor],
        widthAnchor,
        heightAnchor,
        
        [_textLabel.centerXAnchor constraintEqualToAnchor:_contextView.centerXAnchor],
        [_textLabel.centerYAnchor constraintEqualToAnchor:_contextView.centerYAnchor]
    ]];
}

- (void)updateWithInfo:(NSString *)text
{
    _textLabel.text = text;
}

@end
