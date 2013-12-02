package tv.hromadske.app;

import android.app.ActionBar;
import android.app.ActionBar.Tab;
import android.app.Activity;
import android.app.FragmentTransaction;
import android.os.Bundle;

public class MainActivity extends Activity implements ActionBar.TabListener {

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_main);
		ActionBar bar = getActionBar();

	    bar.setNavigationMode(ActionBar.NAVIGATION_MODE_TABS);
	    Tab tab = bar.newTab();
	    tab.setText(R.string.videonews);
	    tab.setTabListener(this);
	    bar.addTab(tab);

	    tab = bar.newTab();
	    tab.setText(R.string.interview);
	    tab.setTabListener(this);
	    bar.addTab(tab);
	    
	    tab = bar.newTab();
	    tab.setText(R.string.programs);
	    tab.setTabListener(this);
	    bar.addTab(tab);
	    
	    tab = bar.newTab();
	    tab.setText(R.string.about_project);
	    tab.setTabListener(this);
	    bar.addTab(tab);
	    
	    
	}

	@Override
	public void onTabReselected(Tab tab, FragmentTransaction ft) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void onTabSelected(Tab tab, FragmentTransaction ft) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void onTabUnselected(Tab tab, FragmentTransaction ft) {
		// TODO Auto-generated method stub
		
	}

}
