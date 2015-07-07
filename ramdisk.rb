#!/usr/bin/ruby

NAME = "RAMDisk"
GB = 1024 ** 3
BLOCK_SIZE = 512
COMMANDS = ["up", "sync", "eject", "down"]

def die(msg="Usage: ramdisk {up,sync,eject} size_in_GiB from_dir")
  puts msg
  exit 1
end

die unless ARGV.size > 2

command = ARGV[0]
from = ARGV[2]
size_in_gib = ARGV[1].to_i

class RamDisk
  attr_accessor :from, :to

  def initialize(from, size_in_gib)
    @from = from
    @to = "/Volumes/#{NAME}"

    @size_in_gib = size_in_gib
    @size = (size_in_gib * GB) / BLOCK_SIZE
  end

  def up
    die "#{@to} already exists" if File.exists? @to

    puts "Spinning up #{@size_in_gib} GiB disk from #{@from} ..."
    system "diskutil erasevolume HFS+ '#{NAME}' `hdiutil attach -nomount ram://#{@size}`"
  end

  def down
    die "#{@to} doesn't exist" unless File.exists? @to
    
    puts "Spinning down #{@size_in_gib} GiB disk '#{NAME}' ..."
    system "diskutil unmount #{@to}"
  end

  def unload
    die "#{@to} doesn't exist" unless File.exists? @to

    puts "Synchronizing RAMDisk #{@to} to persistent store at '#{@from}' ..."
    system "rsync -azh --ignore-errors --delete #{@to}/ #{@from}"
  end

  def load
    puts "Copying into RAMDisk from '#{@from}' ..."
    system "rsync -azh --ignore-errors --delete #{@from}/ #{@to}"
  end
end


ram_disk = RamDisk.new(from, size_in_gib)
case command
when "", nil
  die
when "up"
  ram_disk.up
  ram_disk.load

when "sync"
  ram_disk.unload

when "down", "eject"
  ram_disk.unload
  ram_disk.down
end

puts "ok!"
