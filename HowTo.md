## Quick version ##

  * Check out the SVN anonymously
  * If you want to build a USB image, make sure the key is on `/dev/sdb1/`
    * Obviously, I've taken a short-cut here
  * Run `./build.eeedora.bash`
  * This will build an ISO image of what you need
    * and will optionally install it onto the USB key
  * The RPM packages it uses get cached in a `yum_cache` directory
    * this is a time-saver if you're making adjustments to the `.ks` file
    * empty it out when you're done

## Longer Version ##

Over at http://wiki.eeeuser.com/eeedora:issues .