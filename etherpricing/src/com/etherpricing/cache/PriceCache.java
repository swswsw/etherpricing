package com.etherpricing.cache;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

/**
 * contain an exchange's price to be stored in cache.  
 * 
 * @author sol wu
 *
 */
public class PriceCache implements Serializable {

	/**
	 * unlikely to have more than 10 ether currency pair in one exchange.
	 */
	private List<Price> priceList = new ArrayList<Price>(10);
	
	public List<Price> getPriceList() {
		return priceList;
	}

	public void setPriceList(List<Price> priceList) {
		this.priceList = priceList;
	}
	
	public String toString() {
		return "{ " + "\"priceList\": " + priceList +  " }";
	}

	/**
	 * price of one single currency pair
	 */
	public static class Price implements Serializable {
		/** currency1 of currency pair */
		private String currency1 = null;
		/** currency2 of currency pair */
		private String currency2 = null;
		
		/** last price */
		private double last = -1;
		/** 24h volume */
		private double volume = -1;
		
		public Price(String currency1, String currency2, double last, double volume) {
			this.currency1 = currency1;
			this.currency2 = currency2;
			this.last = last;
			this.volume = volume;
		}
		
		public String toString() {
			return "{ "
					+ "\"currency1\": " + currency1 + ", "
					+ "\"currency2\": " + currency2 + ", "
					+ "\"last\": " + last + ", "
					+ "\"volume\": " + volume 
					+ " }";
		}
	}
}
