//
//  MDrawText.h
//  Motics
//
//  Created by Gao Yongqing on 2/10/14.
//
//

#import "MDrawRect.h"

@interface MDrawText : MDrawRect

@property (nonatomic,strong) NSString *text;

@property (nonatomic,strong) UIColor *backgroundColor;

/**
 *  Init a DrawText with frame and text
 *
 *  @param frame The frame for text tool
 *  @param text  The text to display
 *
 *  @return An instance of MDrawText
 */
-(id)initWithFrame:(CGRect)frame andText:(NSString *)text;

@end
