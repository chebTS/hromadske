package tv.hromadske.app.fragments;

import tv.hromadske.app.R;
import android.app.DialogFragment;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.Window;

public class FragmentAbout extends DialogFragment {

	@Override
	public View onCreateView(LayoutInflater inflater, ViewGroup container,
			Bundle savedInstanceState) {
		View v = inflater.inflate(R.layout.fragment_about, null);
		getDialog().getWindow().requestFeature(Window.FEATURE_NO_TITLE);
		return v;
	}
}
