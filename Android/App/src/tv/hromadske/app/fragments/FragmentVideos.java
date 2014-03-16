package tv.hromadske.app.fragments;

import org.apache.http.HttpResponse;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.impl.client.DefaultHttpClient;
import org.json.JSONArray;
import org.json.JSONObject;

import com.google.analytics.tracking.android.EasyTracker;
import com.google.analytics.tracking.android.Fields;
import com.google.analytics.tracking.android.MapBuilder;
import com.google.analytics.tracking.android.Tracker;

import tv.hromadske.app.R;
import tv.hromadske.app.VideoUkrActivity;
import tv.hromadske.app.utils.SystemUtils;
import tv.hromadske.app.utils.Video;
import android.app.ActionBar.LayoutParams;
import android.app.Fragment;
import android.content.Intent;
import android.os.AsyncTask;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.LinearLayout;

public class FragmentVideos extends Fragment {
	private View containerLoad;
	protected LinearLayout list;
	protected Video[] videos;
	protected Button[] buttons;
	protected LayoutInflater inflater;

	public FragmentVideos() {
		super();
	}

	@Override
	public View onCreateView(LayoutInflater inflate, ViewGroup container, Bundle savedInstanceState) {
		View v = inflate.inflate(R.layout.fragment_videos, null);
		list = (LinearLayout) v.findViewById(R.id.btns_list);
		containerLoad = v.findViewById(R.id.container_load);
		inflater = inflate;
		return v;
	}
	
	@Override
	public void onStart() {
		super.onStart();
		Tracker tracker = EasyTracker.getInstance(getActivity());
		tracker.set(Fields.SCREEN_NAME, "Home");
		tracker.send(MapBuilder.createAppView().build());
	}
	
	@Override
	public void onActivityCreated(Bundle savedInstanceState) {
		super.onActivityCreated(savedInstanceState);
		GetYoutubeUrlTask getYoutubeUrlTask = new GetYoutubeUrlTask(containerLoad);
		getYoutubeUrlTask.execute();
	}
	
	protected void createButtons()
	{
		if (buttons != null) {
			for (Button button : buttons) {
				list.removeView(button);
			}
		}
		
		buttons = new Button[videos.length];
		
		for (int i = videos.length - 1;i >= 0;i--) {
			Button button = buttons[i] = (Button) inflater.inflate(R.layout.btn_stream, null);
			button.setText(videos[i].name);
			final Video video = videos[i];
			button.setOnClickListener(new OnClickListener() {
				public void onClick(View v) {
					Intent intent = new Intent(getActivity(), VideoUkrActivity.class);
					intent.putExtra(SystemUtils.UKR_URL, video.videoId);
					startActivity(intent);
				}
			});
			
			LinearLayout.LayoutParams params = new LinearLayout.LayoutParams(LayoutParams.MATCH_PARENT, LayoutParams.WRAP_CONTENT);
			params.setMargins(0, 10, 0, 0);
			button.setLayoutParams(params);
			list.addView(button, 0);
		}
	}

	public class GetYoutubeUrlTask extends AsyncTask<Void, Void, Boolean> {
		private View loadView;

		public GetYoutubeUrlTask(View loadView) {
			super();
			this.loadView = loadView;
		}

		@Override
		protected void onPreExecute() {
			super.onPreExecute();
			loadView.setVisibility(View.VISIBLE);
		}

		@Override
		protected Boolean doInBackground(Void... params) {
			try {
				HttpGet httpGet = new HttpGet(SystemUtils.STREAMS_URL);
				DefaultHttpClient mHttpClient = new DefaultHttpClient();
				HttpResponse dresponse = mHttpClient.execute(httpGet);
				int status = dresponse.getStatusLine().getStatusCode();
				if (status == 200) {
					String res = SystemUtils.streamToString(dresponse.getEntity().getContent());
					JSONArray streams = new JSONObject(res).optJSONArray("streams");
					videos = new Video[streams.length()];
					
					for (int i = 0; i < videos.length; i++) {
						JSONObject stream = streams.optJSONObject(i);
						videos[i] = new Video(stream.getString("name"), stream.getString("videoId"), stream.getString("thumb"));
					}
					
					return true;
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
			return false;
		}

		@Override
		protected void onPostExecute(Boolean result) {
			super.onPostExecute(result);
			createButtons();
			loadView.setVisibility(View.GONE);
		}
	}
}