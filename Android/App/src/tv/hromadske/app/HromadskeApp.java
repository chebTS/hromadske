package tv.hromadske.app;

import static tv.hromadske.app.utils.SystemUtils.IMAGELOADER;

import com.nostra13.universalimageloader.cache.memory.impl.LruMemoryCache;
import com.nostra13.universalimageloader.core.DisplayImageOptions;
import com.nostra13.universalimageloader.core.ImageLoader;
import com.nostra13.universalimageloader.core.ImageLoaderConfiguration;

import android.app.Application;
import android.graphics.Bitmap.CompressFormat;

public class HromadskeApp extends Application {

	
	@Override
	public void onCreate() {
		super.onCreate();
		initImageLoader();
	}

	private void initImageLoader() {
		if (IMAGELOADER == null) {
			IMAGELOADER = ImageLoader.getInstance();
			DisplayImageOptions options = new DisplayImageOptions.Builder()
					.cacheInMemory(true)
					.cacheOnDisc(true)
					.build();
			ImageLoaderConfiguration config = new ImageLoaderConfiguration.Builder(this)
					.discCacheExtraOptions(480, 800, CompressFormat.JPEG, 75, null)
					.denyCacheImageMultipleSizesInMemory()
					.memoryCache(new LruMemoryCache(2 * 1024 * 1024))
					.memoryCacheSize(2 * 1024 * 1024)
					.discCacheSize(50 * 1024 * 1024)
					.discCacheFileCount(100)
					.defaultDisplayImageOptions(options)
					.build();
			IMAGELOADER.init(config);
		}
	}
}
