/*
 Copyright (c) 2013 ParentalGate.com. All rights reserved.
 
 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:
 
 * Redistributions of source code must retain the above copyright notice, this
 list of conditions and the following disclaimer.
 
 * Redistributions in binary form must reproduce the above copyright notice,
 this list of conditions and the following disclaimer in the documentation
 and/or other materials provided with the distribution.
 
 * Neither the name of the author nor the names of its contributors may be used
 to endorse or promote products derived from this software without specific
 prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE
 FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

typedef enum {
    ParentalGateType3FingerTap = 1,
    ParentalGateTypeQuestion,
    ParentalGateTypeEnterNumber = ParentalGateTypeQuestion,
    ParentalGateTypeDivisibleBy3 = ParentalGateTypeQuestion,
    ParentalGateTypeNone = ParentalGateType3FingerTap
}ParentalGateType;

@protocol ParentalLockSuccessDelegate;
@protocol ParentalLockShowDelegate;

@interface PGView : UIView{
    
}

@property (nonatomic , unsafe_unretained) id <ParentalLockShowDelegate>showDelegate;

@property (nonatomic , unsafe_unretained) id <ParentalLockSuccessDelegate>delegate;

@property (nonatomic) ParentalGateType lockType;

@property (nonatomic , readonly) BOOL isShown;

/***use titleFont and titleColor are used to change the title label attributes i.e. first line***/
@property (nonatomic , strong) UIFont *titleFont;
@property (nonatomic , strong) UIColor *titleColor;

/***use descriptionFont and descriptionColor are used to change the description label attributes i.e. second line***/
@property (nonatomic , strong) UIFont *descriptionFont;
@property (nonatomic , strong) UIColor *descriptionColor;

/***use questionFont and questionColor are used to change the question label attributes***/
@property (nonatomic , strong) UIFont *questionFont;
@property (nonatomic , strong) UIColor *questionColor;

/***use textBoxFont and textBoxFont are used to change the input text label attributes***/
@property (nonatomic , strong) UIFont *textBoxFont;
@property (nonatomic , strong) UIColor *textBoxColor;

+ (void) initWithParentalGateAppKey:(NSString *)appKey;

- (id) initWithSize:(CGSize)size andParentalGate:(ParentalGateType)gateType;
    
- (void) hide;

- (void) show;

@end


@protocol ParentalLockSuccessDelegate <NSObject>

- (void) ParentalLockSucceeded: (PGView *)sender;
- (void) ParentalLockCancelled: (PGView *)sender;

@end

@protocol ParentalLockShowDelegate <NSObject>

@optional
- (void) ParentalLockWillShow: (PGView *)sender;
- (void) ParentalLockDidShow: (PGView *)sender;
- (void) ParentalLockWillHide: (PGView *)sender;
- (void) ParentalLockDidHide: (PGView *)sender;

@end