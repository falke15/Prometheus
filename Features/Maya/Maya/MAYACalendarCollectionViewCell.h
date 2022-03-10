//
//  MAYACalendarCollectionViewCell.h
//  Maya
//
//  Created by pyretttt pyretttt on 18.01.2022.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

extern NSString * const MAYACalendarCollectionViewCellReuseIdentifier;

@interface MAYACalendarCollectionViewCell : UICollectionViewCell

- (void)updateWithInfo:(NSString *)text;

@end

NS_ASSUME_NONNULL_END
