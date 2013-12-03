package tv.hromadske.app;

import tv.hromadske.app.fragments.FragmentAbout;
import tv.hromadske.app.fragments.FragmentWeb;
import tv.hromadske.app.utils.SystemUtils;
import android.app.ActionBar;
import android.app.ActionBar.Tab;
import android.app.Activity;
import android.app.FragmentTransaction;
import android.content.Intent;
import android.net.Uri;
import android.os.AsyncTask;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.widget.Toast;

public class MainActivity extends Activity implements ActionBar.TabListener {
	private final String urlHome = "http://hromadske.tv/";
	private final String urlVideos = "http://hromadske.tv/video/";
	private final String urlInterview = "http://hromadske.tv/interview/";
	private final String urlPrograms = "http://hromadske.tv/programs/";
	private final String urlAbout = "http://hromadske.tv/about/";

	private FragmentWeb fragmentHome = new FragmentWeb(urlHome);
	private FragmentWeb fragmentVideoNews = new FragmentWeb(urlVideos);
	private FragmentWeb fragmentInterview = new FragmentWeb(urlInterview);
	private FragmentWeb fragmentPrograms = new FragmentWeb(urlPrograms);
	private FragmentWeb fragmentAbout = new FragmentWeb(urlAbout);
	private boolean exitApp = false;
	private int pos = 0;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_main);
		ActionBar bar = getActionBar();

		if (savedInstanceState != null) {
			pos = savedInstanceState.getInt("pos");
		}

		bar.setHomeButtonEnabled(true);

		Tab tab = bar.newTab();
		tab.setText(R.string.main_tab);
		tab.setTabListener(this);
		bar.addTab(tab);

		tab = bar.newTab();
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
		bar.setNavigationMode(ActionBar.NAVIGATION_MODE_TABS);
		bar.setSelectedNavigationItem(pos);
	}

	@Override
	protected void onSaveInstanceState(Bundle outState) {
		super.onSaveInstanceState(outState);
		outState.putInt("pos", getActionBar().getSelectedNavigationIndex());
	}

	@Override
	public void onTabSelected(Tab tab, FragmentTransaction ft) {
		switch (tab.getPosition()) {
		case 0:
			ft.replace(R.id.fragment_container, fragmentHome);
			break;
		case 1:
			ft.replace(R.id.fragment_container, fragmentVideoNews);
			break;
		case 2:
			ft.replace(R.id.fragment_container, fragmentInterview);
			break;
		case 3:
			ft.replace(R.id.fragment_container, fragmentPrograms);
			break;
		case 4:
			ft.replace(R.id.fragment_container, fragmentAbout);
			break;

		default:
			break;
		}
	}

	@Override
	public void onTabReselected(Tab tab, FragmentTransaction ft) {
	}

	@Override
	public void onTabUnselected(Tab tab, FragmentTransaction ft) {
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
		case android.R.id.home:
			getActionBar().setSelectedNavigationItem(0);
			break;
		case R.id.action_help:
			startActivity(new Intent(Intent.ACTION_VIEW,
					Uri.parse("http://hromadske.tv/donate")));
			break;
		case R.id.action_youtube:
			startActivity(new Intent(
					Intent.ACTION_VIEW,
					Uri.parse("http://www.youtube.com/user/HromadskeTV/featured")));
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
		case R.id.action_about:
			FragmentAbout fragmentAbout = new FragmentAbout();
			fragmentAbout.show(getFragmentManager(), "about");
			break;
		default:
			break;
		}
		return super.onOptionsItemSelected(item);
	}
	
	private class TimeOutTask extends AsyncTask<Void, Void, Boolean> {

		@Override
		protected Boolean doInBackground(Void... params) {
			try {
				Thread.sleep(SystemUtils.EXIT_DELAY);
			} catch (InterruptedException e) {
				e.printStackTrace();
			}
			exitApp = false;
			return true;
		}
	}

	@Override
	public void onBackPressed() {
		if (!exitApp) {
			Toast.makeText(this, R.string.exit_text, Toast.LENGTH_SHORT).show();
			exitApp = true;
			new TimeOutTask().execute();
		} else {
			super.onBackPressed();
		}
	}
}