package tv.hromadske.app.fragments;

import tv.hromadske.app.R;
import android.app.Fragment;
import android.content.Intent;
import android.graphics.Bitmap;
import android.net.Uri;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.webkit.WebBackForwardList;
import android.webkit.WebChromeClient;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.ImageButton;
import android.widget.ProgressBar;

public class FragmentWeb extends Fragment implements OnClickListener {
	private String url;
	private ProgressBar progressBar;
	private ImageButton btnBack, btnForward, btnRefresh;
	private Boolean isLoading;
	private WebView wv;
	private WebBackForwardList mWebBackForwardList;

	public FragmentWeb() {
		super();
	}

	public FragmentWeb(String url) {
		super();
		this.url = url;
	}

	@Override
	public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
		View v = inflater.inflate(R.layout.fragment_site, null, false);
		progressBar = (ProgressBar) v.findViewById(R.id.progressBar);
		wv = (WebView) v.findViewById(R.id.web);
		wv.setWebChromeClient(new WebChromeClient() {
		});
		WebSettings settings = wv.getSettings();
		settings.setBuiltInZoomControls(true);
		settings.setSupportZoom(true);
		settings.setUseWideViewPort(true);
		settings.setJavaScriptEnabled(true);
		settings.setLoadWithOverviewMode(true);
		wv.setWebViewClient(new CustomWebViewClient());
		wv.loadUrl(url);
		btnBack = (ImageButton) v.findViewById(R.id.btnBack);
		btnBack.setOnClickListener(this);
		btnForward = (ImageButton) v.findViewById(R.id.btnForward);
		btnForward.setOnClickListener(this);
		btnRefresh = (ImageButton) v.findViewById(R.id.btnReload);
		btnRefresh.setOnClickListener(this);
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
			isLoading = true;
			btnRefresh.setBackgroundResource(R.drawable.ic_menu_stop);
		}

		@Override
		public void onPageFinished(WebView view, String url) {
			super.onPageFinished(view, url);
			progressBar.setVisibility(View.GONE);
			isLoading = false;
			btnRefresh.setBackgroundResource(R.drawable.ic_menu_refresh);
			mWebBackForwardList = view.copyBackForwardList();
			checkStack();
		}
	}

	@Override
	public void onClick(View v) {
		switch (v.getId()) {
		case R.id.container_browser:
			//just for bg
			break;
		case R.id.btnBack:
			wv.goBack();
			break;
		case R.id.btnForward:
			wv.goForward();
			break;
		case R.id.btnReload:
			if (isLoading) {
				wv.stopLoading();
			} else {
				wv.reload();
			}
			break;
		default:
			break;
		}
	}

	private void checkStack() {
		int curIndex, size;
		if (mWebBackForwardList != null) {
			curIndex = mWebBackForwardList.getCurrentIndex();
			size = mWebBackForwardList.getSize();
			if (mWebBackForwardList.getSize() > 1) {
				if (curIndex > 0) {
					btnBack.setEnabled(true);
				} else {
					btnBack.setEnabled(false);
				}
				if (curIndex < (size - 1)) {
					btnForward.setEnabled(true);
				} else {
					btnForward.setEnabled(false);
				}
			}
		}
	}
}