/*
 * Copyright (c) 2013, Smart Balloon, Inc.
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

package com.heyzap.sdk.integrations;

import static com.mopub.mobileads.MoPubErrorCode.ADAPTER_CONFIGURATION_ERROR;
import static com.mopub.mobileads.MoPubErrorCode.NETWORK_NO_FILL;
import static com.mopub.mobileads.MoPubErrorCode.NETWORK_TIMEOUT;

import java.util.Map;

import android.app.Activity;
import android.content.Context;
import android.util.Log;

import com.heyzap.sdk.ads.HeyzapAds;
import com.heyzap.sdk.ads.InterstitialAd;
import com.heyzap.sdk.ads.HeyzapAds.OnStatusListener;
import com.mopub.mobileads.CustomEventInterstitial;
import com.mopub.mobileads.CustomEventInterstitial.CustomEventInterstitialListener;

/*
 * Compatible with Heyzap SDK version 6.0.0+
 */

class MoPubInterstitial extends CustomEventInterstitial implements HeyzapAds.OnStatusListener {

    private Context context;
    private boolean mHasAlreadyRegisteredClick;
    private CustomEventInterstitialListener mInterstitialListener;

    @Override
    protected void loadInterstitial(Context context, CustomEventInterstitialListener customEventInterstitialListener, Map<String, Object> localExtras, Map<String, String> serverExtras) {
        mInterstitialListener = customEventInterstitialListener;

        if (!(context instanceof Activity)) {
            mInterstitialListener.onInterstitialFailed(ADAPTER_CONFIGURATION_ERROR);
            return;
        }

        this.context = context;
        

        if (!HeyzapAds.hasStarted()) {
            String publisherId = serverExtras.get("publisher_id");
            HeyzapAds.mediator = "mopub";
            HeyzapAds.start(publisherId, context, HeyzapAds.DISABLE_AUTOMATIC_FETCH);
        }

        InterstitialAd.fetch();
    }

    @Override
    protected void showInterstitial() {
        if (InterstitialAd.isAvailable()) {
            InterstitialAd.display((Activity) context);
        } else {
            Log.d("MoPub", "Tried to show a Heyzap interstitial ad before it finished loading. Please try again.");
        }
    }

    @Override
    protected void onInvalidate() {
        HeyzapAds.setOnStatusListener(null);
    }

    @Override
    public void onShow(String tag) {
        Log.d("MoPub", "Showing Heyzap interstitial ad.");
        mInterstitialListener.onInterstitialShown();
    }

    /*
     * Heyzap AdListener implementation
     */

    @Override
    public void onClick(String tag) {
        // TODO: This only tracks clicks accurately if all clicks result in
        // leaving the app.
        Log.d("MoPub", "Heyzap interstitial ad clicked.");
        mInterstitialListener.onInterstitialClicked();
    }

    @Override
    public void onHide(String tag) {
        Log.d("MoPub", "Heyzap interstitial ad dismissed.");
        mInterstitialListener.onInterstitialDismissed();
    }

    @Override
    public void onFailedToShow(String tag) {
        Log.d("MoPub", "Heyzap interstitial ad failed to show.");
        mInterstitialListener.onInterstitialFailed(NETWORK_TIMEOUT);
    }

    @Override
    public void onAvailable(String tag) {
        Log.d("MoPub", "Heyzap interstitial ad loaded successfully.");
        mInterstitialListener.onInterstitialLoaded();
    }

    @Override
    public void onFailedToFetch(String tag) {
        Log.d("MoPub", "Heyzap interstitial ad failed to load.");
        mInterstitialListener.onInterstitialFailed(NETWORK_NO_FILL);
    }

    @Override
    public void onAudioStarted() {
    }

    @Override
    public void onAudioFinished() {
    }
}
