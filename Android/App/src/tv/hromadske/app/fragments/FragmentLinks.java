package tv.hromadske.app.fragments;

import com.google.analytics.tracking.android.EasyTracker;
import com.google.analytics.tracking.android.Fields;
import com.google.analytics.tracking.android.MapBuilder;
import com.google.analytics.tracking.android.Tracker;

import tv.hromadske.app.R;
import tv.hromadske.app.utils.SystemUtils;
import android.app.Fragment;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.Button;

public class FragmentLinks extends Fragment implements OnClickListener {

	public FragmentLinks() {
		super();
	}

	@Override
	public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
		View v = inflater.inflate(R.layout.fragment_links, null, false);

		((Button) v.findViewById(R.id.btn_youtube)).setOnClickListener(this);
		((Button) v.findViewById(R.id.btn_help)).setOnClickListener(this);
		((Button) v.findViewById(R.id.btn_twitter)).setOnClickListener(this);
		((Button) v.findViewById(R.id.btn_facebook)).setOnClickListener(this);
		((Button) v.findViewById(R.id.btn_rss)).setOnClickListener(this);
		((Button) v.findViewById(R.id.btn_g_plus)).setOnClickListener(this);
		((Button) v.findViewById(R.id.btn_email)).setOnClickListener(this);
		return v;
	}
	
	@Override
	public void onStart() {
		super.onStart();
		Tracker tracker = EasyTracker.getInstance(getActivity());
		tracker.set(Fields.SCREEN_NAME, "Links");
		tracker.send(MapBuilder.createAppView().build());
	}

	@Override
	public void onClick(View v) {
		switch (v.getId()) {
		case R.id.btn_youtube:
			startActivity(new Intent(Intent.ACTION_VIEW, Uri.parse("http://www.youtube.com/user/HromadskeTV/featured")));
			break;
		case R.id.btn_help:
			startActivity(new Intent(Intent.ACTION_VIEW, Uri.parse("http://hromadske.tv/donate")));
			break;
		case R.id.btn_twitter:
			startActivity(new Intent(Intent.ACTION_VIEW, Uri.parse("https://twitter.com/HromadskeTV")));
			break;
		case R.id.btn_facebook:
			if (SystemUtils.isAppInstalledOrNot("com.facebook.katana", getActivity())) {
				String facebookScheme = "fb://profile/594022430618124";
				Intent facebookIntent = new Intent(Intent.ACTION_VIEW, Uri.parse(facebookScheme));
				startActivity(facebookIntent);
			} else {
				startActivity(new Intent("android.intent.action.VIEW", Uri.parse("https://www.facebook.com/hromadsketv")));
			}
			break;
		case R.id.btn_rss:
			startActivity(new Intent(Intent.ACTION_VIEW, Uri.parse("http://hromadske.tv/rss")));
			break;
		case R.id.btn_g_plus:
			startActivity(new Intent(Intent.ACTION_VIEW, Uri.parse("https://plus.google.com/u/0/+HromadskeTvUkraine/posts")));
			break;
		case R.id.btn_email:
			Intent testIntent = new Intent(Intent.ACTION_VIEW);
			Uri data = Uri.parse("mailto:?subject=" + "From Android app" + "&body= " + "&to=" + "hromadsketv@gmail.com");
			testIntent.setData(data);
			startActivity(testIntent);
			break;
		default:
			break;
		}
	}
}