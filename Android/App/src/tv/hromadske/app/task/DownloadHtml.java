package tv.hromadske.app.task;

import java.io.BufferedReader;
import java.io.InputStreamReader;

import org.apache.http.HttpResponse;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.protocol.BasicHttpContext;
import org.apache.http.protocol.HttpContext;

import android.os.AsyncTask;
import android.util.Log;

public class DownloadHtml extends AsyncTask<String, Void, String> {

	@Override
	protected String doInBackground(String... urls) {
		String responseStr = "";
		try {
			HttpClient httpClient = new DefaultHttpClient();
			HttpContext localContext = new BasicHttpContext();
			HttpGet httpGet = new HttpGet(urls[0]);
			HttpResponse response = httpClient.execute(httpGet, localContext);
			String result = "";
			BufferedReader reader = new BufferedReader(new InputStreamReader(response.getEntity().getContent()));

			String line = null;
			while ((line = reader.readLine()) != null) {
				result += line + "\n";

			}
			responseStr = result;
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
/*
 * @Override protected String doInBackground(String... urls) { String
 * responseStr = ""; try { for (String url : urls) { DefaultHttpClient
 * httpClient = new DefaultHttpClient(); HttpGet get = new HttpGet(url);
 * HttpResponse httpResponse = httpClient.execute(get); HttpEntity httpEntity =
 * httpResponse.getEntity(); responseStr = EntityUtils.toString(httpEntity); } }
 * catch (Exception e) { } return responseStr; }
 */