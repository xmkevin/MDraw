//
//  MDrawRect.h
//  MDraw
//
//  Created by Gao Yongqing on 8/23/13.
//  Copyright (c) 2013 Motic China Group Co., Ltd. All rights reserved.
//

#import "MDrawTool.h"

enum MDrawMoveDirection {
    MDrawMoveDirectionNone = 0,
    MDrawMoveDirectionWhole = 1,
    MDrawMoveDirectionTL = 2,
    MDrawMoveDirectionTM = 3,
    MDrawMoveDirectionTR = 4,
    MDrawMoveDirectionRM = 5,
    MDrawMoveDirectionBR = 6,
    MDrawMoveDirectionBM = 7,
    MDrawMoveDirectionBL = 8,
    MDrawMoveDirectionLM = 9
};

@interface MDrawRect : MDrawTool

@end
