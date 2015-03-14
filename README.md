# eeedora

( Automatically migrated from code.google.com/p/eeedora )

When the original Asus Eee 701 PC came out, it came with a nice-and-easy UI, on top of a Xandros (debian-based) core.

However, for 'power users' familiar with RedHat distributions, it's far more comfortable to use a version of Fedora, customized for the Eee machine.

This project includes the files necessary to build a custom spin of Fedora (using their excellent tools), put it onto a CD (or USB key) as a Live version to test it out, and then install it as a replacement for the Asus default.
Goals

This project's goal is to have a Live (and installable) distribution that :

  * Is Fedora (currently Fedora 8)
  * Runs XFCE as a windowing environment
  * Takes as little space on the Eee's Flash drive as possible
  * Gives the user the option of installing bigger packages (like openoffice, media players, etc)
  * Understands each piece of hardware on the Eee (wireless, webcam, speakers, etc)
  * ... and generally gives everyone a sense of satisfaction. 

## Documentation

There are a few more Wiki pages over at http://wiki.eeeuser.com/howto:eeedora , and there's a downloadable ISO available at http://eeedora.complexvalues.com/ .

  * The current State of Play
  * The Basic Approach taken with getting this spin working
  * Notes on getting the wired internet to work
  * Notes on creating a Live USB install 

## ... but it's an old project...

This is now somewhat obsolete, simply because the required updates were adopted into the mainline.




## Where the EeeDora setup stands now

== What it Does Do ==

  * Boots Fedora 8 on a Live USB or Live CD, connected to the Eee PC USB ports
  * Goes into a nice-looking XFCE windowing environment
  * Includes a 1-click install to the Eee's internal drive
     * Works for 4Gb and 2Gb Eee's
  * Has kernel modules set up for :
     * Wired ethernet (atl2)
     * Wireless ethernet (Atheros)
     * ACPI handling (Asus source code, plus scripts)
     * Webcam (uvcvideo)
     * truecrypt (for actual security)
  * The ACPI lets the Blue Function keys work, as well as the external VGA switching
  * ...

== What it Doesn't Do (yet) ==

  * Ultra-clean suspend/resume for the wifi
  * Otherwise : Let me know
  * ...

== What it Doesn't Do Generally ==

  * Include a lot of bloat (let the user choose what they need)
  * Anything half as nice as the default Xandros UI
  * Give any protection from Microsoft patent FUD (ouch!)


# Creation of an Installable Live USB

== Quick version ==

  * Check out the SVN anonymously
  * If you want to build a USB image, make sure the key is on `/dev/sdb1/`
    * Obviously, I've taken a short-cut here
  * Run `./build.eeedora.bash`
  * This will build an ISO image of what you need
    * and will optionally install it onto the USB key
  * The RPM packages it uses get cached in a `yum_cache` directory
    * this is a time-saver if you're making adjustments to the `.ks` file
    * empty it out when you're done

== Longer Version ==

Over at http://wiki.eeeuser.com/eeedora:issues .


#summary How this whole thing works

== Introduction ==

Fedora includes a tool called kickstart that makes building distributions 'easy'.

However, because this is entirely driven by RPMs, it's very difficult to get all the customization done in the kickstart file itself (since a 'round trip' takes about 45 minutes).

Also, since the Eee has non-standard drivers required for the wired ethernet (atl2) and wireless (Atheros), custom binaries also have to be 'shipped' within the ISO image.

Rather than face RPM version hell (since each user will probably be building this on slightly different kernel versions), I decided to take the easy way out :  Build a since RPM that contains a tar-ball of everything that's needed on the Eee itself.

== The RPM : eee_tarball ==

In the `eee-setup` directory, there's a script that builds an RPM of scripts and settings, ready to be untarred in the /root/ directory.

From there, it's a simple matter for the kickstart file to untar in tar-ball, and run scripts within it.  This makes for a very extensible system, and makes each 'round-trip' incrementally more worthwhile.

The build-eeedora.bash script creates a local repository for the _one_ RPM, and then builds the ISO for the whole system.  From there, everything is automatic.



#summary How to compile up the atl2 driver

== Introduction ==

There have been changes in the files `<linux/etherdevice.h>` and `<linux/ethtool.h>`, which stopped the ASUS/Atheros distributed `atl2-1.0.40.4.tar.gz` compiling and installing correctly.

After some digging around with a kernel cross-reference tool (I only just found out these cool tools)...  Looks much better now.  I've uploaded the kernel module `atl2.ko` compiled for `2.6.23.1-49.fc8`.

== Details - for updating a standard tar-ball ==
Insert the following into the file `kcompat.h` just before the final `#endif` :

{{{
#if ( LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,23) )
// this used to be in <linux/etherdevice.h> - disappeared in 2.6.23
// See : http://lxr.free-electrons.com/diff/include/linux/etherdevice.h?v=2.6.22;diffval=2.6.23;diffvar=v
static inline void eth_copy_and_sum (struct sk_buff *dest,
        const unsigned char *src,
        int len, int base)
{
 memcpy (dest->data, src, len);
}
// this used to be in <linux/ethtool.h> - disappeared in 2.6.23
//  static const struct ethtool_ops.get_perm_addr  = ethtool_op_get_perm_addr,
// See : http://lxr.free-electrons.com/diff/include/linux/ethtool.h?v=2.6.22;diffval=2.6.23;diffvar=v
#undef ETHTOOL_GPERMADDR
#endif /* >= 2.6.23 */
}}}

== Installing the module ==
As root :
{{{
mkdir /lib/modules/`uname -r`/kernel/drivers/net/atl2
cp atl2.ko /lib/modules/`uname -r`/kernel/drivers/net/atl2/
/sbin/depmod -a

# Do this as a force since this was compiled against 2.6.23.1-49.fc8,
# and your kernel may be different (should be no big deal, as long as it's Fedora 8)
/sbin/modprobe -f atl2
}}}

== To Do ... ==
   * Upload the full (updated) source ASAP
   * Email the Atheros tech guy (xiong.huang 'at' atheros.com) to help him out

