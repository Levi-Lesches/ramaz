There is a security issue with the `minimist` package. It was fixed in `^1.2.3`. Problem is, `grpc` pins down a lower version, causing several packages to continue using the affected versions. `mkdirp` used ot have this issue, but has recently been upgraded to not have any dependencies at all. 

To fix this, we need to upgrade all instances of `mkdirp` to `1.x`, and all instances of `minimist` to `^1.2.3`: 

1. In `mocha`, change `mkdirp` to `1.0.0`
	- delete `mocha/mkdirp`
2. In `grpc/node-pre-gyp`, change `mkdirp` to `^1.0.0`
4. In `grpc/rc`, change `minimist` to `^1.2.5`.
3. In `grpc/tar`, change `mkdirp` to `^1.0.0`.

Now we have to force `npm` to reinstall these packages: 

- Delete `grpc/minimist`
- Delete `grpc/mkdirp`
- Delete `minimist`
- Delete `mkdirp`