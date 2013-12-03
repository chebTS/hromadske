package tv.hromadske.app.utils;

import android.content.Context;
import android.content.pm.PackageManager;

public class SystemUtils {
	public static final int EXIT_DELAY = 2000;
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
