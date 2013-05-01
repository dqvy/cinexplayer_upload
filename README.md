Upload files to CineXPlayer
==================

Ruby script which allows you uploading files to CineXPlayer by using their HTML upload form.

Usages
==================
- by providing a list of files
- by using all files including in a specific folder

For each usage you have to configure the ip address of your iPad/iPhone by using the-h parameter (hostname does not work for the moment)

<code>ruby client.rb -h 192.168.1.8</code>

In order to specify files you have to use the -l paramater by adding files separated by a comma

<code>ruby client.rb -h 192.168.1.8 -l sample-video-1.mp4,sample-video-2.mp4,sample-video-3.mp4</code>

In order to use all files in a specific folder you have to use the -d paramater

<code>ruby client.rb -h 192.168.1.8 -d ~/Documents/Videos/</code>
