package tv.hromadske.app;

import tv.hromadske.app.utils.SystemUtils;
import android.os.Bundle;

import com.google.analytics.tracking.android.EasyTracker;
import com.google.android.youtube.player.YouTubePlayer;
import com.google.android.youtube.player.YouTubePlayerFragment;

public class VideoUkrActivity extends YouTubeFailureRecoveryActivity {
	private String url;

	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_video_ukr);
		url = getIntent().getExtras().getString(SystemUtils.UKR_URL);

		YouTubePlayerFragment youTubePlayerFragment = (YouTubePlayerFragment) getFragmentManager().findFragmentById(
				R.id.youtube_fragment);
		youTubePlayerFragment.initialize(SystemUtils.DEVELOPER_KEY, this);
	}

	@Override
	public void onInitializationSuccess(YouTubePlayer.Provider provider, YouTubePlayer player, boolean wasRestored) {
		if (!wasRestored) {
			player.cueVideo(url);
		}
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
	protected YouTubePlayer.Provider getYouTubePlayerProvider() {
		return (YouTubePlayerFragment) getFragmentManager().findFragmentById(R.id.youtube_fragment);
	}

}
