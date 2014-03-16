package tv.hromadske.app.gcm;

import tv.hromadske.app.R;

import com.google.android.gms.gcm.GoogleCloudMessaging;

import android.app.IntentService;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.support.v4.app.NotificationCompat;
import android.util.Log;

public class GcmIntentService extends IntentService {

	private static final String TAG = "HromGCM";
	public static final int NOTIFICATION_ID = 1;
	private NotificationManager mNotificationManager;
	NotificationCompat.Builder builder;

	public GcmIntentService() {
		super("GcmIntentService");
	}

	@Override
	protected void onHandleIntent(Intent intent) {
		Bundle extras = intent.getExtras();
		GoogleCloudMessaging gcm = GoogleCloudMessaging.getInstance(this);
		// The getMessageType() intent parameter must be the intent you received
		// in your BroadcastReceiver.
		String messageType = gcm.getMessageType(intent);

		if (!extras.isEmpty()) { // has effect of unparcelling Bundle
			/*
			 * Filter messages based on message type. Since it is likely that
			 * GCM will be extended in the future with new message types, just
			 * ignore any message types you're not interested in, or that you
			 * don't recognize.
			 */
			if (GoogleCloudMessaging.MESSAGE_TYPE_MESSAGE.equals(messageType)) {
				// Post notification of received message.
				mNotificationManager = (NotificationManager) this
						.getSystemService(Context.NOTIFICATION_SERVICE);

				Intent urlIntent = new Intent(Intent.ACTION_VIEW);
				if (extras.containsKey("u")) {
					urlIntent.setData(Uri.parse(extras.getString("u")));
				} else if (extras.containsKey("i")) {
					urlIntent.setData(Uri
							.parse("https://twitter.com/HromadskeTV/status/"
									+ extras.getString("i")));
				}

				PendingIntent contentIntent = PendingIntent.getActivity(this,
						0, urlIntent, 0);

				String msg = extras.getString("message");

				NotificationCompat.Builder mBuilder = new NotificationCompat.Builder(
						this)
						.setSmallIcon(R.drawable.ic_launcher)
						.setContentTitle(
								getApplicationContext().getString(
										R.string.app_name))
						.setStyle(
								new NotificationCompat.BigTextStyle()
										.bigText(msg)).setContentText(msg);

				mBuilder.setContentIntent(contentIntent);
				mNotificationManager.notify(NOTIFICATION_ID, mBuilder.build());

				Log.i(TAG, "Received: " + extras.toString());
			}
		}
		// Release the wake lock provided by the WakefulBroadcastReceiver.
		GcmBroadcastReceiver.completeWakefulIntent(intent);
	}

}
