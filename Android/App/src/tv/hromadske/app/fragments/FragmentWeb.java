package tv.hromadske.app.fragments;

import android.app.Fragment;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.webkit.WebView;

public class FragmentWeb extends Fragment {
	private String url;
	
	public FragmentWeb(String url) {
		super();
		this.url = url;
	}

	@Override
	public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
		WebView wv = new WebView(getActivity());
		wv.getSettings().setBuiltInZoomControls(true);
		wv.getSettings().setSupportZoom(true); 
		wv.getSettings().setUseWideViewPort(true);
		wv.getSettings().setLoadWithOverviewMode(true);
		wv.loadUrl(url);
		return wv;
	}
}
