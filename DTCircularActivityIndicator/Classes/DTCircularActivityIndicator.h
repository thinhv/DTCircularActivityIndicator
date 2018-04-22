//
//  DTCircularActivityIndicator.h
//  DTCircularActivityIndicator
//
//  Created by Thinh Vo on 23/04/2018.
//

#import <UIKit/UIKit.h>

@interface DTCircularActivityIndicator : UIView

/**
 @brief This property let the user known if the indicator is animating or not.
 */
@property(nonatomic, readonly) BOOL isAnimating;

/**
 @brief Automatically hide the indicator if it stop animating. Default value is YES.
 */
@property(nonatomic, assign) BOOL shouldHideWhenStop;

/**
 @brief Automatically show the indicator if it start animating. Default value is YES.
 */
@property(nonatomic, assign) BOOL shouldShowWhenStart;

/**
 @brief This property controls the width of the circular stroke path.
 */
@property(nonatomic, assign) CGFloat lineWidth;

/**
 @brief Duration for stroke start animation
 */
@property(nonatomic, assign) CGFloat strokeStartDuration;

/**
 @brief Duration for stroke end animation
 */
@property(nonatomic, assign) CGFloat strokeEndDuration;

/**
 @brief Rotating duration for 2pi.
 */
@property(nonatomic, assign) CGFloat spinDuration;

/**
 @brief This array contains multiple colors for the indicator. The indicator will change to the next color after finishing strokeStart and strokeEnd animation. This array should contain one color if changing to multiple color is not needed.
 */
@property(nonatomic, strong) NSArray *colors;

/**
 @brief Start animating
 */
- (void)startAnimating;


/**
 @brief Stop animating
 */
- (void)stopAnimating;

@end
