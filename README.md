# coinbash

Get the current rate for BTC, ETH & LTC from [Coinbase](https://www.coinbase.com).

### Roadmap

* Reinstate indicator if the currency rate has gone up, down or is unchanged since last fetch.

### Changelog

#### 2017-07-04
* If the API returns null when asking for exchange rate, it will default to zero (only a temporary solution).

#### 2017-05-09
* Fixed a bug that if you changed/updated your BTC amount it emptied coins.csv.
* In the menu to edit and view the coins.csv I added crypto currency identifier.
* Fixed the indicator, so it works now as intended.

#### 2017-05-08
* Less variables by using a arrays.
* Coins are saved in a CSV file.
* Improved menu based on updates above.

#### 2017-05-07
* Changed the name from shETHer to coinbash as I will be including all three currencies from Coinbase -- BTC, ETH & LTC.
* Removed currency change indicator till I can find a good way to make it work for all currency without adding too much lines of code than necessary.

#### 2017-04-27
* To calculate if the rate had gone up or down, for the comparison to work I had to remove the decimals, which didn't look so well if it indicated no change but new rate is 400.54 and old rate was 400.45. Now it removes the decimal separator.

#### 2017-04-26
* Show how much ETH you have
* Show the previous rate, and if the rate has gone Up, Down or hasn't changed
