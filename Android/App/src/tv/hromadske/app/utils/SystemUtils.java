package tv.hromadske.app.utils;

import android.content.Context;
import android.content.pm.PackageManager;

public class SystemUtils {
	public static final String DEVELOPER_KEY = "AIzaSyAn9DDnBL7i6Chq2myHvU3YQEGVnGtDJlA";
	public static final int EXIT_DELAY = 2000;
	public static final String UKR_URL = "ukr_url";
	

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
}
