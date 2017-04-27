# shETHer

Get the current rate for ETH ([Ethereum](https://www.ethereum.org)) from [Coinbase](https://www.coinbase.com).

It's made to fit in a 22x9 window.

### Roadmap

*empty*

### Changelog

#### 2017-04-27
* To calculate if the rate had gone up or down, for the comparison to work I had to remove the decimals, which didn't look so well if it indicated no change but new rate is 400.54 and old rate was 400.45. Now it removes the decimal separator.

#### 2017-04-26
* Show how much ETH you have
* Show the previous rate, and if the rate has gone Up, Down or hasn't changed
