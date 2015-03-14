## Introduction ##

There have been changes in the files `<linux/etherdevice.h>` and `<linux/ethtool.h>`, which stopped the ASUS/Atheros distributed `atl2-1.0.40.4.tar.gz` compiling and installing correctly.

After some digging around with a kernel cross-reference tool (I only just found out these cool tools)...  Looks much better now.  I've uploaded the kernel module `atl2.ko` compiled for `2.6.23.1-49.fc8`.

## Details - for updating a standard tar-ball ##
Insert the following into the file `kcompat.h` just before the final `#endif` :

```
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
```

## Installing the module ##
As root :
```
mkdir /lib/modules/`uname -r`/kernel/drivers/net/atl2
cp atl2.ko /lib/modules/`uname -r`/kernel/drivers/net/atl2/
/sbin/depmod -a

# Do this as a force since this was compiled against 2.6.23.1-49.fc8,
# and your kernel may be different (should be no big deal, as long as it's Fedora 8)
/sbin/modprobe -f atl2 
```

## To Do ... ##
  * Upload the full (updated) source ASAP
  * Email the Atheros tech guy (xiong.huang 'at' atheros.com) to help him out