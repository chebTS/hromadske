package tv.hromadske.app.fragments;

import android.app.Fragment;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.webkit.WebView;
import android.webkit.WebViewClient;

public class FragmentWeb extends Fragment {
	private String url;

	public FragmentWeb(String url) {
		super();
		this.url = url;
	}

	@Override
	public View onCreateView(LayoutInflater inflater, ViewGroup container,
			Bundle savedInstanceState) {
		WebView wv = new WebView(getActivity());
		wv.getSettings().setBuiltInZoomControls(true);
		wv.getSettings().setSupportZoom(true);
		wv.getSettings().setUseWideViewPort(true);
		wv.getSettings().setJavaScriptEnabled(true);
		wv.getSettings().setLoadWithOverviewMode(true);
		wv.setWebViewClient(new CustomWebViewClient());
		wv.loadUrl(url);
		return wv;
	}

	private class CustomWebViewClient extends WebViewClient {
		@Override
		public boolean shouldOverrideUrlLoading(WebView view, String url) {
			if (url.contains("hromadske.tv")) {
				view.loadUrl(url);
			} else {
				startActivity(new Intent(Intent.ACTION_VIEW, Uri.parse(url)));
			}
			return true;
		}
	}
}
