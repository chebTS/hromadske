package tv.hromadske.app.fragments;

import tv.hromadske.app.R;
import android.app.DialogFragment;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.view.Window;
import android.widget.Button;

public class FragmentAbout extends DialogFragment implements OnClickListener {

	private Button btnDevelopers;
	
	@Override
	public View onCreateView(LayoutInflater inflater, ViewGroup container,
			Bundle savedInstanceState) {
		View v = inflater.inflate(R.layout.fragment_about, null);
		btnDevelopers = (Button)v.findViewById(R.id.btn_developers);
		btnDevelopers.setOnClickListener(this);
		getDialog().getWindow().requestFeature(Window.FEATURE_NO_TITLE);
		return v;
	}

	@Override
	public void onClick(View v) {
		switch (v.getId()) {
		case R.id.btn_developers:
			String packageName = getActivity().getPackageName();
			try {
				Intent intent = new Intent(Intent.ACTION_VIEW);
				intent.setData(Uri.parse("market://details?id=" + packageName));
				startActivity(intent);
			} catch (Exception e) { // google play app is not installed
				Intent intent = new Intent(Intent.ACTION_VIEW);
				intent.setData(Uri.parse("https://play.google.com/store/apps/details?id="+ packageName));
				startActivity(intent);
			}
			break;
		default:
			break;
		}
	}
}
