package tv.hromadske.app.fragments;

import org.apache.http.HttpResponse;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.impl.client.DefaultHttpClient;
import org.json.JSONArray;
import org.json.JSONObject;

import tv.hromadske.app.R;
import tv.hromadske.app.VideoUkrActivity;
import tv.hromadske.app.utils.SystemUtils;
import android.app.Fragment;
import android.content.Intent;
import android.os.AsyncTask;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.Toast;

public class FragmentVideos extends Fragment implements OnClickListener {
	private Button btnEng, btnUkr;
	private View containerLoad;
	private String engUrl = "";
	private String ukrUrl = "";

	public FragmentVideos() {
		super();
	}

	@Override
	public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
		View v = inflater.inflate(R.layout.fragment_videos, null);
		btnUkr = (Button) v.findViewById(R.id.btn_ukr);
		btnEng = (Button) v.findViewById(R.id.btn_eng);
		containerLoad = v.findViewById(R.id.container_load);
		return v;
	}
	
	@Override
	public void onActivityCreated(Bundle savedInstanceState) {
		super.onActivityCreated(savedInstanceState);
		containerLoad.setOnClickListener(this);
		btnUkr.setOnClickListener(this);
		btnEng.setOnClickListener(this);
		GetYoutubeUrlTask getYoutubeUrlTask = new GetYoutubeUrlTask(containerLoad);
		getYoutubeUrlTask.execute();
	}

	@Override
	public void onClick(View v) {
		Intent intent;
		intent = new Intent(getActivity(), VideoUkrActivity.class);
		switch (v.getId()) {
		case R.id.btn_ukr:
			if (!ukrUrl.isEmpty()) {
				intent.putExtra(SystemUtils.UKR_URL, ukrUrl);
				startActivity(intent);
			} else {
				Toast.makeText(getActivity(), R.string.no_link, Toast.LENGTH_LONG).show();
			}
			break;
		case R.id.btn_eng:
			if (!engUrl.isEmpty()) {
				intent.putExtra(SystemUtils.UKR_URL, engUrl);
				startActivity(intent);
			} else {
				Toast.makeText(getActivity(), R.string.no_link, Toast.LENGTH_LONG).show();
			}
			break;
		default:
			break;
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
				HttpGet httpGet = new HttpGet(String.format(SystemUtils.GDATA_URL));
				DefaultHttpClient mHttpClient = new DefaultHttpClient();
				HttpResponse dresponse = mHttpClient.execute(httpGet);
				int status = dresponse.getStatusLine().getStatusCode();
				if (status == 200) {
					String res = SystemUtils.streamToString(dresponse.getEntity().getContent());
					JSONObject jRoot = new JSONObject(res);
					JSONArray jArray = jRoot.optJSONObject("feed").optJSONArray("entry");
					String str = jArray.optJSONObject(0).optJSONObject("content").optString("src");
					str = str.substring(str.lastIndexOf('/') + 1);
					int index = str.lastIndexOf("?");
					if (index > 0){
						str = str.substring(0, index);
					}
					//Log.i("GDATA", " " + str);
					ukrUrl = str;
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
			loadView.setVisibility(View.GONE);
		}
	}
}