package tv.hromadske.app.fragments;

import tv.hromadske.app.R;
import tv.hromadske.app.VideoUkrActivity;
import tv.hromadske.app.task.DownloadHtml;
import tv.hromadske.app.utils.SystemUtils;
import android.app.Fragment;
import android.content.Intent;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.Button;

public class FragmentVideos extends Fragment implements OnClickListener {
	private Button btnUkr, btnEng;
		
	public FragmentVideos() {
		super();
	}

	@Override
	public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
		View v = inflater.inflate(R.layout.fragment_videos, null);
		btnUkr = (Button)v.findViewById(R.id.btn_ukr);
		
		
		btnEng = (Button)v.findViewById(R.id.btn_eng);
		
		
		return v;
	}

	
	
	@Override
	public void onActivityCreated(Bundle savedInstanceState) {
		super.onActivityCreated(savedInstanceState);
		DownloadHtml downloadHtml = new DownloadHtml();
		downloadHtml.execute("http://hromadske.tv/episode/128");
		btnEng.setOnClickListener(this);
		btnUkr.setOnClickListener(this);
	}

	@Override
	public void onClick(View v) {
		Intent intent;
		intent = new Intent(getActivity(), VideoUkrActivity.class);
		switch (v.getId()) {
		case R.id.btn_ukr:
			intent.putExtra(SystemUtils.UKR_URL, "tCcQGb1dmls");
			startActivity(intent);
			break;
		case R.id.btn_eng:
			intent.putExtra(SystemUtils.UKR_URL, "tCcQGb1dmls");
			startActivity(intent);
			break;
		default:
			break;
		}
	}
}