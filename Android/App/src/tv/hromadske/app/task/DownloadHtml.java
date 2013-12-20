package tv.hromadske.app.task;

import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.util.EntityUtils;

import android.os.AsyncTask;
import android.util.Log;

public class DownloadHtml extends AsyncTask<String, Void, String> {

	@Override
	protected String doInBackground(String... urls) {
		String responseStr = "";
		try {
			for (String url : urls) {
				DefaultHttpClient httpClient = new DefaultHttpClient();
				HttpGet get = new HttpGet(url);
				HttpResponse httpResponse = httpClient.execute(get);
				HttpEntity httpEntity = httpResponse.getEntity();
				responseStr = EntityUtils.toString(httpEntity);
			}
		} catch (Exception e) {
		}
		return responseStr;
	}

	@Override
	protected void onPostExecute(String result) {
		super.onPostExecute(result);
		Log.i("Result", result);
	}
}