package tv.hromadske.app;

import tv.hromadske.app.utils.SystemUtils;
import android.app.ActionBar;
import android.app.ActionBar.Tab;
import android.app.Activity;
import android.app.FragmentTransaction;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;

public class MainActivity extends Activity implements ActionBar.TabListener {

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_main);
		ActionBar bar = getActionBar();

		bar.setNavigationMode(ActionBar.NAVIGATION_MODE_TABS);
		Tab tab = bar.newTab();
		tab.setText(R.string.videonews);
		tab.setTabListener(this);
		bar.addTab(tab);

		tab = bar.newTab();
		tab.setText(R.string.interview);
		tab.setTabListener(this);
		bar.addTab(tab);

		tab = bar.newTab();
		tab.setText(R.string.programs);
		tab.setTabListener(this);
		bar.addTab(tab);

		tab = bar.newTab();
		tab.setText(R.string.about_project);
		tab.setTabListener(this);
		bar.addTab(tab);

	}

	@Override
	public void onTabReselected(Tab tab, FragmentTransaction ft) {
		// TODO Auto-generated method stub

	}

	@Override
	public void onTabSelected(Tab tab, FragmentTransaction ft) {
		// TODO Auto-generated method stub

	}

	@Override
	public void onTabUnselected(Tab tab, FragmentTransaction ft) {
		// TODO Auto-generated method stub

	}

	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
		MenuInflater inflater = getMenuInflater();
		inflater.inflate(R.menu.main, menu);
		return true;
	}

	@Override
	public boolean onOptionsItemSelected(MenuItem item) {
		switch (item.getItemId()) {
		case R.id.action_help:
			startActivity(new Intent(Intent.ACTION_VIEW,
					Uri.parse("http://hromadske.tv/donate")));
			break;
		case R.id.action_twitter:
			startActivity(new Intent(Intent.ACTION_VIEW,
					Uri.parse("https://twitter.com/HromadskeTV")));
			break;
		case R.id.action_facebook:
			if (SystemUtils.isAppInstalledOrNot("com.facebook.katana", this)) {
				String facebookScheme = "fb://profile/594022430618124";
				Intent facebookIntent = new Intent(Intent.ACTION_VIEW,
						Uri.parse(facebookScheme));
				startActivity(facebookIntent);
			} else {
				startActivity(new Intent("android.intent.action.VIEW",
						Uri.parse("https://www.facebook.com/hromadsketv")));
			}
			break;
		case R.id.action_rss:
			startActivity(new Intent(Intent.ACTION_VIEW,
					Uri.parse("http://hromadske.tv/rss")));
			break;
		case R.id.action_plus:
			startActivity(new Intent(
					Intent.ACTION_VIEW,
					Uri.parse("https://plus.google.com/u/0/+HromadskeTvUkraine/posts")));
			break;
		case R.id.action_mail:
			Intent testIntent = new Intent(Intent.ACTION_VIEW);
			Uri data = Uri.parse("mailto:?subject=" + "From Android app"
					+ "&body= " + "&to=" + "hromadsketv@gmail.com");
			testIntent.setData(data);
			startActivity(testIntent);
			break;
		default:
			break;
		}
		return super.onOptionsItemSelected(item);
	}
}
