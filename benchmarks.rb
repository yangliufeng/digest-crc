#!/usr/bin/env ruby
require 'benchmark'
$LOAD_PATH.unshift(File.expand_path('lib'))

CRCs = {
  'crc1'         => 'CRC1',
  'crc5'         => 'CRC5',
  'crc8'         => 'CRC8',
  'crc8_1wire'   => 'CRC81Wire',
  'crc16'        => 'CRC16',
  'crc16_ccitt'  => 'CRC16CCITT',
  'crc16_dnp'    => 'CRC16DNP',
  'crc16_modbus' => 'CRC16Modbus',
  'crc16_qt'     => 'CRC16QT',
  'crc16_usb'    => 'CRC16USB',
  'crc16_xmodem' => 'CRC16XModem',
  'crc16_zmodem' => 'CRC16ZModem',
  'crc24'        => 'CRC24',
  'crc32'        => 'CRC32',
  'crc32c'       => 'CRC32c',
  'crc32_mpeg'   => 'CRC32Mpeg',
  'crc64'        => 'CRC64',
}

puts "Loading Digest::CRC classes ..."
CRCs.each_key { |crc| require "digest/#{crc}" }

puts "Generating random lengthed strings ..."
SAMPLES = Array.new(100) do
  Array.new(100 * rand(1024)) { rand(256).chr }.join
end

puts "Benchmarking Digest::CRC classes ..."
Benchmark.bm do |b|
  CRCs.each_value do |crc|
    crc_class = Digest.const_get(crc)
    crc = crc_class.new

    b.report("#{crc_class}#update") do
      SAMPLES.each do |sample|
        crc.update(sample)
      end
    end
  end
end
