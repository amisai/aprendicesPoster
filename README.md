aprendicesPoster is a little ruby program that captures new posts in a Google group and publish them in Twitter.

As it is, it visits [Aprendices group](https://plus.google.com/communities/114859785439968913587) and publishes them at [@deAprendices](https://twitter.com/deAprendices), using [Karmacracy](http://karmacracy.com/) to control visits (and make urls shorter as well).

Internally, currently it uses a mongodb instance as persistence layer.

It provides two ruby scripts, located at ```bin```, to perform its operations:

* ```aprendicesScrapper``` visits Google group page and stores new posts in persistence. 
* ```aprendicesSharer``` select oldest unpublished post from persistence and publishes it at Twitter account. 

Both scripts can be launched from command line or ```cron``` schedule. 

Also, this application provides a little sinatra web interface, where you can see unpublished posts, and mark one as already publish. In order to access to this page you'll have to provide a key parameter in url, just for security: ```http://servername:port/list/?key=access_key``` 

Configuration
-------------

All configuration is done in an .env file (for obvious security reasons, I'm not publishing mine, but a sample one, you have to rename it to .env). Current keys are:

* ```KEY```:parameter to access to web page.
* ```PORT```:web interface port.
* ```MONGOHQ_URL```:mongo url in format mongodb://@server:port/bbdd.
* ```GROUP_URL```:Google group url.

* ```twitter_consumer_key```:Twitter consumer key.
* ```twitter_consumer_secret```:Twitter consumer secret.
* ```twitter_access_token```:Twitter access token.
* ```twitter_access_token_secret```:Twitter access token secret.

* ```karmacracy_username```:Karmacracy username.
* ```karmacracy_password```:Karmacracy password.

* ```env```: it defines current environment. Only if it's set to 'prod' it will tweet post. Useful for testing.  
