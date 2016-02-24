package com.etherpricing.cache;

import java.util.ArrayList;
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
	
	/**
	 * 
	 * @param key
	 * @param value - why not use List?  when would you need it to be generic list?  almost never.  might as well use subtype so we know its performance characteristics.
	 */
	public static void save(String key, ArrayList<PriceCache.Price> value) {
		MemcacheService syncCache = MemcacheServiceFactory.getMemcacheService();
		syncCache.setErrorHandler(ErrorHandlers.getConsistentLogAndContinue(Level.INFO));
		syncCache.put(key, value);
	}
	
	public static ArrayList<PriceCache.Price> getPriceList(String key) {
		MemcacheService syncCache = MemcacheServiceFactory.getMemcacheService();
		syncCache.setErrorHandler(ErrorHandlers.getConsistentLogAndContinue(Level.INFO));
		@SuppressWarnings("unchecked")
		ArrayList<PriceCache.Price> value = (ArrayList<PriceCache.Price>) syncCache.get(key); // Read from cache.
		if (value == null) {
		    // Get value from another source.
		    // ........

		    //syncCache.put(key, value); // Populate cache.
		} 
		
		return value;
	}
}
