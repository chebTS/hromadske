package tv.hromadske.app;

import java.io.IOException;
import java.util.concurrent.atomic.AtomicInteger;

import org.apache.http.HttpResponse;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.DefaultHttpClient;
import org.json.JSONObject;

import tv.hromadske.app.fragments.FragmentAbout;
import tv.hromadske.app.fragments.FragmentLinks;
import tv.hromadske.app.fragments.FragmentVideos;
import tv.hromadske.app.fragments.FragmentWeb;
import tv.hromadske.app.utils.SystemUtils;
import android.app.ActionBar;
import android.app.ActionBar.Tab;
import android.app.Activity;
import android.app.FragmentTransaction;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager.NameNotFoundException;
import android.net.Uri;
import android.os.AsyncTask;
import android.os.Bundle;
import android.util.Log;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.widget.ShareActionProvider;
import android.widget.Toast;
import com.google.analytics.tracking.android.EasyTracker;
import com.google.android.gms.common.ConnectionResult;
import com.google.android.gms.common.GooglePlayServicesUtil;
import com.google.android.gms.gcm.GoogleCloudMessaging;

public class MainActivity extends Activity implements ActionBar.TabListener {
	private final String urlSite = "http://hromadske.tv/";

	private FragmentVideos fragmentVideos = new FragmentVideos();
	private FragmentWeb fragmentSite = new FragmentWeb();
	private FragmentLinks fragmentLinks = new FragmentLinks();
	private boolean exitApp = false;
	private int pos = 0;
	private ShareActionProvider mShareActionProvider;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		
		Bundle args = new Bundle();
	    args.putString("url", urlSite);
		fragmentSite.setArguments(args);
		
		setContentView(R.layout.activity_main);
		ActionBar bar = getActionBar();

		if (savedInstanceState != null) {
			pos = savedInstanceState.getInt("pos");
		}

		Tab tab = bar.newTab();
		tab.setText(R.string.main_tab);
		tab.setTabListener(this);
		bar.addTab(tab);

		tab = bar.newTab();
		tab.setText(R.string.online_tab);
		tab.setTabListener(this);
		bar.addTab(tab);

		tab = bar.newTab();
		tab.setText(R.string.share_tab);
		tab.setTabListener(this);
		bar.addTab(tab);

		bar.setNavigationMode(ActionBar.NAVIGATION_MODE_TABS);
		bar.setSelectedNavigationItem(pos);
		
		setupPush();
	}
	
	@Override
	public void onStart() {
		super.onStart();
		EasyTracker.getInstance(this).activityStart(this);
	}

	@Override
	public void onStop() {
		super.onStop();
		EasyTracker.getInstance(this).activityStop(this);
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
			ft.replace(R.id.fragment_container, fragmentVideos);
			break;
		case 1:
			ft.replace(R.id.fragment_container, fragmentSite);
			break;
		case 2:
			ft.replace(R.id.fragment_container, fragmentLinks);
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
		inflater.inflate(R.menu.main2, menu);
		mShareActionProvider = (ShareActionProvider) menu.findItem(R.id.action_share).getActionProvider();
		mShareActionProvider.setShareIntent(creatShareIntent());
		return true;
	}

	private Intent creatShareIntent() {
		Intent shareIntent = new Intent(Intent.ACTION_SEND);
		shareIntent.setAction(Intent.ACTION_SEND);
		shareIntent.setType("text/plain");
		shareIntent.putExtra(Intent.EXTRA_TEXT, " " + getResources().getString(R.string.share_text));
		return shareIntent;
	}

	@Override
	public boolean onOptionsItemSelected(MenuItem item) {
		switch (item.getItemId()) {
		case R.id.action_help:
			startActivity(new Intent(Intent.ACTION_VIEW, Uri.parse("http://hromadske.tv/donate")));
			break;
		case R.id.action_youtube:
			startActivity(new Intent(Intent.ACTION_VIEW, Uri.parse("http://www.youtube.com/user/HromadskeTV/featured")));
			break;
		case R.id.action_twitter:
			startActivity(new Intent(Intent.ACTION_VIEW, Uri.parse("https://twitter.com/HromadskeTV")));
			break;
		case R.id.action_facebook:
			if (SystemUtils.isAppInstalledOrNot("com.facebook.katana", this)) {
				String facebookScheme = "fb://profile/594022430618124";
				Intent facebookIntent = new Intent(Intent.ACTION_VIEW, Uri.parse(facebookScheme));
				startActivity(facebookIntent);
			} else {
				startActivity(new Intent("android.intent.action.VIEW", Uri.parse("https://www.facebook.com/hromadsketv")));
			}
			break;
		case R.id.action_rss:
			startActivity(new Intent(Intent.ACTION_VIEW, Uri.parse("http://hromadske.tv/rss")));
			break;
		case R.id.action_plus:
			startActivity(new Intent(Intent.ACTION_VIEW, Uri.parse("https://plus.google.com/u/0/+HromadskeTvUkraine/posts")));
			break;
		case R.id.action_mail:
			Intent testIntent = new Intent(Intent.ACTION_VIEW);
			Uri data = Uri.parse("mailto:?subject=" + "From Android app" + "&body= " + "&to=" + "hromadsketv@gmail.com");
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
	
	String SENDER_ID = "793511091375";
	public static final String PROPERTY_REG_ID = "registration_id";
    private static final String PROPERTY_APP_VERSION = "appVersion";
    static final String TAG = "Hrom";
    GoogleCloudMessaging gcm;
    String regid;
    Context context;
    AtomicInteger msgId = new AtomicInteger();
    
    protected void setupPush() {
    	if (checkPlayServices()) {
    		context = getApplicationContext();
			gcm = GoogleCloudMessaging.getInstance(this);
			regid = getRegistrationId(context);

            if (regid.isEmpty()) {
                registerInBackground();
            }
	    }
    }
	
	private boolean checkPlayServices() {
	    return GooglePlayServicesUtil.isGooglePlayServicesAvailable(this) == ConnectionResult.SUCCESS;
	}
	
	/**
	 * Gets the current registration ID for application on GCM service.
	 * <p>
	 * If result is empty, the app needs to register.
	 *
	 * @return registration ID, or empty string if there is no existing
	 *         registration ID.
	 */
	private String getRegistrationId(Context context) {
	    final SharedPreferences prefs = getGCMPreferences(context);
	    String registrationId = prefs.getString(PROPERTY_REG_ID, "");
	    if (registrationId.isEmpty()) {
	        Log.i(TAG, "Registration not found.");
	        return "";
	    }
	    // Check if app was updated; if so, it must clear the registration ID
	    // since the existing regID is not guaranteed to work with the new
	    // app version.
	    int registeredVersion = prefs.getInt(PROPERTY_APP_VERSION, Integer.MIN_VALUE);
	    int currentVersion = getAppVersion(context);
	    if (registeredVersion != currentVersion) {
	        Log.i(TAG, "App version changed.");
	        return "";
	    }
	    return registrationId;
	}
	
	/**
	 * Stores the registration ID and app versionCode in the application's
	 * {@code SharedPreferences}.
	 *
	 * @param context application's context.
	 * @param regId registration ID
	 */
	private void storeRegistrationId(Context context, String regId) {
	    final SharedPreferences prefs = getGCMPreferences(context);
	    int appVersion = getAppVersion(context);
	    Log.i(TAG, "Saving regId on app version " + appVersion);
	    SharedPreferences.Editor editor = prefs.edit();
	    editor.putString(PROPERTY_REG_ID, regId);
	    editor.putInt(PROPERTY_APP_VERSION, appVersion);
	    editor.commit();
	}
	
	/**
	 * @return Application's {@code SharedPreferences}.
	 */
	private SharedPreferences getGCMPreferences(Context context) {
	    // This sample app persists the registration ID in shared preferences, but
	    // how you store the regID in your app is up to you.
	    return getSharedPreferences(MainActivity.class.getSimpleName(),
	            Context.MODE_PRIVATE);
	}
	
	/**
	 * @return Application's version code from the {@code PackageManager}.
	 */
	private static int getAppVersion(Context context) {
	    try {
	        PackageInfo packageInfo = context.getPackageManager()
	                .getPackageInfo(context.getPackageName(), 0);
	        return packageInfo.versionCode;
	    } catch (NameNotFoundException e) {
	        // should never happen
	        throw new RuntimeException("Could not get package name: " + e);
	    }
	}
	
	/**
	 * Registers the application with GCM servers asynchronously.
	 * <p>
	 * Stores the registration ID and app versionCode in the application's
	 * shared preferences.
	 */
	private void registerInBackground() {
	    new AsyncTask<Void, Void, String>() {
	        @Override
	        protected String doInBackground(Void... params) {
	            String msg = "";
	            try {
	                if (gcm == null) {
	                    gcm = GoogleCloudMessaging.getInstance(context);
	                }
	                regid = gcm.register(SENDER_ID);
	                msg = "Device registered, registration ID=" + regid;

	                // You should send the registration ID to your server over HTTP,
	                // so it can use GCM/HTTP or CCS to send messages to your app.
	                // The request to your server should be authenticated if your app
	                // is using accounts.
	                sendRegistrationIdToBackend();

	                // For this demo: we don't need to send it because the device
	                // will send upstream messages to a server that echo back the
	                // message using the 'from' address in the message.

	                // Persist the regID - no need to register again.
	                storeRegistrationId(context, regid);
	            } catch (IOException ex) {
	                msg = "Error :" + ex.getMessage();
	                // If there is an error, don't just keep trying to register.
	                // Require the user to click a button again, or perform
	                // exponential back-off.
	            }
	            return msg;
	        }

	        @Override
	        protected void onPostExecute(String msg) {
	            Log.i(TAG, msg);
	        }
	    }.execute(null, null, null);
	}
	
	/**
	 * Sends the registration ID to your server over HTTP, so it can use GCM/HTTP
	 * or CCS to send messages to your app. Not needed for this demo since the
	 * device sends upstream messages to a server that echoes back the message
	 * using the 'from' address in the message.
	 */
	private void sendRegistrationIdToBackend() {
		try {
			HttpPost httpPost = new HttpPost(SystemUtils.DEVICES_URL);
			JSONObject json = new JSONObject();
			json.put("deviceID", regid);
			json.put("platform", "android");
			httpPost.setEntity(new StringEntity(json.toString(), "UTF8"));
	        httpPost.setHeader("Content-type", "application/json");
	        
			DefaultHttpClient mHttpClient = new DefaultHttpClient();
			mHttpClient.execute(httpPost);
		}
		catch(IOException e) {
			Log.i(TAG, e.getMessage());
		}
		catch(Exception e) { // Catch JSON Exceptions
			Log.i(TAG, e.getMessage());
		}
	}
}