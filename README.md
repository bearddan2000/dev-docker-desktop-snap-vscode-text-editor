# dev-docker-desktop-snap-vscode-text-editor

## Description
This is a POC project to demonstrate vscode a text editor.

<p style="color: blue;">As of the creation of this project: vscode is depreciated, use at your own risk.</p>

This is a barebones installation no pluggins where added. 

In order to be able to get files out of the container one must add a *volume* to the docker run command.

ie.
without a volume
`docker run --rm` ...
with a volume
`docker run --rm -v $(pwd):/app` ...

Supports X11 display forwarding from docker container.

<u>Snap is specific to Ubuntu OS, use of the Dockerfile with other
OS may break.</u>

<u>The technique used can be found in <code>install.sh</code>
under the <code>start-up</code></u>

## Tech stack
- snap
- vscode

## Docker stack
- ubuntu:18.04

## To run
`sudo ./install.sh -u`

## To stop (optional)
`sudo ./install.sh -d`

## To see help
`sudo ./install.sh -h`

## Credit
- [Snap example](https://forum.snapcraft.io/t/install-snap-in-docker/20740)
- [Security patch](https://github.com/ogra1/snapd-docker/issues/9)