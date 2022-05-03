//
//  MAYADemoViewController.h
//  Maya
//
//  Created by pyretttt pyretttt on 14.01.2022.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MAYADataSourceProvider <UICollectionViewDelegate, UICollectionViewDataSource>

- (NSArray<NSIndexPath *>*)getMarkedIndexPathes;

@end

@interface MAYADemoViewController : UIViewController <MAYADataSourceProvider>

@end

NS_ASSUME_NONNULL_END
