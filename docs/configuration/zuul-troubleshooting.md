# Zuul Troubleshooting

- No jobs appearing on [Zuul](http://zuul.openswitch.net/)? SSH to the server and
  run `/etc/init.d/zuul stop && /etc/init.d/zuul start`.
- Jobs appearing but not running? After doing the above fix, also run
  `/etc/init.d/zuul-merger stop && /etc/init.d/zuul-merger start` on `zm01`.
