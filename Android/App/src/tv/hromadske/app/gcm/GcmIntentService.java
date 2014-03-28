package tv.hromadske.app.gcm;

import tv.hromadske.app.MainActivity;
import tv.hromadske.app.R;
import tv.hromadske.app.utils.SystemUtils;

import com.google.android.gms.gcm.GoogleCloudMessaging;

import android.app.IntentService;
import android.app.Notification;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;
import android.graphics.BitmapFactory;
import android.net.Uri;
import android.os.Bundle;
import android.support.v4.app.NotificationCompat;
import android.util.Log;

public class GcmIntentService extends IntentService {

	private static final String TAG = "HromGCM";
	public static int notificationId = 1;
	private NotificationManager mNotificationManager;
	NotificationCompat.Builder builder;

	public GcmIntentService() {
		super("GcmIntentService");
	}

	@Override
	protected void onHandleIntent(Intent intent) {
		Bundle extras = intent.getExtras();
		GoogleCloudMessaging gcm = GoogleCloudMessaging.getInstance(this);
		String messageType = gcm.getMessageType(intent);

		if (getPushEnabled() && !extras.isEmpty()) { // has effect of unparcelling Bundle
			if (GoogleCloudMessaging.MESSAGE_TYPE_MESSAGE.equals(messageType)) {
				mNotificationManager = (NotificationManager) this.getSystemService(Context.NOTIFICATION_SERVICE);
				Intent hromIndent = new Intent(this, MainActivity.class);
				String msg = extras.getString("message");
				Intent urlIntent = null;
				if (extras.containsKey("u")) {
					urlIntent = new Intent(Intent.ACTION_VIEW);
					urlIntent.setData(Uri.parse(extras.getString("u")));
					if (msg == null) {
						msg = extras.getString("u");
					}
				} else if (extras.containsKey("i")) {
					urlIntent = new Intent(Intent.ACTION_VIEW);
					if (SystemUtils.isAppInstalledOrNot("com.twitter.android", this)) {
						urlIntent.setData(Uri.parse("twitter://status?status_id=" + extras.getString("i")));
					}
					else {
						urlIntent.setData(Uri.parse("https://twitter.com/HromadskeTV/status/" + extras.getString("i")));
					}
					if (msg == null) {
						msg = extras.getString("https://twitter.com/status/" + extras.getString("i"));
					}
				} else {
					urlIntent = hromIndent;
				}

				if (msg != null) {					
					NotificationCompat.Builder mBuilder = new NotificationCompat.Builder(this)
							.setSmallIcon(R.drawable.logo_notification)
							.setLargeIcon(BitmapFactory.decodeResource(getResources(), R.drawable.ic_launcher))
							.setContentTitle(getApplicationContext().getString(R.string.app_name))
							.setStyle(new NotificationCompat.BigTextStyle().bigText(msg))
							.setContentText(msg)
							.setAutoCancel(true)
							.setDefaults(Notification.DEFAULT_SOUND);
					
					if (urlIntent != hromIndent) {
						mBuilder.addAction(R.drawable.logo_notification, "Watch Now", PendingIntent.getActivity(this, 0, hromIndent, 0));
					}
					
					mBuilder.setContentIntent(PendingIntent.getActivity(this, 0, urlIntent, 0));
					
					mNotificationManager.notify(notificationId++, mBuilder.build());
				}

				Log.i(TAG, "Received: " + extras.toString());
			}
		}
	}
	
	protected boolean getPushEnabled()
	{
		return getSharedPreferences(MainActivity.class.getSimpleName(),
	            Context.MODE_PRIVATE).getBoolean("push_enabled", true);
	}
	
}
