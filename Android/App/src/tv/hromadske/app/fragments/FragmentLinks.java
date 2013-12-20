package tv.hromadske.app.fragments;

import tv.hromadske.app.R;
import android.app.Fragment;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.Button;

public class FragmentLinks extends Fragment implements OnClickListener {

	public FragmentLinks() {
		super();
	}

	@Override
	public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
		View v = inflater.inflate(R.layout.fragment_links, null, false);
		((Button)v.findViewById(R.id.btn_btn)).setOnClickListener(this);
		return v;
	}

	@Override
	public void onClick(View v) {
		switch (v.getId()) {
		case R.id.btn_btn:
			break;
		default:
			break;
		}
	}
}