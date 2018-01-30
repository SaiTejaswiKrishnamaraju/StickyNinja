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

package com.heyzap.integrations;

import java.util.Map;

import android.content.Context;
import android.util.Log;
import android.view.View;
import android.app.Activity;

import com.burstly.lib.component.IBurstlyAdaptor;
import com.burstly.lib.component.IBurstlyAdaptorListener;
import com.burstly.lib.ui.BurstlyView;
import com.heyzap.sdk.ads.HeyzapAds;
import com.heyzap.sdk.ads.InterstitialAd;
import com.heyzap.sdk.ads.HeyzapAds.OnStatusListener;

/**
 * Burstly Integration of Heyzap's Ad Platform.
 * 
 * Burstly's sample integration code/documentation:
 * https://github.com/burstly/Android-AdaptorIntegrationSample
 */
public class HeyzapAdaptor implements IBurstlyAdaptor {

    public static final String VERSION = "1.0.2";

    /**
     * does the app have focus?
     */
    private boolean isAppRunning = true;

    /**
     * Adaptor name received from server.
     */
    private String adaptorName;

    /**
     * Currents context. Strong reference is safe, because adaptors are being destroyed on
     * {@link BurstlyView#destroy()}.
     */
    Context context;

    /**
     * Listener used to inform BurstlySDK about the state of the integrated library.
     */
    public static volatile IBurstlyAdaptorListener adaptorListener;

    /**
     * Constructs a new {@link HeyzapAdaptor} instance.
     */
    public HeyzapAdaptor(final Context context, final String viewId, final String adaptorName) {
        this.context = context;
        this.adaptorName = adaptorName != null ? adaptorName : "heyzap";

        // initialize SDK
        HeyzapAds.mediator = "burstly";
        HeyzapAds.start((Activity)context, HeyzapAds.DISABLE_AUTOMATIC_FETCH, new HeyzapAds.OnStatusListener() {
            @Override
            public void onShow(String tag) {
                Log.i("HeyzapAdaptor", "onShow");
                adaptorListener.didLoad(getNetworkName(), true);
                adaptorListener.shownFullscreen(new IBurstlyAdaptorListener.FullscreenInfo(getNetworkName(), true));
            }

            @Override
            public void onClick(String tag) {
                Log.i("HeyzapAdaptor", "onClick");
                adaptorListener.adWasClicked(getNetworkName(), true);
            }

            @Override
            public void onHide(String tag) {
                Log.i("HeyzapAdaptor", "onHide");
                adaptorListener.dismissedFullscreen(new IBurstlyAdaptorListener.FullscreenInfo(getNetworkName(), true));
            }

            @Override
            public void onFailedToShow(String tag) {
                Log.i("HeyzapAdaptor", "onFailedToShow");
                adaptorListener.failedToLoad(getNetworkName(), true, "Could not show ad."); 
            }

            @Override
            public void onAvailable(String tag) {
                Log.i("HeyzapAdaptor", "onAvailable");
                if (InterstitialAd.isAvailable()) {
                    adaptorListener.didLoad(getNetworkName(), true);
                } else {
                    Log.i("HeyzapAdaptor", "onAvailable: ad not yet available");
                }
            }

            @Override
            public void onFailedToFetch(String tag) {
                Log.i("HeyzapAdaptor", "onFailedToFetch");
                adaptorListener.failedToLoad(getNetworkName(), true, "Could not fetch ad."); 
            }

            @Override
            public void onAudioStarted() {}

            @Override
            public void onAudioFinished() {}
        });

        Log.i("HeyzapAdaptor", "HeyzapAdaptor constructor, adaptorName: " + adaptorName);
    }

    /**
     *
     * IBurstlyAdaptor implementation:
     *
     */

    @Override
    public void startTransaction(final Map<String, ?> paramsFromServer) throws IllegalArgumentException {
        if (paramsFromServer == null) {
            throw new IllegalArgumentException("Parameters from server cannot be null.");
        }
        Log.i("HeyzapAdaptor", "startTransaction");
        
        isAppRunning = true;
    }

    @Override
    public void precacheInterstitialAd() {
        Log.i("HeyzapAdaptor", "precacheInterstitialAd");
        InterstitialAd.fetch();
    }

    @Override
    public void showPrecachedInterstitialAd() {
        Log.i("HeyzapAdaptor", "showPrecachedInterstitialAd: " + isAppRunning);
        // try to show the pre-cached ad:
        if (InterstitialAd.isAvailable() && isAppRunning) {
            InterstitialAd.display((Activity)context);
        } else {
            Log.i("HeyzapAdaptor", "showPrecachedInterstitialAd: failedToLoad");
            adaptorListener.failedToLoad(getNetworkName(), true, "No precached ad.");
        }
    }

    @Override
    public BurstlyAdType getAdType() {
        return BurstlyAdType.INTERSTITIAL_AD_TYPE;
    }

    @Override
    public String getNetworkName() {
        return adaptorName;
    }

    @Override
    public boolean supports(final String action) {
        // Android-AdaptorIntegrationSample/BurstlySDK_Android_1.20.0.35106/docs/com/burstly/lib/component/IBurstlyAdaptor.html:
        // "Queries the adaptor for supported actions. Currently supported actions are: precacheInterstitial"
        return action.equals(AdaptorAction.PRECACHE_INTERSTITIAL.getCode()); // support precacheInterstial
    }

    @Override
    public void setAdaptorListener(final IBurstlyAdaptorListener listener) {
        if (listener == null) {
            Log.w("HeyzapAdaptor", "IBurstlyAdaptorListener should not be null.");
        }
        adaptorListener = listener;
    }

    @Override
    public View getNewAd() {
        Log.i("HeyzapAdaptor", "getNewAd");

        // method should return null for interstitials
        return null;
    }

    @Override
    public View precacheAd() {
        Log.i("HeyzapAdaptor", "precacheAd");

        InterstitialAd.fetch();
        
        return null;
    }

    @Override
    public void destroy() {
        Log.i("HeyzapAdaptor", "destroy");
        InterstitialAd.dismiss();
        
        isAppRunning = false;

        context = null;
    }

    @Override
    public void pause() {
        Log.i("HeyzapAdaptor", "pause");
        
        isAppRunning = false;

        InterstitialAd.dismiss();
    }

    @Override
    public void stop() {
        Log.i("HeyzapAdaptor", "stop");
        
        isAppRunning = false;
    }

    @Override
    public void resume() {
        Log.i("HeyzapAdaptor", "resume");
        
        isAppRunning = true;
    }

    @Override
    public void startViewSession() {
        Log.i("HeyzapAdaptor", "startViewSession");
    }

    @Override
    public void endViewSession() {
        Log.i("HeyzapAdaptor", "endViewSession");
    }

    @Override
    public void endTransaction(final TransactionCode endCode) {
        Log.i("HeyzapAdaptor", "endTransaction, code: " + endCode.name());
    }
}