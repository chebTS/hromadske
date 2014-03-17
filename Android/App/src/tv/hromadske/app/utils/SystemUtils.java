package tv.hromadske.app.utils;

import java.io.InputStream;
import java.io.InputStreamReader;

import android.content.Context;
import android.content.pm.PackageManager;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;

public class SystemUtils {
	public static final String DEVELOPER_KEY = "AIzaSyAaJn6jFeISxXx1qPH4I2Kfk1_pDJABGfk";
	/*
	 * dev AIzaSyAn9DDnBL7i6Chq2myHvU3YQEGVnGtDJlA public static final String
	 * DEVELOPER_KEY = "AIzaSyAn9DDnBL7i6Chq2myHvU3YQEGVnGtDJlA";
	 */
	public static final int EXIT_DELAY = 2000;
	public static final String UKR_URL = "ukr_url";
	public static final String GDATA_URL = "http://gdata.youtube.com/feeds/api/users/HromadskeTV/live/events?v=2&status=active&fields=entry(content)&alt=json";
	// String s =
	// "http://gdata.youtube.com/feeds/api/users/HromadskeTV/live/events?v=2&status=active&fields=entry%28content%29&alt=json";
	// productDetails+=String.format("%-20s%10.2s%10s",this.name,this.banner);

	public static final String STREAMS_URL = "http://hrom.fedr.co/streams";
	public static final String DEVICES_URL = "http://hrom.fedr.co/devices";

	public static boolean isAppInstalledOrNot(String uri, Context context) {
		PackageManager pm = context.getPackageManager();
		boolean app_installed = false;
		try {
			pm.getPackageInfo(uri, PackageManager.GET_ACTIVITIES);
			app_installed = true;
		} catch (PackageManager.NameNotFoundException e) {
			app_installed = false;
		}
		return app_installed;
	}

	public static String streamToString(InputStream content) throws Exception {
		StringBuilder stringBuffer = new StringBuilder();
		InputStreamReader inputStreamReader = new InputStreamReader(content);
		char[] buffer = new char[1];
		while (inputStreamReader.read(buffer) != -1) {
			stringBuffer.append(buffer);
		}
		content.close();
		return stringBuffer.toString();
	}

	public static boolean isOnline(Context context) {
		ConnectivityManager cm = (ConnectivityManager) context.getSystemService(Context.CONNECTIVITY_SERVICE);
		NetworkInfo netInfo = cm.getActiveNetworkInfo();
		if (netInfo != null && netInfo.isConnectedOrConnecting()) {
			return true;
		}
		return false;
	}
}
