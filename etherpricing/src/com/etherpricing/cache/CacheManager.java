package com.etherpricing.cache;

import java.util.logging.Level;

import com.google.appengine.api.memcache.ErrorHandlers;
import com.google.appengine.api.memcache.MemcacheService;
import com.google.appengine.api.memcache.MemcacheServiceFactory;

public class CacheManager {

	public static void save(String key, String value) {
		MemcacheService syncCache = MemcacheServiceFactory.getMemcacheService();
		syncCache.setErrorHandler(ErrorHandlers.getConsistentLogAndContinue(Level.INFO));
		syncCache.put(key, value);
	}
	
	public static String getString(String key) {
		MemcacheService syncCache = MemcacheServiceFactory.getMemcacheService();
		syncCache.setErrorHandler(ErrorHandlers.getConsistentLogAndContinue(Level.INFO));
		String value = (String) syncCache.get(key); // Read from cache.
		if (value == null) {
		    // Get value from another source.
		    // ........

		    //syncCache.put(key, value); // Populate cache.
		} 
		
		return value;
	}
	
	public static void save(String key, PriceCache value) {
		MemcacheService syncCache = MemcacheServiceFactory.getMemcacheService();
		syncCache.setErrorHandler(ErrorHandlers.getConsistentLogAndContinue(Level.INFO));
		syncCache.put(key, value);
	}
	
	public static PriceCache getPriceCache(String key) {
		MemcacheService syncCache = MemcacheServiceFactory.getMemcacheService();
		syncCache.setErrorHandler(ErrorHandlers.getConsistentLogAndContinue(Level.INFO));
		PriceCache value = (PriceCache) syncCache.get(key); // Read from cache.
		if (value == null) {
		    // Get value from another source.
		    // ........

		    //syncCache.put(key, value); // Populate cache.
		} 
		
		return value;
	}
}
