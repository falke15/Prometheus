//
//  MAYADemoViewController.m
//  Maya
//
//  Created by pyretttt pyretttt on 14.01.2022.
//

#import <UIKit/UIKit.h>
#import "Maya/Maya-Swift.h"
#import "MAYADemoViewController.h"
#import "MAYACalendarDataSource.h"
#import "MAYACalendarCollectionViewCell.h"
#import "MAYABadgeSupplementaryView.h"
#import "UICollectionView+Constants.h"
#import "MAYACalendarEntry.h"

@interface MAYADemoViewController() <UICollectionViewDataSource, UICollectionViewDelegate>

@property(nonatomic, strong)UICollectionView *collectionView;
@property(nonatomic, strong)MAYACalendarCollectionLayout *collectionLayout;
@property(nonatomic, strong)MAYACalendarDataSource *calendarDataSource;
@property(nonatomic, copy)NSArray<NSIndexPath *> *markedIndexPathes;

@end

@implementation MAYADemoViewController


@synthesize collectionLayout;

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        self.markedIndexPathes = @[];
        [self createUI];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupUI];
    self.navigationController.navigationBar.tintColor = UIColor.whiteColor;
}

- (void)createUI
{
    _calendarDataSource = [[MAYACalendarDataSource alloc] init];
    collectionLayout = [MAYACalendarCollectionLayout new];
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero
                                         collectionViewLayout:collectionLayout];
    [_collectionView registerClass:[MAYACalendarCollectionViewCell class]
        forCellWithReuseIdentifier:MAYACalendarCollectionViewCellReuseIdentifier];
    [_collectionView registerClass:[MAYABadgeSupplementaryView class]
        forSupplementaryViewOfKind:MAYABageSupplementaryViewKind
               withReuseIdentifier:MAYABadgeSupplementaryViewID];
    
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.allowsMultipleSelection = NO;
    _collectionView.translatesAutoresizingMaskIntoConstraints = false;
    _collectionView.backgroundColor = UIColor.clearColor;
}

- (void)setupUI
{
    self.view.backgroundColor = UIColor.blackColor;
    
    NSArray<UIView*> *views = @[_collectionView];

    for (UIView *view in views)
    {
        [self.view addSubview:view];
    }

    [self setupConstaints];
}

- (void)setupConstaints
{
    [NSLayoutConstraint activateConstraints: @[
        [_collectionView.topAnchor constraintEqualToAnchor: self.view.safeAreaLayoutGuide.topAnchor
                                                  constant:16.f],
        [_collectionView.leftAnchor constraintEqualToAnchor: self.view.safeAreaLayoutGuide.leftAnchor
                                                   constant:16.f],
        [_collectionView.trailingAnchor constraintEqualToAnchor: self.view.safeAreaLayoutGuide.trailingAnchor
                                                       constant:-16.f],
        [_collectionView.heightAnchor constraintEqualToConstant:400.f],
    ]];
}


#pragma mark - UICollectionViewDataSource & UICollectionViewDelegate


- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView
                                   cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    MAYACalendarEntry *model = [_calendarDataSource getEntriesToDisplay][indexPath.item];
    UICollectionViewCell *cell = [_collectionView dequeueReusableCellWithReuseIdentifier:MAYACalendarCollectionViewCellReuseIdentifier
                                                                            forIndexPath:indexPath];
    
    if ([cell isMemberOfClass:[MAYACalendarCollectionViewCell class]])
    {
        [(MAYACalendarCollectionViewCell *)cell updateWithInfo:model.day];
        return cell;
    }
    
    return nil;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [[_calendarDataSource getEntriesToDisplay] count];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:MAYABageSupplementaryViewKind])
    {
        return [_collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                   withReuseIdentifier:MAYABadgeSupplementaryViewID
                                                          forIndexPath:indexPath];
    }
    
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    MAYACalendarEntry *model = [_calendarDataSource getEntriesToDisplay][indexPath.item];
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    self.markedIndexPathes = [self.markedIndexPathes arrayByAddingObject:indexPath];
    [collectionView.collectionViewLayout invalidateLayout];
}

#pragma MARK: - MAYADataSourceProvider

- (nonnull NSArray<NSIndexPath *> *)getMarkedIndexPathes
{
    return self.markedIndexPathes;
}


@end
