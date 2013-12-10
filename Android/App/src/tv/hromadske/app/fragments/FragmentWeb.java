package tv.hromadske.app.fragments;

import tv.hromadske.app.R;
import android.app.Fragment;
import android.content.Intent;
import android.graphics.Bitmap;
import android.net.Uri;
import android.os.Bundle;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.webkit.WebChromeClient;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.ProgressBar;

public class FragmentWeb extends Fragment {
	private String url;
	private ProgressBar progressBar;

	public FragmentWeb() {
		super();
	}

	public FragmentWeb(String url) {
		super();
		this.url = url;
	}

	@Override
	public View onCreateView(LayoutInflater inflater, ViewGroup container,
			Bundle savedInstanceState) {
		View v = inflater.inflate(R.layout.fragment_tab, null, false);
		progressBar = (ProgressBar) v.findViewById(R.id.progressBar);
		WebView wv = (WebView) v.findViewById(R.id.web);
		wv.setWebChromeClient(new WebChromeClient() {});
		WebSettings settings = wv.getSettings();
		settings.setBuiltInZoomControls(true);
		settings.setSupportZoom(true);
		settings.setUseWideViewPort(true);
		settings.setJavaScriptEnabled(true);
		settings.setLoadWithOverviewMode(true);
		wv.setWebViewClient(new CustomWebViewClient());
		wv.loadUrl(url);
		return v;
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

		@Override
		public void onPageStarted(WebView view, String url, Bitmap favicon) {
			super.onPageStarted(view, url, favicon);
			progressBar.setVisibility(View.VISIBLE);
		}
		
	
		@Override
		public void onPageFinished(WebView view, String url) {
			super.onPageFinished(view, url);
			progressBar.setVisibility(View.GONE);
		}
	}
}