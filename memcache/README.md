# What is Memcache

Memcache is essentially a giant in memory hash, with keys that can be permenant, or expire after a certain amount of time passes.

The primary use is to store values or content that is slow to calcuate or generate. 

Common useage is for storing data about database calls, 3rd party API calls, or generated content i.e. HTML fragments.

For a web page that may make dozens of database calls, make 3rd party api calls, and generate HTML, memcache can provide significant performance handling.

Let's run through a basic scenario.

## Example
You bring up widgets.com
Widgets.com checks to database for todays top widgets
It then calls out to twitter service to find out who's talking about those widgets
It then checks the database to find what widgets are near you.
It then renders the page's html and returns it.

Some ways of improving performance:  (ignoring for now proxies, expires, and etags)
 * Use memcache to store todays top widgets:  memcache[:top_deals] = [...]
 * Use memcache to store twitter information for several minutes. to keep content fresh, but not overuse the API
 * Use memcache to store widgets near you based on city as a key, since there may be lots of people around you looking for the same information
 * Use memcache to store the entire fragments of the generated HTML.  Since rendering isn't free either

## Multi-node
Not to be confused with a node.js based client of memcache :)

Basically all of the memcache servers will act together as a giant hash with one large memory table
When a request come it, it might be stored on any given server. But they are treated as if they are one.
If one server fails or is shut off, then the requests coming in will encur misses.  However after a bit, the other servers will soon rebuild the data, and all will be as it was.





