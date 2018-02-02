# Renewing Puppet Certs

- Node: slave-vsi-11.openswitch.net
- Master: puppetmaster.openswitch.net

```bash
(S) = on node
(M) = on master

(S) puppet config print certname #slave-vsi-11.openswitch.net in this case
(M) puppet cert --revoke slave-vsi-11.openswitch.net
(M) puppet cert --clean slave-vsi-11.openswitch.net
(S) rm -rf /var/lib/puppet/ssl
(S) puppet agent --server puppetmaster.openswitch.net --waitforcert 60
(M) puppet cert --sign slave-vsi-11.openswitch.net (if this fails, run puppet agent -t on S)
(S) puppet agent -t
```
