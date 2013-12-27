package tv.hromadske.app.fragments;

import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;

import tv.hromadske.app.R;
import tv.hromadske.app.VideoUkrActivity;
import tv.hromadske.app.utils.SystemUtils;
import android.app.Fragment;
import android.content.Intent;
import android.os.AsyncTask;
import android.os.Bundle;
import android.util.Log;
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
		DownloadDoc downloadDoc = new DownloadDoc(containerLoad);
		downloadDoc.execute();		
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
				Toast.makeText(getActivity(), "Недоступне посилання", Toast.LENGTH_LONG).show();
			}
			break;
		case R.id.btn_eng:
			if (!engUrl.isEmpty()) {
				intent.putExtra(SystemUtils.UKR_URL, engUrl);
				startActivity(intent);
			} else {
				Toast.makeText(getActivity(), "Недоступне посилання", Toast.LENGTH_LONG).show();
			}
			break;
		default:
			break;
		}
	}

	private class DownloadDoc extends AsyncTask<Void, Void, String> {

		private View loadView;
		private String videosUrl;

		public DownloadDoc(View loadView) {
			super();
			this.loadView = loadView;
			//this.videosUrl = videosUrl;
		}

		@Override
		protected void onPreExecute() {
			super.onPreExecute();
			loadView.setVisibility(View.VISIBLE);
		}

		@Override
		protected String doInBackground(Void... params) {
			try {
				Document home = Jsoup.connect("http://hromadske.tv").get();
				Elements homeUrls = home.select("div.mainnews a");
				videosUrl =  homeUrls.first().attr("abs:href");
				
				Document doc = Jsoup.connect(videosUrl).get();
				Elements links = doc.select("a[href]");
				for (Element link : links) {
					String s = link.attr("abs:href");
					if (s.contains("www.youtube.com")) {
						String[] sp = s.split("=");
						engUrl = sp[sp.length - 1];
						Log.i("engURL", engUrl);
					}
				}

				Elements es = doc.select("iframe");
				String ukr;
				for (Element e : es) {
					ukr = e.getElementsByTag("iframe").attr("src");
					if (ukr.contains("www.youtube.com")) {
						Log.i("URK_URL", " " + ukr);
						ukr = ukr.substring(0, ukr.indexOf("?"));
						Log.i("URK_URL", " " + ukr);
						String[] slashes = ukr.split("/");
						Log.i("URK_URL", " " + slashes[slashes.length - 1]);
						ukrUrl = slashes[slashes.length - 1];
						break;
					}
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
			return null;
		}

		@Override
		protected void onPostExecute(String result) {
			super.onPostExecute(result);
			loadView.setVisibility(View.GONE);
		}
	}
}