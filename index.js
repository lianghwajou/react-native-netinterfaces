import {NativeModules} from 'react-native';

const {RNNetinterfaces} = NativeModules;

// net/if.h
// #define IFF_UP          0x1             /* interface is up */
// #define IFF_BROADCAST   0x2             /* broadcast address valid */
// #define IFF_DEBUG       0x4             /* turn on debugging */
// #define IFF_LOOPBACK    0x8             /* is a loopback net */
// #define IFF_POINTOPOINT 0x10            /* interface is point-to-point link */
// #define IFF_NOTRAILERS  0x20            /* obsolete: avoid use of trailers */
// #define IFF_RUNNING     0x40            /* resources allocated */
// #define IFF_NOARP       0x80            /* no address resolution protocol */
// #define IFF_PROMISC     0x100           /* receive all packets */
// #define IFF_ALLMULTI    0x200           /* receive all multicast packets */
// #define IFF_OACTIVE     0x400           /* transmission in progress */
// #define IFF_SIMPLEX     0x800           /* can't hear own transmissions */
// #define IFF_LINK0       0x1000          /* per link layer defined bit */
// #define IFF_LINK1       0x2000          /* per link layer defined bit */
// #define IFF_LINK2       0x4000          /* per link layer defined bit */
// #define IFF_ALTPHYS     IFF_LINK2       /* use alternate physical connection */
// #define IFF_MULTICAST   0x8000          /* supports multicast */

const IP_FLAGS = {
  UP: 0x1 /* interface is up */,
  BROADCAST: 0x2 /* broadcast address valid */,
  DEBUG: 0x4 /* turn on debugging */,
  LOOPBACK: 0x8 /* is a loopback net */,
  POINTOPOINT: 0x10 /* interface is point-to-point link */,
  NOTRAILERS: 0x20 /* obsolete: avoid use of trailers */,
  RUNNING: 0x40 /* resources allocated */,
  NOARP: 0x80 /* no address resolution protocol */,
  PROMISC: 0x100 /* receive all packets */,
  ALLMULTI: 0x200 /* receive all multicast packets */,
  OACTIVE: 0x400 /* transmission in progress */,
  SIMPLEX: 0x800 /* can't hear own transmissions */,
  LINK0: 0x1000 /* per link layer defined bit */,
  LINK1: 0x2000 /* per link layer defined bit */,
  LINK2: 0x4000 /* per link layer defined bit */,
  ALTPHYS: 0x4000 /* use alternate physical connection */,
  MULTICAST: 0x8000 /* supports multic */,
};

// const NetInterfaces = {
//     async getInterfaces() {
//         return await RNNetinterfaces.getInterfaces();
//     }
// }

const NetInterfaces = {
  async getInterfaces() {
    return (interfaces => {
      let iflist = {};
      for (const ifname in interfaces) {
        iflist[ifname] = new NetInterface(interfaces[ifname]);
      }
      return iflist;
    })(await RNNetinterfaces.getInterfaces());
  },
};

class NetInterface {
  constructor(netif) {
    this.netif = {name: netif.name, flags: netif.flags};
    if ('ipv4' in netif) {
      this.netif['ipv4'] = {addr: netif.ipv4.addr, netmask: netif.ipv4.netmask};
      if ('dstaddr' in netif.ipv4) {
        if (this.isPointToPoint()) {
          this.netif.ipv4['dstaddr'] = netif.ipv4.dstaddr;
        } else {
          this.netif.ipv4['brdaddr'] = netif.ipv4.dstaddr;
        }
      }
    }
    if ('ipv6' in netif) {
      this.netif['ipv6'] = {addr: netif.ipv6.addr, netmask: netif.ipv6.netmask};
      if ('dstaddr' in netif.ipv6) {
        if (this.isPointToPoint()) {
          this.netif.ipv6['dstaddr'] = netif.ipv6.dstaddr;
        } else {
          this.netif.ipv6['brdaddr'] = netif.ipv6.dstaddr;
        }
      }
    }
  }
  isBroadcast() {
    return this.netif.flags & IP_FLAGS.BROADCAST;
  }
  isUp() {
    return this.netif.flags & IP_FLAGS.UP;
  }
  isPointToPoint() {
    return this.netif.flags & IP_FLAGS.POINTOPOINT;
  }
  hasIPv4() {
    return 'ipv4' in this.netif;
  }
  getIPv4() {
    return this.netif.ipv4;
  }
  hasIPv6() {
    return 'ipv6' in this.netif;
  }
  getIPv6() {
    return this.netif.ipv6;
  }
}

export {NetInterfaces};
