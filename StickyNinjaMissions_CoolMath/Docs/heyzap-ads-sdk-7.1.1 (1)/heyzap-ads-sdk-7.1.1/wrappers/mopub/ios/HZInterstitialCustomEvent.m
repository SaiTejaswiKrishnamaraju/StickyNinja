/*
 * Copyright (c) 2014, Smart Balloon, Inc.
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are
 * met:
 *
 * * Redistributions of source code must retain the above copyright
 *   notice, this list of conditions and the following disclaimer.
 *
 * * Redistributions in binary form must reproduce the above copyright
 *   notice, this list of conditions and the following disclaimer in the
 *   documentation and/or other materials provided with the distribution.
 *
 * * Neither the name of 'MoPub Inc.' nor the names of its contributors
 *   may be used to endorse or promote products derived from this software
 *   without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED
 * TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
 * PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
 * CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
 * EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 * PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
 * PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
 * LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
 * NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "HZInterstitialCustomEvent.h"
#import "MPLogging.h"

////////////////////////////////////////////////////////////////////////////////////////////////////

@interface HZInterstitialCustomEvent ()

@property (nonatomic, assign) BOOL isOnScreen;

@end

@implementation HZInterstitialCustomEvent

@synthesize isOnScreen = _isOnScreen;

- (void)requestInterstitialWithCustomEventInfo:(NSDictionary *)info
{
    MPLogInfo(@"Requesting Heyzap interstitial");
    self.isOnScreen = NO;
    
    [HeyzapAds setMediator: @"mopub"];
    [HeyzapAds setDelegate: self];
    [HZInterstitialAd fetch];
}

- (void)showInterstitialFromRootViewController:(UIViewController *)controller {
    if (self.isOnScreen == YES) {
        MPLogInfo(@"Heyzap ad is already on screen.");
        return;
    }
    
    if ([HZInterstitialAd isAvailable]) {
        [self.delegate interstitialCustomEventWillAppear:self];
        self.isOnScreen = YES;
        [HZInterstitialAd show];

    } else {
        MPLogInfo(@"Failed to show Heyzap interstitial: a previously loaded Heyzap interstitial now claims not to be ready.");
    }
}

#pragma mark - Heyzap Ads Delegate

- (void) didReceiveAdWithTag:(NSString *)tag {
    MPLogInfo(@"Loaded Heyzap interstitial");
    self.isOnScreen = NO;
    [self.delegate interstitialCustomEvent:self didLoadAd: nil];
}

- (void) didFailToReceiveAdWithTag:(NSString *)tag {
    MPLogInfo(@"Failed to load Heyzap interstitial");
    self.isOnScreen = NO;
    [self.delegate interstitialCustomEvent:self didFailToLoadAdWithError: nil];
}

- (void) didShowAdWithTag:(NSString *)tag {
    MPLogInfo(@"Showed Heyzap interstitial");
    [self.delegate interstitialCustomEventDidAppear:self];
}

- (void) didHideAdWithTag:(NSString *)tag {
    if (self.isOnScreen == YES) {
        MPLogInfo(@"Hid Heyzap interstitial");
        [self.delegate interstitialCustomEventWillDisappear:self];
        [self.delegate interstitialCustomEventDidDisappear:self];
        self.isOnScreen = NO;
    }
}

- (void) didFailToShowAdWithTag:(NSString *)tag andError:(NSError *)error {
    MPLogInfo(@"Failed to show Heyzap interstitial: is the internet connection alive?");
    self.isOnScreen = NO;
    [self.delegate interstitialCustomEvent:self didFailToLoadAdWithError: error];
}

- (void) didClickAdWithTag:(NSString *)tag {
    MPLogInfo(@"Tapped Heyzap interstitial");
    self.isOnScreen = NO;
    [self.delegate interstitialCustomEventDidReceiveTapEvent:self];
}

@end
